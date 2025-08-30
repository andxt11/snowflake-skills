CREATE DATABASE ZENAS_ATHLEISURE_DB;

CREATE SCHEMA PRODUCTS;

list @product_metadata;

select $1
from @product_metadata; 

select $1
from @product_metadata/product_coordination_suggestions.txt; 

create or replace file format zmd_file_format_1
RECORD_DELIMITER = '^';

select $1
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_1);

create file format zmd_file_format_2
FIELD_DELIMITER = '^';  

select $1,$2,$3,$4,$5,$6,$7,$8
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_2);
-------------------------------------------------------------

create or replace file format zmd_file_format_3
FIELD_DELIMITER = '='
RECORD_DELIMITER = '^'
TRIM_SPACE = TRUE; 

select $1, $2
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_3);
-----------------------------------------------------------
create or replace file format zmd_file_format_1
RECORD_DELIMITER = ';';

select $1 as sizes_available
from @product_metadata/sweatsuit_sizes.txt
(file_format => zmd_file_format_1);
------------------------------------------------------------

create or replace file format zmd_file_format_2
FIELD_DELIMITER = '|'
RECORD_DELIMITER = ';'
TRIM_SPACE = TRUE;  

create or replace view zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE as
select REPLACE($1, CHR(13)||CHR(10), '') AS product_code,
       $2 AS headband_description,
       $3 AS wristband_description
from @product_metadata/swt_product_line.txt
(file_format => zmd_file_format_2);


select *
from zenas_athleisure_db.products.SWEATBAND_PRODUCT_LINE;

----------------------------------------------------------
create view zenas_athleisure_db.products.sweatsuit_sizes as 
select REPLACE($1,CHR(13)||CHR(10)) AS SIZES_AVAILABLE
FROM  @product_metadata/sweatsuit_sizes.txt
(file_format => zmd_file_format_1)
WHERE SIZES_AVAILABLE <> '';

select *
from  zenas_athleisure_db.products.sweatsuit_sizes;

--------------------------------------------------------

Create or replace file format zmd_file_format_3
FIELD_DELIMITER = '='
RECORD_DELIMITER = '^'
TRIM_SPACE = TRUE; 

CREATE OR REPLACE VIEW zenas_athleisure_db.products.SWEATBAND_COORDINATION AS 
select  REPLACE($1,CHR(13)||CHR(10)) AS PRODUCT_CODE, 
$2 AS HAS_MATCHING_SWEATSUIT
from @product_metadata/product_coordination_suggestions.txt
(file_format => zmd_file_format_3);

SELECT *
FROM zenas_athleisure_db.products.SWEATBAND_COORDINATION;
--------------------------------------------------------

-- Testing
select product_code, has_matching_sweatsuit
from zenas_athleisure_db.products.sweatband_coordination;

select product_code, headband_description, wristband_description
from zenas_athleisure_db.products.sweatband_product_line;

select sizes_available
from zenas_athleisure_db.products.sweatsuit_sizes;
