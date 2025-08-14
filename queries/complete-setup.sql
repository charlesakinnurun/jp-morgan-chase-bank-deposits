-- Create Database
CREATE SCHEMA `chase_bank`;

-- Create Table
CREATE TABLE chase(
    id INT NOT NULL,
    institution_name VARCHAR(255) NOT NULL,
    main_office INT NOT NULL,
    branch_name VARCHAR(255) NOT NULL,
    branch_number INT NOT NULL,
    established_date DATE,
    acquired_date DATE,
    street_address VARCHAR(255),
    city VARCHAR(255),
    county VARCHAR(255),
    state VARCHAR(255),
    zipcode INT,
    latitude DECIMAL(18,9),
    longitude DECIMAL(18,9),
    2011_deposits BIGINT,
    2011_deposits BIGINT,
    2012_deposits BIGINT,
    2013_deposits BIGINT,
    2014_deposits BIGINT,
    2015_deposits BIGINT,
    2016_deposits BIGINT,
    PRIMARY KEY (id)
)