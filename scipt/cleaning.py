import pandas as pd

# Load the CSV file into a DataFrame
df = pd.read_csv("datasets/chase.csv")

# Fill missing "Acquired Data" values with "Not Acquired"
# df["Acquired Date"] = df["Acquired Date"].fillna("Not Acquired") 

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
# df["Acquired Date"] = pd.to_datetime(df["Acquired Date"],errors="coerce")

# Rename columns for consistency
df.rename(columns={
    "Established Date": "established_date",
    # "Acquired Date" : "acquired_date",
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
df.to_csv("datasets/chase_cleaned.csv",index=False)
print("Saved Successfully")