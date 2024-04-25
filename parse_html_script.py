import argparse
from bs4 import BeautifulSoup

def parse_html(html_file):
    with open(html_file, 'r') as f:
        html_content = f.read()
    
    soup = BeautifulSoup(html_content, 'html.parser')
    
    # Find duplication rate data
    duplication_rate_elem = soup.find('td', class_='col1', text='duplication rate:')
    duplication_rate = duplication_rate_elem.find_next_sibling('td', class_='col2').text.strip() if duplication_rate_elem else None

    # Find insert size peak data
    insert_size_peak_elem = soup.find('td', class_='col1', text='Insert size peak:')
    insert_size_peak = insert_size_peak_elem.find_next_sibling('td', class_='col2').text.strip() if insert_size_peak_elem else None

    return duplication_rate, insert_size_peak

def main():
    parser = argparse.ArgumentParser(description='Web scraping script to retrieve data from an HTML file.')
    parser.add_argument('html_file', type=str, help='Path to the HTML file')
    args = parser.parse_args()

    duplication_rate, insert_size_peak = parse_html(args.html_file)
    if duplication_rate is not None:
        print("Duplication Rate:", duplication_rate)
    else:
        print("Duplication Rate not found in the HTML file.")
    
    if insert_size_peak is not None:
        print("Insert Size Peak:", insert_size_peak)
    else:
        print("Insert Size Peak not found in the HTML file.")

if __name__ == "__main__":
    main()
