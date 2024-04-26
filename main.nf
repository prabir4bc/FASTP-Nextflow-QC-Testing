nextflow.enable.dsl = 2

params.dirPath = "/mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing"
params.fastpPath = "/usr/bin/fastp"

process fastqc {
    
    input:
    path dirPath

    output:
    path "${dirPath}/fastqc_output"

    script:
    """
    mkdir -p ${dirPath}/fastqc_output
    /usr/bin/fastqc -o ${dirPath}/fastqc_output ${dirPath}/*.fastq.gz
    """
}

process fastpProcess {
    input:
    path dirPath

    output:
    path "${dirPath}/fastp_output"

    script:
    """
    mkdir -p ${dirPath}/fastp_output
    for file in "${dirPath}"/*.fastq.gz
    do
        base=\$(basename "\$file" .fastq.gz)
        "${params.fastpPath}" -i "\$file" -o "${dirPath}/fastp_output/\${base}_fastp.html"
    done
    """
}

process parseHTML {
    input:
    path htmlDir

    output:
    path "${htmlDir}"

    script:
    """
    python3 - << 'EOF' "${htmlDir}"
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

    return total_sequences

def main():
    parser = argparse.ArgumentParser(description='Web scraping script to retrieve Total Sequences data from HTML files.')
    parser.add_argument('html_dir', type=str, help='Path to the directory containing HTML files')
    args = parser.parse_args()

    html_dir = args.html_dir
    output_file = os.path.join(html_dir, "data.txt")

    with open(output_file, 'w') as outfile:
        for html_file in os.listdir(html_dir):
            if html_file.endswith('.html'):
                html_path = os.path.join(html_dir, html_file)
                total_sequences = parse_html(html_path)
                if total_sequences is not None:
                    outfile.write(html_file + ": Total Sequences: " + str(total_sequences) + "\\n")
                    print(html_file + ": Total Sequences: " + str(total_sequences))
                else:
                    print(html_file + ": Total Sequences not found.")

if __name__ == "__main__":
    main()
EOF
    """
}
/*
workflow {
    fastqc(params.dirPath)
    fastpProcess(params.dirPath)
    htmlDir = "${params.dirPath}/fastqc_output"
    parseHTML(htmlDir)
}*/
workflow {
  
  fastqc(params.dirPath)
  fastpProcess(params.dirPath)
  parseHTML("${params.dirPath}/fastqc_output")
}




/*Fastqc and FASTP is working using this script
params.dirPath = "/mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing"
params.fastpPath = "/usr/bin/fastp"

process fastqc {
    
    input:
    path dirPath

    output:
    path "${dirPath}/fastqc_output"

    script:
    """
    mkdir -p ${dirPath}/fastqc_output
    /usr/bin/fastqc -o ${dirPath}/fastqc_output ${dirPath}/*.fastq.gz
    """
}

process fastpProcess {
    input:
    path dirPath

    output:
    path "${dirPath}/fastp_output"

    script:
    """
    mkdir -p ${dirPath}/fastp_output
    for file in "${dirPath}"/*.fastq.gz
    do
        base=\$(basename "\$file" .fastq.gz)
        "${params.fastpPath}" -i "\$file" -o "${dirPath}/fastp_output/\${base}_fastp.html"
    done
    """
}



process parseHTML {
    input:
    path htmlFile

    output:
    path "${dirPath}"

    script:
    """
    python3 /mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing/fastqc_web_scrapping.py ${htmlFile}
    """
}

workflow {
    fastqc(params.dirPath)
    fastpProcess(params.dirPath)
    htmlFiles = Channel.fromPath("${params.dirPath}/fastqc_output/*.html")
    htmlFiles.view()
    parseHTML(htmlFiles)
}

*/

/*
nextflow.enable.dsl = 2

params.dirPath = "/mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing"

process fastqc {
    input:
    path dirPath

    output:
    path "fastqc_output"

    script:
    """
    mkdir -p fastqc_output
    /usr/bin/fastqc -o fastqc_output ${dirPath}/*.fastq.gz
    """
}

workflow {
    fastqc(params.dirPath)
}
*/
/*
nextflow.enable.dsl = 2

params.dirPath = "/mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing"

process fastqc {
    
    input:
    path dirPath

    output:
    path "${dirPath}/fastqc_output"

    script:
    """
    mkdir -p ${dirPath}/fastqc_output
    /usr/bin/fastqc -o ${dirPath}/fastqc_output ${dirPath}/*.fastq.gz
    """
}

process parseHTML {
    input:
    path htmlFile

    output:
    path "${dirPath}"

    script:
    """
    python3 /mnt/p/Workplace/Nextflow/FASTP-Testing/Test2/FASTP-Nextflow-QC-Testing/fastqc_web_scrapping.py ${htmlFile}
    """
}

workflow {
    fastqc(params.dirPath)
    htmlFiles = Channel.fromPath("${params.dirPath}/fastqc_output/*.html")
    htmlFiles.view()
    parseHTML(htmlFiles)
}
*/