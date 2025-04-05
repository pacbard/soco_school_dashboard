import duckdb
import pandas as pd
import urllib.request

def download_essa_file():
  # Download the excel spreadsheet from CDE website: https://www.cde.ca.gov/sp/sw/t1/essaassistdatafiles.asp
  urllib.request.urlretrieve("https://www.cde.ca.gov/sp/sw/t1/documents/essaassistance24.xlsx", "data/essaassistance24.xlsx")

  # Read the Excel file into a pandas DataFrame
  df = pd.read_excel('data/essaassistance24.xlsx', sheet_name='2024-25 ESSA State Schools', header=None) 

  # Extract header row from the third row
  header_row = df.iloc[2].tolist() 

  # Remove the first two rows (including header row)
  df = df.iloc[3:] 

  # Set the header row
  df.columns = header_row

  # Print or save the DataFrame
  df.to_csv('data/essa.csv', index=False)

def download_school_file():
  # Download the CA school directory from CDE website: https://www.cde.ca.gov/schooldirectory/report?rid=dl1&tp=txt
  urllib.request.urlretrieve("https://www.cde.ca.gov/schooldirectory/report?rid=dl1&tp=txt", "data/pubschls.txt")

def run_sql_query(file, con):

    with open(file, 'r') as f:
      query = f.read()
      try:
        con.execute(query)
        print(f"Successfully executed query from {file}")
      except Exception as e:
        print(f"Error executing query from {file}: {e}")

if __name__ == "__main__":
    download_school_file()
    download_essa_file()

    con = duckdb.connect("CA_Dashboard.duckdb")

    sql_files = [
       "labels.sql", "schools.sql", "ESSA.sql",
       "CCI.sql", "CHRON.sql", "ELA.sql", "ELPI.sql", "GRAD.sql", "MATH.sql", "SUS.sql",
       "differentiatedAssistance.sql",
       "dashboard.sql"]
    for file in sql_files:
        run_sql_query(file, con)