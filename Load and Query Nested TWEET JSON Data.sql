--Load and Query Nested TWEET JSON Data
  
--Create database
CREATE DATABASE SOCIAL_MEDIA_FLOODGATES;

--Create an Ingestion Table for JSON Data
CREATE TABLE SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
(
  RAW_STATUS variant
);

--Create File Format for JSON Data 
create file format SOCIAL_MEDIA_FLOODGATES.PUBLIC.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = TRUE
allow_duplicate = FALSE
strip_outer_array = TRUE
strip_null_values = FALSE
ignore_utf8_errors = TRUE;

---- COPY DATA INTO THE CORRECT TABLE

COPY INTO SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
FROM @util_db.public.my_clean_stage
FILES = ('nutrition_tweets.json')
FILE_FORMAT = (FORMAT_NAME =SOCIAL_MEDIA_FLOODGATES.PUBLIC.json_file_format);

--Check data

SELECT * 
FROM SOCIAL_MEDIA_FLOODGATES.PUBLIC.TWEET_INGEST
LIMIT 10;

//simple select statements -- are you seeing 9 rows?
select raw_status
from tweet_ingest;

select raw_status:entities
from tweet_ingest;

select raw_status:entities:hashtags
from tweet_ingest;

//Explore looking at specific hashtags by adding bracketed numbers
//This query returns just the first hashtag in each tweet
select raw_status:entities:hashtags[0].text
from tweet_ingest;

//This version adds a WHERE clause to get rid of any tweet that 
//doesn't include any hashtags
select raw_status:entities:hashtags[0].text
from tweet_ingest
where raw_status:entities:hashtags[0].text is not null;

//Perform a simple CAST on the created_at key
//Add an ORDER BY clause to sort by the tweet's creation date
select raw_status:created_at::date
from tweet_ingest
order by raw_status:created_at::date;

//Flatten statements can return nested entities only (and ignore the higher level objects)
select value
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls);

select value
from tweet_ingest
,table(flatten(raw_status:entities:urls));

//Flatten and return just the hashtag text, CAST the text as VARCHAR
select value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

//Add the Tweet ID and User ID to the returned table so we could join the hashtag back to it's source tweet
select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::varchar as hashtag_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags);

--Create a View of the URL Data Looking "Normalized"
create or replace view social_media_floodgates.public.urls_normalized as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:display_url::text as url_used
from tweet_ingest
,lateral flatten
(input => raw_status:entities:urls)
);

select *
from social_media_floodgates.public.urls_normalized

--Create a View of the Hastag Data Looking "Normalized"
create or replace view social_media_floodgates.public.HASHTAGS_NORMALIZED as
(select raw_status:user:name::text as user_name
,raw_status:id as tweet_id
,value:text::varchar as HASTAG_USED
from tweet_ingest
,lateral flatten
(input => raw_status:entities:hashtags)
);
--
SELECT *
FROM social_media_floodgates.public.HASHTAGS_NORMALIZED;
-----------------------------------------------------------------------------