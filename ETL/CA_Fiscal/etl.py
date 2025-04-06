#!/usr/bin/env python3
import os
import subprocess
import zipfile
import tempfile
import duckdb
import re
import csv
import io
from pathlib import Path

def extract_files_from_exe(exe_path, output_dir, extensions=('.mdb', '.accdb', '.txt')):
    """
    Extract specified file types from an .exe file (which is actually a zip file)
    """
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # List of extracted files
    extracted_files = []
    
    # Get the base exe filename without extension
    exe_filename = Path(exe_path).stem
    
    # Open the .exe as a zip file
    try:
        with zipfile.ZipFile(exe_path, 'r') as zip_ref:
            # Print list of files in the zip for debugging
            print(f"Files in {exe_path}:")
            for item in zip_ref.infolist():
                print(f"  inflating: {item.filename}")
            
            # Extract all files to a temporary directory
            with tempfile.TemporaryDirectory() as temp_dir:
                zip_ref.extractall(temp_dir)
                
                # Find all specified file types in the extracted content
                for root, _, files in os.walk(temp_dir):
                    for file in files:
                        lower_filename = file.lower()
                        if any(lower_filename.endswith(ext) for ext in extensions):
                            # Source path of the found file
                            src_path = os.path.join(root, file)
                            # Destination path
                            dest_path = os.path.join(output_dir, file)
                            # Copy the file to the output directory
                            with open(src_path, 'rb') as src_file, open(dest_path, 'wb') as dest_file:
                                dest_file.write(src_file.read())
                            
                            # Store file info along with original exe filename
                            file_info = {
                                'path': dest_path,
                                'type': 'db' if lower_filename.endswith(('.mdb', '.accdb')) else 'txt',
                                'exe_filename': exe_filename
                            }
                            extracted_files.append(file_info)
                            print(f"Extracted: {dest_path}")
    except zipfile.BadZipFile:
        print(f"Error: {exe_path} is not a valid zip file.")
        return []
    
    return extracted_files

def get_table_names(db_file):
    """
    Get all table names from an Access database file using mdb-tools
    """
    try:
        result = subprocess.run(['mdb-tables', db_file], 
                               capture_output=True, 
                               text=True, 
                               check=True)
        tables = result.stdout.strip().split()
        return tables
    except subprocess.CalledProcessError as e:
        print(f"Error getting tables from {db_file}: {e}")
        return []
    except FileNotFoundError:
        print("Error: mdb-tools not found. Please install mdb-tools using Homebrew:")
        print("brew install mdbtools")
        return []

def normalize_table_name(table_name):
    """
    Normalize table names by keeping the alphabetic part and first digit
    For example, tsal116 -> tsal1
    """
    # Match alphabetic prefix followed by digits
    pattern = r'^([a-zA-Z]+)(\d)(\d+)$'
    match = re.match(pattern, table_name)
    
    if match:
        # Return the alphabetic part plus first digit
        return match.group(1) + match.group(2), True
    
    return table_name, False

