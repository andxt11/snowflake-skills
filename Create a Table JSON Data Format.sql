-- Create a Table Raw JSON Data

// JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

// Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);

---------------------------------------------------


//Create File Format for JSON Data 
create file format library_card_catalog.public.json_file_format1
type = 'JSON' 
compression = 'AUTO' 
enable_octal = TRUE
allow_duplicate = FALSE
strip_outer_array = TRUE
strip_null_values = FALSE
ignore_utf8_errors = TRUE; 

------------------------------------------------------------

-- Clean slate
CREATE OR REPLACE STAGE my_clean_stage;

--Load the data into the new table, using the created file format 
-- COPY DATA INTO THE CORRECT TABLE

COPY INTO library_card_catalog.public.author_ingest_json
FROM @util_db.public.my_clean_stage
FILES = ('author_with_header.json')
FILE_FORMAT = (FORMAT_NAME =library_card_catalog.public.json_file_format1);


---------------------------------------

//returns AUTHOR_UID value from top-level object's attribute
select raw_author:AUTHOR_UID
from author_ingest_json;

//returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;

-------------------------------------------------

// Create an Ingestion Table for the NESTED JSON Data
create or replace table library_card_catalog.public.nested_ingest_json 
(
  raw_nested_book VARIANT
);

---------------------------------------------------------------------
//Create File Format for Nested JSON Data 
create file format library_card_catalog.public.nested_json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = TRUE
allow_duplicate = FALSE
strip_outer_array = TRUE
strip_null_values = FALSE
ignore_utf8_errors = TRUE; 


--Load the data into the new table, using the created file format 

COPY INTO library_card_catalog.public.nested_ingest_json 
FROM @util_db.public.my_clean_stage
FILES = ('json_book_author_nested.json.txt')
FILE_FORMAT = (FORMAT_NAME =library_card_catalog.public.nested_json_file_format);


-----------------------------------------------------------------------

SELECT * 
FROM library_card_catalog.public.nested_ingest_json
LIMIT 10;

--------------------------------------------------------------------------

//a few simple queries
select raw_nested_book
from nested_ingest_json;

select raw_nested_book:year_published
from nested_ingest_json;

select raw_nested_book:authors
from nested_ingest_json;

----------------------------------------------------------------------------------

//Use these example flatten commands to explore flattening the nested book and author data
select value:first_name
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

select value:first_name
from nested_ingest_json
,table(flatten(raw_nested_book:authors));

//Add a CAST command to the fields returned
SELECT value:first_name::varchar, value:last_name::varchar
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);

//Assign new column  names to the columns using "AS"
select value:first_name::varchar as first_nm
, value:last_name::varchar as last_nm
from nested_ingest_json
,lateral flatten(input => raw_nested_book:authors);
