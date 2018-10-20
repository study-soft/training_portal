ALTER ROLE postgres SET SEARCH_PATH = training_portal;
SHOW search_path;

-- set current schema
SET search_path TO public;