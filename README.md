
<!--------------------------------------------------------------------------------------------------------------------------------------------------------------------->

<!-- ![header](/assets/chase_bank_header.png)-->

![header](/assets/jpmorgan_header.png)

<h1 align="center">Chase Bank Deposits Trends Analysis</h1>

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------------->
<!--
<p>What I learned</p>

-   How to clean and preprocess messy tabular data (fill missing values, convert dates, standardize column names).
-   How to write SQL queries for aggregation (SUM, AVG, COUNT) and filtering (WHERE, LIKE, GROUP BY).
-   How to interpret deposit trends across states, counties, and time (growth between 2010–2016).
-->

<p> What I did</p>

-   Loaded the raw branch deposit dataset and cleaned it (handled missing values, converted dates, renamed columns).
-   Built a SQL schema and table for the cleaned data.
-   Ran analysis queries to answer questions about top states, branches, growth trends, and branch counts.

<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------->


<h2 align="center">Workflow</h1>

<!----------------------------------------------------------------------------------------------------------------------------------------------------------------------->

- Data Collection

    | Institution Name        | Main Office | Branch Name | Branch Number | Established Date | Street Address | City | County | State | Zipcode | Latitude | Longitude | 2010 Deposits | 2011 Deposits | 2012 Deposits | 2013 Deposits | 2014 Deposits | 2015 Deposits | 2016 Deposits |
    |-------------------------|------------|------------|--------------|------------------|---------------|------|--------|-------|---------|----------|-----------|---------------|---------------|---------------|---------------|---------------|---------------|---------------|
    | JPMorgan Chase Bank     | 1          | JPMorgan Chase Bank Main Office | 0 | 01/01/1824 | 1111 Polaris Parkway | Columbus | Delaware | OH | 43240 | 40.14453 | -82.99115 | 633131000.0 | 743268000.0 | 832455000.0 | 916543000.0 | 1.032549e+09 | 1.069425e+09 | 1155185000 |
    | JPMorgan Chase Bank     | 0          | Vernon Hills Scarsdale Branch | 2 | 3/20/1961 | 676 White Plains Road | Scarsdale | Westchester | NY | 10583 | 40.97008 | -73.80670 | 293229.0 | 310791.0 | 325742.0 | 327930.0 | 3.277920e+05 | 3.414750e+05 | 381558 |
    | ...                     | ...        | ...        | ...          | ...              | ...           | ...  | ...    | ...   | ...     | ...      | ...       | ...           | ...           | ...           | ...           | ...           | ...           | ... |
    | JPMorgan Chase Bank     | 0          | Lake Forest Branch | 7988 | 1/1/2016 | 5660 Read Blvd | New Orleans | Orleans | LA | 70127 | 30.03205 | -89.97260 | NaN | NaN | NaN | NaN | NaN | NaN | 94133 |
    | JPMorgan Chase Bank     | 0          | Buffalo-Mm Branch | 7989 | 1/1/2016 | 350 Main Street | Buffalo | Erie | NY | 14202 | 42.88429 | -78.87487 | NaN | NaN | NaN | NaN | NaN | NaN | 45596 |

    <a href="datasets\chase.csv">Check out the raw data</a>

<!------------------------------------------------------------------------------------------------------------------------------------------------------------------->

- <h4><a href="/scipt/cleaning.py">Data Preprocessing</a></h4>

    - Data Loading
    - Fill missing "Acquired Data" values with "Not Acquired"
    - Drop rows with missing Latitude or Longitude
    - List of deposit columns with missing values
    - Fill missing values in deposit columns with 0
    - Convert "Established Date" to datetime objects
    - Convert "Acquired Date" to datetime objects, handling the "Not Acquired" string
    - Rename columns for consistency
    - Save the Cleaned Data

    <a href="/scipt/cleaning.py">Check out the cleaning script</a>

<!--------------------------------------------------------------------------------------------------------------------------------------------------------------------->