def convert_access_db_to_parquet_duckdb(db_file, base_output_dir, exe_filename):
    """
    Convert all tables in an Access database file to parquet files using DuckDB
    """
    # Get table names
    tables = get_table_names(db_file)
    db_filename = Path(db_file).stem
    
    if not tables:
        print(f"No tables found in {db_file}")
        return []
    
    # Initialize DuckDB connection
    con = duckdb.connect(":memory:")
    
    # Process each table
    parquet_files = []
    for table in tables:
        # Skip system tables
        if table.startswith('MSys') or table.startswith('~'):
            continue
        
        try:
            print(f"Processing table: {table} from {db_filename}")
            
            # Normalize table name for directory structure
            normalized_name, was_normalized = normalize_table_name(table)
            
            # Create table directory
            table_dir = os.path.join(base_output_dir, normalized_name)
            os.makedirs(table_dir, exist_ok=True)
            
            # Export table to CSV using mdb-export
            csv_data = subprocess.run(['mdb-export', '-D', '%Y-%m-%d %H:%M:%S', db_file, table], 
                                     capture_output=True, 
                                     text=True, 
                                     check=True).stdout
            
            # Handle empty tables
            if not csv_data.strip():
                print(f"Table {table} is empty, skipping.")
                continue
                
            # Create a temp CSV file
            with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as temp_csv:
                temp_csv.write(csv_data)
                temp_csv_path = temp_csv.name
            
            # Output parquet file path - use the exe filename for the parquet file
            parquet_file = os.path.join(table_dir, f"{exe_filename}.parquet")
            
            # Use DuckDB to convert CSV to Parquet
            con.execute(f"""
                COPY (
                    SELECT * FROM read_csv_auto('{temp_csv_path}', header=true, all_varchar=true)
                ) TO '{parquet_file}' (FORMAT PARQUET);
            """)
            
            # Delete the temp CSV file
            os.unlink(temp_csv_path)
            
            parquet_files.append(parquet_file)
            print(f"Converted {table} from {db_filename} to {parquet_file}")
            
        except subprocess.CalledProcessError as e:
            print(f"Error exporting table {table} from {db_file}: {e}")
        except Exception as e:
            print(f"Error converting table {table} to parquet: {e}")
            # Try again with a more careful approach - using all_varchar option
            try:
                print(f"Retrying with fallback approach for {table}...")
                # Export table to CSV
                csv_data = subprocess.run(['mdb-export', '-D', '%Y-%m-%d %H:%M:%S', db_file, table], 
                                         capture_output=True, 
                                         text=True, 
                                         check=True).stdout
                
                # Create a temp CSV file
                with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as temp_csv:
                    temp_csv.write(csv_data)
                    temp_csv_path = temp_csv.name
                
                # Normalize table name for directory structure
                normalized_name, was_normalized = normalize_table_name(table)
                
                # Create table directory
                table_dir = os.path.join(base_output_dir, normalized_name)
                os.makedirs(table_dir, exist_ok=True)
                
                # Output parquet file path - use the exe filename
                parquet_file = os.path.join(table_dir, f"{exe_filename}.parquet")
                
                # Force all columns to be VARCHAR to avoid type conversion issues
                con.execute(f"""
                    COPY (
                        SELECT * FROM read_csv_auto('{temp_csv_path}', header=true, all_varchar=true)
                    ) TO '{parquet_file}' (FORMAT PARQUET);
                """)
                
                # Delete the temp CSV file
                os.unlink(temp_csv_path)
                
                parquet_files.append(parquet_file)
                print(f"Successfully converted {table} from {db_filename} to {parquet_file} with fallback approach")
            except Exception as e:
                print(f"Failed to convert {table} even with fallback approach: {e}")
    
    # Close DuckDB connection
    con.close()
    
    return parquet_files

def convert_txt_to_parquet_duckdb(txt_file, base_output_dir, exe_filename):
    """
    Convert a TXT file to parquet format using DuckDB
    """
    # Get the TXT filename without extension to use as directory name
    txt_filename = Path(txt_file).stem
    
    # Create directory with the same name as the TXT file
    txt_dir = os.path.join(base_output_dir, txt_filename)
    os.makedirs(txt_dir, exist_ok=True)
    
    # Output parquet file path - use the original EXE filename
    parquet_file = os.path.join(txt_dir, f"{exe_filename}.parquet")
    
    try:
        print(f"Processing TXT file: {txt_file}")
        
        # Initialize DuckDB connection
        con = duckdb.connect(":memory:")
        
        # Read the TXT file content to determine its format
        with open(txt_file, 'r', errors='replace') as f:
            sample = f.read(4096)  # Read a sample to determine format
        
        # Try to detect if it's tab-delimited, comma-delimited, or fixed-width
        # This is a simple heuristic; you might need to adjust for your specific files
        if '\t' in sample:
            delimiter = '\t'
            print(f"Detected tab-delimited format for {txt_file}")
        elif ',' in sample:
            delimiter = ','
            print(f"Detected comma-delimited format for {txt_file}")
        else:
            # Assume fixed-width or space-delimited
            # For fixed-width, we'd need specific column widths
            # Here we'll just use space as delimiter as a fallback
            delimiter = ' '
            print(f"Using space as delimiter for {txt_file} (might be fixed-width)")
        
        # Create a temporary CSV file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as temp_csv:
            # Read the TXT file and write properly formatted CSV
            with open(txt_file, 'r', errors='replace') as txt_f:
                lines = txt_f.readlines()
                
                # Check if there's a header row
                has_header = True  # Assume there's a header by default
                
                # Write to CSV
                csv_writer = csv.writer(temp_csv)
                for i, line in enumerate(lines):
                    fields = line.strip().split(delimiter)
                    if i == 0 and has_header:
                        # If all field values in the first row contain only digits,
                        # it might not be a header
                        if all(field.strip().isdigit() for field in fields if field.strip()):
                            has_header = False
                            # Generate default column names
                            header = [f"col{j+1}" for j in range(len(fields))]
                            csv_writer.writerow(header)
                    
                    # Write the data row
                    csv_writer.writerow(fields)
                    
            temp_csv_path = temp_csv.name
        
        # Use DuckDB to convert CSV to Parquet
        con.execute(f"""
            COPY (
                SELECT * FROM read_csv_auto('{temp_csv_path}', header=true, all_varchar=true)
            ) TO '{parquet_file}' (FORMAT PARQUET);
        """)
        
        # Delete the temp CSV file
        os.unlink(temp_csv_path)
        
        print(f"Converted TXT file {txt_filename} to {parquet_file}")
        return parquet_file
        
    except Exception as e:
        print(f"Error converting TXT file {txt_file} to parquet: {e}")
        try:
            print(f"Retrying with fallback approach for {txt_file}...")
            
            # Create temporary CSV with a more careful approach
            with tempfile.NamedTemporaryFile(mode='w', suffix='.csv', delete=False) as temp_csv:
                with open(txt_file, 'r', errors='replace') as txt_f:
                    content = txt_f.read()
                    
                # Try to infer delimiter from content
                for candidate in [',', '\t', '|', ';', ' ']:
                    if candidate in content:
                        delimiter = candidate
                        break
                else:
                    delimiter = ','  # Default fallback
                
                # Process line by line with the inferred delimiter
                csv_writer = csv.writer(temp_csv)
                lines = content.strip().split('\n')
                
                # Assume first line is header
                if lines:
                    headers = lines[0].split(delimiter)
                    csv_writer.writerow(headers)
                    
                    # Write data rows
                    for line in lines[1:]:
                        csv_writer.writerow(line.split(delimiter))
                
                temp_csv_path = temp_csv.name
            
            # Output parquet file path
            parquet_file = os.path.join(txt_dir, f"{exe_filename}.parquet")
            
            # Use DuckDB to convert CSV to Parquet with all_varchar option
            con = duckdb.connect(":memory:")
            con.execute(f"""
                COPY (
                    SELECT * FROM read_csv_auto('{temp_csv_path}', header=true, all_varchar=true)
                ) TO '{parquet_file}' (FORMAT PARQUET);
            """)
            
            # Delete the temp CSV file
            os.unlink(temp_csv_path)
            
            print(f"Successfully converted {txt_file} to {parquet_file} with fallback approach")
            return parquet_file
            
        except Exception as e:
            print(f"Failed to convert {txt_file} even with fallback approach: {e}")
            return None
        finally:
            # Close DuckDB connection
            con.close()

