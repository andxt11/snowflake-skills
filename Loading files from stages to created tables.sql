--After creating stage named 'MY_INTERNAL_STAGE' , loading a file in it. 

--Creating a table 
create or replace table vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

--Creating a file format
create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

--Loading the file from the stage 'MY_INTERNAL_STAGE' to the table created 

copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );

------------------------------------------------------------------------------------------------------------------------------------------

--Loading another file in the same way

CREATE TABLE L9_CHALLENGE(
$1 NUMBER(1,0),
$2 VARCHAR(20),
$3 VARCHAR(100)
);


-- 1. Create the file format
CREATE OR REPLACE FILE FORMAT garden_plants.veggies.L9_CHALLENGE_FF 
    TYPE = 'CSV'
    FIELD_DELIMITER = '\t'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- 2. Preview the staged file
SELECT $1, $2, $3
FROM @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(FILE_FORMAT => GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF);

--3. CREATE TABLE
create or replace table LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
 );

--4. Copy data into the correct table 
COPY INTO GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE
FROM @util_db.public.my_internal_stage
FILES = ('LU_SOIL_TYPE.tsv')
FILE_FORMAT = (FORMAT_NAME = GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF);

SELECT *
FROM LU_SOIL_TYPE;

-------------------------------------------------------------------------------------------------------------------------------------

