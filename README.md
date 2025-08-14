## Introduction
The dataset contains the information about JPMorgan Chase Bank's branches. Based on the columns, it includes detailed data on each branch such as branch information,geographical data,financial data and lots more.

### Data Cleaning and preprocessing
```python
import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv("datasets/chase.csv")

# Fill missing "Acquired Data" values with "Not Acquired"
df["Acquired Date"] = df["Acquired Date"].fillna("Not Acquired")

# Drop rows with missing Latitude or Longitude
df.dropna(subset=["Latitude","Longitude"],inplace=True)

# List of deposit columns with missing values
deposit_cols = ['2010 Deposits', '2011 Deposits', '2012 Deposits', '2013 Deposits', '2014 Deposits', '2015 Deposits']

# Fill missing values in deposit columns with 0
df[deposit_cols] = df[deposit_cols].fillna(0)

# Convert "Established Date" to datetime objects
df["Established Date"] = pd.to_datetime(df["Established Date"],errors="coerce")

# Convert "Acquired Date" to datetime objects, handling the "Not Acquired" string
# The "errors=coerce" argument will turn "Not Acquired" into a missing value (NaT)
df["Acquired Date"] = pd.to_datetime(df["Acquired Date"],errors="coerce")

# Rename columns for consistency
df.rename(columns={
    "Established Date": "established_date",
    "Acquired Date" : "acquired_date",
    "Street Address" : "street_address",
    "Branch Name" : "branch_name",
    "Zipcode" : "zipcode",
    "2010 Deposits" : "2010_deposits",
    "2011 Deposits" : "2011_deposits",
    "2012 Deposits": "2012_deposits",
    "2013 Deposits": "2013_deposits",
    "2014 Deposits": "2014_deposits",
    "2015 Deposits" : "2015_deposits",
    "Institution Name": "institution_name",
    "Main Office": "main_office",
    "Branch Number" : "branch_number",
    "2016 Deposits" : "2016_deposits",
    "County" : "county",
    "City" : "city",
    "State": "state",
    "Latitude" : "latitude",
    "Longitude" : "longitude"    
},inplace=True)

# Save the Cleaned Data
df.to_csv("datasets/chase_cleaned.csv")
print("Saved Successfully")
```

### Database and Table Setup
```sql
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
```

### Analysis
1. What is the total deposit amount for each state in 2016?

2. Which branch had the highest deposit amount in 2014, and what was that amount?

3. What is the average deposit amount for all branches in each county for the year 2015?

4. How many branches were established in each year?

5. List the top 5 branches with the highest growth in deposits between 2010 and 2016.

6. Which branches were established after the year 2000 and are located in the state of 'FL'?

7. Find the state with the highest number of branches and the total count of branches in that state.

8. What is the total number of branches where the branch_name contains the word 'Bank'?

9. Find all branches where the established_date is earlier than the acquired_date.

10. For branches in each city, what is the difference in deposits between the years 2016 and 2010?

#### What is the total deposit amount for each state in 2016?
```sql
SELECT state,SUM(2016_deposits) AS total_deposits_2016
FROM chase
GROUP BY state
ORDER BY total_deposits_2016 DESC;
```
![question2](/assets/question1.png)

#### Which branch had the highest deposit amount in 2014, and what was that amount?
```sql
SELECT branch_name,2014_deposits
FROM chase
ORDER BY 2014_deposits DESC
LIMIT 1;
```
![question2](/assets/question2.png)

#### What is the average deposit amount for all branches in each county for the year 2015?
```sql
SELECT county,AVG(2015_deposits) AS average_deposits_2015
FROM chase
GROUP BY county
ORDER BY average_deposits_2015 DESC;
```
![question3](/assets/question3.png)

#### How many branches were established in each year?
```sql
SELECT SUBSTR(established_date,1,4) AS establishment_year,COUNT(*) AS number_of_branches
FROM chase
GROUP BY establishment_year
ORDER BY establishment_year;
```
![question4](/assets/question4.png)

#### List the top 5 branches with the highest growth in deposits between 2010 and 2016.
```sql
SELECT branch_name,(2016_deposits - 2010_deposits) AS deposit_growth
FROM chase
ORDER BY deposit_growth DESC
LIMIT 5;
```
![question5](/assets/question5.png)

#### Which branches were established after the year 2000 and are located in the state of 'FL'?
```sql
SELECT branch_name,established_date
FROM chase
WHERE SUBSTR(established_date,1,4) > "2000" AND state = "FL";
```

#### Find the state with the highest number of branches and the total count of branches in that state.
```sql
SELECT state,COUNT(*) AS branch_count
FROM chase
GROUP BY state
ORDER BY branch_count DESC
LIMIT 1;
```
![question7](/assets/question7.png)

#### What is the total number of branches where the branch_name contains the word 'Bank'?
```sql
SELECT COUNT(*) AS total_branches
FROM chase
WHERE branch_name LIKE "%Bank%";
```

#### Find all branches where the established_date is earlier than the acquired_date.
```sql
SELECT branch_name,established_date,acquired_date
FROM chase
WHERE established_date < acquired_date;
```

#### For branches in each city, what is the difference in deposits between the years 2016 and 2010?
```sql
SELECT city,SUM(2016_deposits) - SUM(2010_deposits) AS deposit_difference
FROM chase
GROUP BY city
ORDER BY deposit_difference DESC;
```