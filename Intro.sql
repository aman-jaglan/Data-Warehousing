-- ********************************************
-- AFTER IMPORTING THE PRACDATA DATABASE 
-- ********************************************
-- FOR CASE 1.
-- FIRST COMMAND IS TO VIEW THE DATABASE
SELECT * FROM pracdata

-- SECOND COMMAND IS TO SELECT SOME COLUMNS FORM THE DATABASE THAT RETRIEVES THE ROWS AND SORTS THEM

SELECT OBJECTID,NAME,legal_description
FROM pracdata
ORDER BY OBJECTID ASC

-- THIRD COMMAND IS TO SELECT COLUMNS AND ADD THE VALUE AND STORE IN NEW COLUMN

SELECT OBJECTID, legal_description ,cert_land_value + cert_improvement_value AS total_land_value
FROM pracdata
WHERE OBJECTID > 800

-- FOURTH COMMAND IS TO SELECT THOSE PROPRETIES WHOSE VALUES IS IN BETWEEN 1000000 TO 2000000

SELECT OBJECTID,NAME, owner1,SoldPrice
FROM pracdata
WHERE
    CAST(
        REPLACE(REPLACE(soldprice, '$', ''), ',', '')
        AS DECIMAL(15, 4)
    ) >= 100000.0000
    AND CAST(
        REPLACE(REPLACE(soldprice, '$', ''), ',', '')
        AS DECIMAL(15, 4)
    ) <= 200000.0000
ORDER BY OBJECTID ASC

-- FOR CASE 2.
-- LET'S CREATE THE TWO TABLE. THE FIRST TABLE WOULD BE PRACDATA1.

CREATE TABLE pracdata1(
	OBJECTID varchar(4) PRIMARY KEY,
    NAME varchar(17),
    StatePIN varchar(24),
    legal_description varchar(94),
    property_addr varchar(31),
    cert_land_value varchar(7),
    cert_improvement_value varchar(8),
    cert_total_value varchar(8),
    owner_street varchar(31),
    owner_city varchar(24)
);
-- INSERT THE DATA INTO FIRST TABLE.
INSERT INTO pracdata1(OBJECTID,NAME,legal_description,StatePIN,property_addr,cert_land_value,cert_improvement_value,cert_total_value,owner_street,owner_city)
SELECT OBJECTID,NAME,legal_description,StatePIN,property_addr,cert_land_value,cert_improvement_value,cert_total_value,owner_street,owner_city
FROM pracdata

-- LET'S CREATE THE SECOND TABLE PRACDATA2
CREATE TABLE pracdata2(
	OBJECTID varchar(4) PRIMARY KEY,
    owner1 varchar(36),
    owner2 varchar(64),
    owner_state varchar(2),
    owner_zip varchar(10),
    grade varchar(3),
    tcondition varchar(2),
    property_class varchar(3),
    nbhd varchar(7),
    SoldPrice varchar(17),
    ConveyanceDate varchar(22),
);

-- INSERT THE DATA INTO SECOND TABLE
INSERT INTO pracdata2(OBJECTID, owner1,owner2,owner_state,owner_zip,nbhd,tcondition,SoldPrice,ConveyanceDate,property_class,grade)
SELECT OBJECTID, owner1,owner2,owner_state,owner_zip,nbhd,tcondition,SoldPrice,ConveyanceDate,property_class,grade
FROM pracdata

-- NOW CREATE THE FOREIGN KEY FOR PRACDATA2 WHICH WORK AS A PRIMARY KEY FOR FIRST TABLE PRACDATA1 TO ESTABLISH A ONE TO ONE RELATIONSHIP.

ALTER TABLE pracdata2
ADD FOREIGN KEY (OBJECTID) REFERENCES pracdata1(OBJECTID)

-- NOW PERFORM THE SAME COMMANDS FOR THESE TWO TABLES

SELECT * FROM pracdata1

-- SECOND COMMAND

SELECT OBJECTID,NAME,legal_description
FROM pracdata1
ORDER BY OBJECTID ASC

-- THIRD COMMAND

SELECT OBJECTID, legal_description ,cert_land_value + cert_improvement_value AS total_land_value
FROM pracdata1
WHERE OBJECTID > 800

-- I HAVE TWO COLUMNS IN PRACDATA2 AND TWO IN PRACDATA1 NOW I HAVE TO CREATE A INNER JOIN TO PERFORM THE SAME QUERY.
-- THE COMMAND LOOK LIKE THIS.

SELECT p1.OBJECTID, p1.NAME, p2.owner1, p2.SoldPrice
FROM pracdata1 p1
INNER JOIN pracdata2 p2 ON p1.OBJECTID = p2.OBJECTID
WHERE
    CAST(
        REPLACE(REPLACE(p2.soldprice, '$', ''), ',', '')
        AS DECIMAL(15, 4)
    ) >= 100000.0000
    AND CAST(
        REPLACE(REPLACE(p2.soldprice, '$', ''), ',', '')
        AS DECIMAL(15, 4)
    ) <= 200000.0000
ORDER BY p1.OBJECTID ASC;