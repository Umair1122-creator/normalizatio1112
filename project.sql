--Normalization 
-- Creating the 'university_professor' table for importing data from csv file.  
CREATE TABLE university_professor(
firstname varchar(200),
lastname varchar(200),
university varchar(200),
university_shortname varchar(200),
university_city varchar(200),
function varchar(200),
organization varchar(200),
organization_sector varchar(200)
)

-- importing data into university_professor table
COPY university_professor(firstname, lastname, university, university_shortname, university_city, function, organization, organization_sector)
FROM 'D:\uni\university_professor.csv'
DELIMITER ','
CSV HEADER;

SELECT *FROM university_professor

-- First Normal Form (1NF): Ensuring atomic values and uniqueness in each column
-- The original table already satisfies 1NF since all columns contain atomic values without repeating groups.

-- Second Normal Form (2NF): Removing partial dependencies by creating separate tables for university and organization

-- Step 1: Create the 'universities' table to store unique university information
CREATE TABLE universities (
    university_id SERIAL PRIMARY KEY,
    university VARCHAR(200) UNIQUE,
    university_shortname VARCHAR(200),
    university_city VARCHAR(200)
);

-- Step 2: Create the 'organization' table to store unique organization information
CREATE TABLE organizations (
    organization_id SERIAL PRIMARY KEY,
    organization VARCHAR(200) UNIQUE,
    organization_sector VARCHAR(200)
);

-- Third Normal Form (3NF): Removing transitive dependencies by ensuring that non-key attributes depend only on the primary key

-- Step 3: Create the 'professors' table to store professor and function details
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    university_id INT REFERENCES universities(university_id),
    function VARCHAR(255),
    organization_id INT REFERENCES organizations(organization_id)
);



-- Step 4: Insert unique universities into the 'universities' table
INSERT INTO universities (university, university_shortname, university_city)
SELECT DISTINCT university, university_shortname, university_city
FROM university_professor;
SELECT *FROM universities;

-- Step 5: Insert unique organizations into the 'organizations' table
INSERT INTO organizations (organization, organization_sector)
SELECT DISTINCT organization, organization_sector
FROM university_professor;
SELECT *FROM organizations;

-- BCNF: Ensuring that every determinant is a candidate key
-- The 'universities' and 'organizations' tables are in BCNF because all non-trivial functional dependencies have candidate keys as their determinants.
-- The 'professors' table is also in BCNF because it references primary keys from the 'university' and 'organization' tables, ensuring no partial or transitive dependencies.

-- Step 6: Insert professor details into the 'professors' table
INSERT INTO professors (firstname, lastname, university_id, function, organization_id)
SELECT 
    firstname,
    lastname,
    u.university_id,
    function,
    o.organization_id
FROM university_professor t
JOIN universities u ON t.university = u.university
JOIN organizations o ON t.organization = o.organization;
SELECT *FROM professors;  