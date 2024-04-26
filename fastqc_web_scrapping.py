import argparse
from bs4 import BeautifulSoup
import os

def parse_html(html_file):
    with open(html_file, 'r') as f:
        html_content = f.read()
    
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Find total sequences data
    total_sequences_elem = soup.find('td', string='Total Sequences')
    total_sequences = total_sequences_elem.find_next_sibling('td').get_text().strip() if total_sequences_elem else None

    if total_sequences is not None:
        output_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data.txt")
        with open(output_file, 'w') as outfile:
            outfile.write(f"Total Sequences: {total_sequences}\n")
            print(f"Total Sequences: {total_sequences}")
    else:
        print("Total Sequences not found in the HTML file.")

def main():
    parser = argparse.ArgumentParser(description='Web scraping script to retrieve Total Sequences data from an HTML file.')
    parser.add_argument('html_file', type=str, help='Path to the HTML file')
    args = parser.parse_args()

    parse_html(args.html_file)

if __name__ == "__main__":
    main()
