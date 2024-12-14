import pandas as pd

# Read the Excel file into a pandas DataFrame
df = pd.read_excel('essaassistance24.xlsx', sheet_name='2024-25 ESSA State Schools', header=None) 

# Extract header row from the third row
header_row = df.iloc[2].tolist() 

# Remove the first two rows (including header row)
df = df.iloc[3:] 

# Set the header row
df.columns = header_row

# Print or save the DataFrame
df.to_csv('essa.csv', index=False)