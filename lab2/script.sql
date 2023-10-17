-- create scheme'a for these exercises
create schema lab2

-- create necessary tables (4)
create table lab2.buildings(
	id SERIAL primary key,
	geometry GEOMETRY,
	"name" VARCHAR(20)
);

create table lab2.roads(
	id SERIAL primary key,
	geometry GEOMETRY,
	"name" VARCHAR(20)
);

create table lab2.poi(
	id SERIAL primary key,
	geometry GEOMETRY,
	"name" VARCHAR(20)
);

-- insert data (5)
insert into lab2.buildings("name", geometry) values
('BuildingA', 'POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'),
('BuildingB', 'POLYGON((6 5, 6 7, 4 7, 4 5, 6 5))'),
('BuildingC', 'POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))'),
('BuildingD', 'POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))'),
('BuildingF', 'POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))')

insert into lab2.roads("name", geometry) values
('RoadX', 'LINESTRING(0 4.5, 12 4.5)'),
('RoadY', 'LINESTRING(7.5 10.5, 7.5 0)')

insert into lab2.poi("name", geometry) values
('G', 'POINT(1 3.5)'),
('H', 'POINT(5.5 1.5)'),
('I', 'POINT(9.5 6)'),
('J', 'POINT(6.5 6)'),
('K', 'POINT(6 9.5)')

-- Solutions to Task 6

-- a
select SUM(ST_LENGTH(geometry)) from lab2.roads

-- b
select geometry, ST_AREA(geometry), ST_PERIMETER(geometry) from lab2.buildings where "name" = 'BuildingA'

-- c
select "name", ST_AREA(geometry) from lab2.buildings order by "name"

-- d
select "name", ST_PERIMETER(geometry) from lab2.buildings order by ST_AREA(geometry) desc limit 2

-- e
select ST_DISTANCE(t1.geometry, t2.geometry)
from 
(select "name", geometry from lab2.poi where "name" = 'K') t1
cross join 
(select "name", geometry from lab2.buildings b  where "name" = 'BuildingC') t2

-- f
select ST_AREA(ST_DIFFERENCE(t1.geometry, ST_EXPAND(t2.geometry, 0.5)))
from
(select "name", geometry from lab2.buildings b  where "name" = 'BuildingC') t1
cross join 
(select "name", geometry from lab2.buildings b  where "name" = 'BuildingB') t2

-- g
select * from lab2.buildings b where 
ST_Y(ST_CENTROID(geometry)) > (select ST_Y(ST_CENTROID(geometry)) from lab2.roads where "name" = 'RoadX')

-- h
select ST_AREA(ST_SYMDIFFERENCE(geometry, 'POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) 
from lab2.buildings where "name" = 'BuildingC'


