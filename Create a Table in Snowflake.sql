create or replace table ROOT_DEPTH(
ROOT_DEPTH_ID number(1), 
   ROOT_DEPTH_CODE text(1), 
   ROOT_DEPTH_NAME text(7), 
   UNIT_OF_MEASURE text(2),
   RANGE_MIN number(2),
   RANGE_MAX number(2)
);
insert into ROOT_DEPTH
values
( 1,
    'S',
    'Shallow',
    'cm',
    30,
    45);
select * 
from root_depth
limit 1;

insert into root_depth
values
(2,
'M',
'Medium',
'cm',
45,
60);
insert into root_depth
values
(3,
'D',
'Deep',
'cm',
60,
90); 
select * 
from root_depth



select * 
from garden_plants.information_schema.schemata;

SELECT * 
FROM GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 

select count(*) as schemas_found, '3' as schemas_expected 
from GARDEN_PLANTS.INFORMATION_SCHEMA.SCHEMATA
where schema_name in ('FLOWERS','FRUITS','VEGGIES'); 

---------------------------------------------------------------------------------------------------------------------

create table garden_plants.veggies.vegetable_details
(
plant_name varchar(25)
, root_depth_code varchar(1)    
);

-----------------------------------------------------------------------------------------------------------------------

delete from vegetable_details
where plant_name = 'Spinach'
and root_depth_code = 'D';

select * 
from vegetable_details;

--------------------------------------------------------------------------------------------------------------------

create or replace TABLE FLOWER_DETAILS (
	PLANT_NAME VARCHAR(25),
	ROOT_DEPTH_CODE VARCHAR(1)
);