- Data Loading

    | Institution Name | Main Office | Branch Name | Branch Number | Established Date | Street Address | City | County | State | Zipcode | Latitude | Longitude | 2010 Deposits | 2011 Deposits | 2012 Deposits | 2013 Deposits | 2014 Deposits | 2015 Deposits | 2016 Deposits |
    |------------------|------------|------------|--------------|------------------|---------------|------|--------|-------|---------|----------|-----------|--------------|--------------|--------------|--------------|--------------|--------------|--------------|
    | JPMorgan Chase Bank | 1 | JPMorgan Chase Bank Main Office | 0 | 1824-01-01 | 1111 Polaris Parkway | Columbus | Delaware | OH | 43240 | 40.14453 | -82.99115 | 633131000 | 743268000 | 832455000 | 916543000 | 1032549000 | 1069425000 | 1155185000 |
    | JPMorgan Chase Bank | 0 | Vernon Hills Scarsdale Branch | 2 | 3/20/1961 | 676 White Plains Road | Scarsdale | Westchester | NY | 10583 | 40.97008 | -73.80670 | 293229 | 310791 | 325742 | 327930 | 327792 | 341475 | 381558 |
    | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |
    | JPMorgan Chase Bank | 0 | Lake Forest Branch | 7988 | 1/1/2016 | 5660 Read Blvd | New Orleans | Orleans | LA | 70127 | 30.03205 | -89.97260 | 0 | 0 | 0 | 0 | 0 | 0 | 94133 |
    | JPMorgan Chase Bank | 0 | Buffalo-Mm Branch | 7989 | 1/1/2016 | 350 Main Street | Buffalo | Erie | NY | 14202 | 42.88429 | -78.87487 | 0 | 0 | 0 | 0 | 0 | 0 | 45596 |


    <a href="datasets\chase_cleaned.csv">Check out the cleaned data</a>

<!---------------------------------------------------------------------------------------------------------------------------------------------------------------->

- <h4><a href="/queries/schema.sql">Database Schema Setup</a></h4>

    ```sql
    -- Create Database
    CREATE SCHEMA `chase_bank`;
    ```


<!-------------------------------------------------------------------------------------------------------------------------------------------------------------------->

- <h4><a href="/queries/table.sql">Database Table Setup</a></h4>


    ```sql
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
    );
    ```
<!--------------------------------------------------------------------------------------------------------------------------------------------------------------->

<h2 align="center">Analysis</h2>

<!------------------------------------------------------------------------------------------------------------------------------------------------------------------>

- What are the Top 10 state with the highest deposit amount in 2016?

    ```sql
    SELECT state,SUM(2016_deposits) AS total_deposits_2016
    FROM chase
    GROUP BY state
    ORDER BY total_deposits_2016 DESC;
    ```



    | State | Total Deposits (2016) |
    |-------|----------------------:|
    | NY    | 151385380             |
    | TX    | 109526094             |
    | CA    | 103824272             |
    | IL    | 73966280              |
    | MI    | 40021790              |
    | AZ    | 26181633              |
    | FL    | 19710979              |
    | OH    | 19068602              |
    | IN    | 17070875              |
    | LA    | 16989963              |
    | WA    | 14659607              |
    | NJ    | 13494709              |
    | UT    | 11963846              |
    | WI    | 9410758               |
    | CO    | 8334593               |
    | OR    | 5825288               |
    | KY    | 5667540               |
    | CT    | 4448267               |
    | OK    | 2306162               |
    | WV    | 1812236               |
    | NV    | 1632736               |
    | GA    | 1245175               |
    | ID    | 653412                |
    | PA    | 0                     |
    | MA    | 0                     |
    | DC    | 0                     |


    <a href="datasets\state_deposit.csv">Check out the data</a>


    ![question1](/assets/question1.png)


---


<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


- What are the Top 5 branches with the highest deposit amount in 2014?


    ```sql
    SELECT branch_name,2014_deposits
    FROM chase
    ORDER BY 2014_deposits DESC
    LIMIT 5;
    ```


    | Branch Name                       | 2014 Deposits |
    |----------------------------------|--------------:|
    | Madison Ave Abd 48th St Branch   | 98322162      |
    | Houston Main Office              | 82408236      |
    | Chicago's Main Office Branch     | 47103774      |
    | Detroit Main Branch              | 18121683      |
    | Chase Tower Branch               | 5857726       |
    


    <a href="datasets\top_5_branches_deposit_2014.csv">Check out the data</a>

    ![question2](/assets/question2.png)


---

<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


-   What are the average deposit amount for all branches in each county in 2015?


    ```sql
    SELECT county,AVG(2015_deposits) AS average_deposits_2015
    FROM chase
    GROUP BY county
    ORDER BY average_deposits_2015 DESC;
    ```

    | County                   | Average Deposits (2015) |
    |--------------------------|-------------------------:|
    | New York                 | 1.684863e+06             |
    | Harris                   | 5.498815e+05             |
    | Cook                     | 5.017104e+05             |
    | Denver                   | 4.935599e+05             |
    | Salt Lake                | 4.268664e+05             |
    | ...                      | ...                      |
    | Box Elder                | 1.507100e+04             |
    | Bannock                  | 1.325100e+04             |
    | Tangipahoa               | 1.323900e+04             |
    | Philadelphia             | 0.000000e+00             |
    | District of Columbia     | 0.000000e+00             |


    <a href="datasets\average_deposits_per_county.csv">Check out the data</a>

    ![question3](/assets/question3.png)




---



<!-------------------------------------------------------------------------------------------------------------------------------------------------------->