def process_exe_files(path, output_dir):
    """
    Process a single exe file or all exe files in a directory
    """
    exe_files = []
    
    # Check if path is a directory or a file
    if os.path.isdir(path):
        # Get all .exe files in the directory
        for root, _, files in os.walk(path):
            for file in files:
                if file.lower().endswith('.exe'):
                    exe_files.append(os.path.join(root, file))
    elif os.path.isfile(path) and path.lower().endswith('.exe'):
        # Single .exe file
        exe_files.append(path)
    else:
        print(f"Invalid path: {path}. Please provide a valid .exe file or a directory containing .exe files.")
        return
    
    if not exe_files:
        print(f"No .exe files found in {path}")
        return
    
    print(f"Found {len(exe_files)} .exe file(s) to process")
    # Create a single directory for all extracted files
    extracted_dir = os.path.join(output_dir, 'extracted_files')
    os.makedirs(extracted_dir, exist_ok=True)
    
    # Create the base directory for parquet output
    parquet_base_dir = os.path.join(output_dir, 'parquet')
    os.makedirs(parquet_base_dir, exist_ok=True)
    
    # Process each .exe file
    for exe_file in exe_files:
        print(f"\nProcessing: {exe_file}")
        exe_filename = Path(exe_file).stem
        
        # Extract all supported files from the current .exe
        extracted_files = extract_files_from_exe(exe_file, extracted_dir)
        
        if not extracted_files:
            print(f"No supported files found in {exe_file}")
            continue
        
        # Process each extracted file
        for file_info in extracted_files:
            file_path = file_info['path']
            file_type = file_info['type']
            exe_name = file_info['exe_filename']
            
            print(f"\nProcessing {file_type.upper()} file: {file_path}")
            
            if file_type == 'db':
                # Process Access database files
                convert_access_db_to_parquet_duckdb(file_path, parquet_base_dir, exe_name)
            elif file_type == 'txt':
                # Process TXT files
                convert_txt_to_parquet_duckdb(file_path, parquet_base_dir, exe_name)

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Extract Access database files (MDB/ACCDB) and TXT files from EXE and convert to Parquet')
    parser.add_argument('path', help='Path to an EXE file or directory containing EXE files')
    parser.add_argument('--output-dir', '-o', default='output', help='Output directory')
    args = parser.parse_args()
    
    # Create main output directory
    os.makedirs(args.output_dir, exist_ok=True)
    
    # Process exe file(s)
    process_exe_files(args.path, args.output_dir)

if __name__ == "__main__":
    main()