-- Ad 1

select b.polygon_id, b."name", b.type, b."height", b.geom  from
lab3.buildings_2019 b
left outer join
lab3.buildings_2018 b2
on b.polygon_id = b2.polygon_id
where not ST_Equals(b.geom, b2.geom)

-- Ad 2

with renovated_buildings as (
select ST_UNION(b.geom) as geom  from
lab3.buildings_2019 b
left outer join
lab3.buildings_2018 b2
on b.polygon_id = b2.polygon_id
where not ST_Equals(b.geom, b2.geom)
),
new_poi as (
select p19.poi_id, p19.geom, p19."type", p18.poi_id as p18_id from
lab3.poi_2019 p19
left outer join
lab3.poi_2018 p18
on p19.poi_id = p18.poi_id
)
select
new_poi."type",
count(new_poi.poi_id) as count
from new_poi cross join renovated_buildings
where
ST_Distance(st_transform(new_poi.geom, 3068), st_transform(renovated_buildings.geom,3068)) < 500
group by
new_poi."type"

-- Ad 3

alter table streets_reprojected
add column new_geom geometry(multilinestring, 3068);
update streets_reprojected set new_geom = st_transform(geom, 3068);
select UpdateGeometrySRID('lab3', 'streets_reprojected', 'geom', 3068);
update streets_reprojected set geom = new_geom
alter table streets_reprojected
drop column new_geom

-- Ad 4

create table lab3.input_points(
	id SERIAL primary key,
	geometry GEOMETRY
);

insert into lab3.input_points
values
('POINT(8.36093 49.03174)'),
('POINT(8.39876 49.00644)');

-- Ad 5

alter table input_points
add column new_geom geometry(point, 3068);
update input_points set new_geom = st_transform(geom, 3068);
select UpdateGeometrySRID('lab3', 'input_points', 'geom', 3068);
update input_points set geom = new_geom;
alter table input_points
drop column new_geom

-- Ad 6

with input_line as (
	select st_makeline(geom) as input_line from lab3.input_points ip
)
select node_id, ST_Transform(geom, 3068) from
lab3.street_nodes_2019
cross join
input_line
where ST_Distance(st_transform(geom, 3068), input_line) < 200

-- Ad 7

with sport_stores as (
	select * from poi_2019
	where type = 'Sporting Goods Store'
), parks as (
	select ST_Union(geom) as parks from land_use_a_2019
	where "type" = 'Park (City/County)'
)
select count(*) from
sport_stores s
cross join
parks p
where
ST_Distance(st_transform(s.geom, 3068), st_transform(p.parks,3068)) < 300

-- Ad 8

create table T2019_KAR_BRIDGES as
select (ST_Dump(ST_Intersection(railways, rivers))).geom as geom
from
(SELECT ST_Union(geom) as railways
FROM lab3.railways_2019 r
) railways
cross join
(select ST_Union(geom) as rivers
from lab3.waterlines_2019 w
) rivers;





