import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import time

# --- Configuration ---
BASE_OUTPUT_DIR = "data"
TARGET_PAGES = [
    {
        "url": "https://www.cde.ca.gov/ds/fd/fd/",
        "type": "sacs_alt" # Special handling based on filename
    },
    {
        "url": "https://www.cde.ca.gov/ds/fd/cs/",
        "type": "j90" # All files go to a specific directory
    }
]
# Be a polite crawler - identify yourself
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 (MyExeDownloaderScript/1.0)'
}
DOWNLOAD_DELAY_SECONDS = 1 # Add a small delay between downloads

# --- Helper Functions ---

def create_directory(path):
    """Creates a directory if it doesn't exist."""
    os.makedirs(path, exist_ok=True)
    print(f"Ensured directory exists: {path}")

def download_file(url, save_path):
    """Downloads a file from a URL to a specified path."""
    try:
        print(f"Attempting to download: {url}")
        response = requests.get(url, stream=True, headers=HEADERS, timeout=30) # Added timeout
        response.raise_for_status() # Raise an exception for bad status codes (4xx or 5xx)

        # Ensure directory exists just before saving
        create_directory(os.path.dirname(save_path))

        with open(save_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                if chunk: # filter out keep-alive new chunks
                    f.write(chunk)
        print(f"Successfully downloaded and saved to: {save_path}")
        return True
    except requests.exceptions.RequestException as e:
        print(f"Error downloading {url}: {e}")
    except Exception as e:
        print(f"An error occurred saving {url} to {save_path}: {e}")
    return False

# --- Main Logic ---

def main():
    """Main function to crawl pages and download files."""
    print("Starting crawler...")
    create_directory(BASE_OUTPUT_DIR) # Create the main 'data' directory

    for page_info in TARGET_PAGES:
        page_url = page_info["url"]
        page_type = page_info["type"]
        print(f"\nProcessing page: {page_url}")

        try:
            response = requests.get(page_url, headers=HEADERS, timeout=20)
            response.raise_for_status()
        except requests.exceptions.RequestException as e:
            print(f"Error fetching page {page_url}: {e}")
            continue # Skip to the next page if fetching fails

        soup = BeautifulSoup(response.content, 'html.parser')
        links_found = 0
        links_downloaded = 0

        for link in soup.find_all('a', href=True):
            href = link['href']

            # Check if the link ends with .exe (case-insensitive)
            if href.lower().endswith('.exe'):
                links_found += 1
                # Construct the absolute URL
                absolute_url = urljoin(page_url, href)

                # Extract the filename from the URL
                parsed_url = urlparse(absolute_url)
                filename = os.path.basename(parsed_url.path)

                if not filename:
                    print(f"Could not extract filename from URL: {absolute_url}. Skipping.")
                    continue

                # Determine the correct output directory based on page type and filename
                output_dir = None
                if page_type == "sacs_alt":
                    # Rule: check filename for 'sacs' or 'alt' (case-insensitive)
                    if 'sacs' in filename.lower():
                        output_dir = os.path.join(BASE_OUTPUT_DIR, "sacs", "raw")
                    elif 'alt' in filename.lower(): # Assuming 'alt' is the keyword
                        output_dir = os.path.join(BASE_OUTPUT_DIR, "alt", "raw")
                    else:
                        print(f"Warning: Filename '{filename}' from {page_url} doesn't contain 'sacs' or 'alt'. Skipping.")
                        # Optional: Define a default directory or uncomment below to save anyway
                        # output_dir = os.path.join(BASE_OUTPUT_DIR, "unknown", "raw")
                        continue # Skip if no clear category
                elif page_type == "j90":
                    output_dir = os.path.join(BASE_OUTPUT_DIR, "J-90", "raw")

                if output_dir:
                    save_path = os.path.join(output_dir, filename)
                    # Download the file
                    if download_file(absolute_url, save_path):
                        links_downloaded += 1
                        # Add a delay to be polite to the server
                        print(f"Waiting {DOWNLOAD_DELAY_SECONDS} second(s)...")
                        time.sleep(DOWNLOAD_DELAY_SECONDS)
                else:
                     # This case should ideally not be reached if logic above is sound
                     print(f"Error: Could not determine output directory for {filename} from {page_url}")


        print(f"Finished processing {page_url}. Found {links_found} .exe links, attempted to download {links_downloaded}.")

    print("\nCrawler finished.")

if __name__ == "__main__":
    main()