-   How many branches were established in each year?


    ```sql
    SELECT SUBSTR(established_date,1,4) AS establishment_year,COUNT(*) AS number_of_branches
    FROM chase
    GROUP BY establishment_year
    ORDER BY establishment_year;
    ```




    | Establishment Year | Number of Branches |
    |-------------------|-------------------:|
    | 1800              | 27                 |
    | 1812              | 2                  |
    | 1814              | 2                  |
    | 1825              | 1                  |
    | 1839              | 3                  |
    | ...               | ...                |
    | 2004              | 136                |
    | 2005              | 79                 |
    | 2006              | 67                 |
    | 2007              | 51                 |
    | 2008              | 18                 |


    <a href="datasets\branches_established_each_year.csv">Check out the data</a>


    ![question4](/assets/question4.png)




---


<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


-   List the top 5 branches with the highest growth in deposits between 2010 and 2016.


    ```sql
    SELECT branch_name,(2016_deposits - 2010_deposits) AS deposit_growth
    FROM chase
    ORDER BY deposit_growth DESC
    LIMIT 5;
    ```



    | Branch Name                       | Deposit Growth |
    |----------------------------------|---------------:|
    | Houston Main Office              | 31464197       |
    | Madison Ave Abd 48th St Branch   | 23945710       |
    | Chicago's Main Office Branch     | 14437942       |
    | Detroit Main Branch              | 12546146       |
    | One Utah Branch                  | 8415454        |


    <a href="datasets\top_5_branches_growth_2010_2016.csv">Check out the data</a>


    ![question5](/assets/question5.png)



---




<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


-   Which branches were established after the year 2000 in Florida?


    ```sql
    SELECT branch_name,established_date
    FROM chase
    WHERE SUBSTR(established_date,1,4) > "2000" AND state = "FL";
    ```




    | Branch Name                               | Established Date |
    |--------------------------------------------|------------------|
    | Aston Gardens Banking Center Branch        | 2003-05-23       |
    | Aston Gardens Naples Banking Center Branch | 2004-05-04       |
    | Kendall Park Plaza Branch                  | 2001-02-05       |
    | Wekiva Branch                              | 2001-11-13       |
    | Cocoa Commons Branch                       | 2002-02-04       |
    | ...                                        | ...              |
    | West Country Club Branch                   | 2007-06-25       |
    | Doral Plaza Branch                         | 2007-07-01       |
    | Mall At 163rd Branch                       | 2007-08-01       |
    | Stadium Corners Branch                     | 2007-11-13       |
    | Bay Meadows Branch                         | 2007-11-13       |


    <a href="datasets\branch_florida_2000.csv">Check out the data</a>

---


<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


-   What are the Top 10 States based on number of branches?


    ```sql
    SELECT state,COUNT(*) AS branch_count
    FROM chase
    GROUP BY state
    ORDER BY branch_count DESC
    LIMIT 10;
    ```




    | State | Branch Count |
    |-------|-------------:|
    | CA    | 666          |
    | NY    | 501          |
    | TX    | 444          |
    | OH    | 251          |
    | IL    | 219          |
    | MI    | 217          |
    | FL    | 207          |
    | WA    | 182          |
    | AZ    | 171          |
    | IN    | 162          |



    <a href="datasets\top_10_states_by_branch.csv">Check out the data</a>

    ![question7](/assets/question7.png)



---


<!-------------------------------------------------------------------------------------------------------------------------------------------------------->


-   What is the total number of branches where the branch_name contains the word 'Bank'?


    ```sql
    SELECT COUNT(*) AS total_branches
    FROM chase
    WHERE branch_name LIKE "%Bank%";
    ```


    | total_branches |
    |---------------:|
    | 165            |


    <a href="datasets\number_branches_bank.csv">Check out the data</a>

---

<!-------------------------------------------------------------------------------------------------------------------------------------------------------->

- what are the difference in deposits between 2016 and 2010 for branches in each city?



    ```sql
    SELECT city,SUM(2016_deposits) - SUM(2010_deposits) AS deposit_difference
    FROM chase
    GROUP BY city
    ORDER BY deposit_difference DESC;
    ```

    | City              | Deposit Difference |
    |-------------------|-------------------:|
    | Houston           | 37149291           |
    | New York City     | 31687570           |
    | Chicago           | 17992604           |
    | Detroit           | 12724043           |
    | Salt Lake City    | 8824071            |
    | ...               | ...                |
    | Wichita Falls     | -44603             |
    | Merrillville      | -46079             |
    | Amarillo          | -48956             |
    | Elk Grove Village | -68374             |
    | Park City         | -3505400           |

    <a href="datasets\branch_diff_2010_2016.csv">Check out the data</a>