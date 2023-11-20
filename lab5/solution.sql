create schema lab5

-- Ad 1
create table lab5.obiekty (
	id serial primary key,
	"name" varchar,
	geom geometry
)

insert into lab5.obiekty ("name", geom) values
('obiekt1', 'COMPOUNDCURVE((0 1, 1 1), CIRCULARSTRING(1 1, 2 0, 3 1, 4 2, 5 1), (5 1, 6 1))'),
('obiekt2', ST_Collect(array['COMPOUNDCURVE((10 6, 14 6), CIRCULARSTRING(14 6, 16 4, 14 2, 12 0, 10 2), (10 2, 10 6))', 'CIRCULARSTRING(11 2, 12 3, 13 2, 12 1, 11 2)'])),
('obiekt3', 'LINESTRING(7 15, 10 17, 12 13, 7 15)'),
('obiekt4', 'LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'),
('obiekt5', 'MULTIPOINT( (30 30 59), (38 32 234) )'),
('obiekt6', ST_Collect(array['LINESTRING(1 1, 3 2)', 'POINT(4 2)']))

-- Ad 2

with obiekt3 as(
	select geom from lab5.obiekty where "name" = 'obiekt3'
),
obiekt2 as (
	select geom from lab5.obiekty where "name" = 'obiekt2'
)
select ST_Area(ST_Buffer(ST_ShortestLine(o2.geom, o3.geom), 5)) from obiekt2 o2 cross join obiekt3 o3

-- Ad 3
with obiekt4 as(
	select geom from lab5.obiekty where "name" = 'obiekt4'
)
select st_makepolygon( st_addpoint(geom, st_startpoint(geom)))
from obiekt4

-- Ad 4
with objects_to_merge as (
	select geom from lab5.obiekty where "name" = 'obiekt3' or "name" = 'obiekt4'
)
select ST_Collect(geom) from objects_to_merge

-- Ad 5
with objects_without_arc as (
	select * from lab5.obiekty where not ST_HasArc(geom)
)
select id, ST_AREA(ST_BUFFER(geom, 5)) from objects_without_arc
