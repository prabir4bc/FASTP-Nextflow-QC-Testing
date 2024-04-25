


nextflow.enable.dsl = 2

params {
    dirPath = "./"
    reportDir = dirPath
    htmlScript = "./parse_html_script.py"
}

process fastpAnalysis {
    container 'nanozoo/fastp:latest'
    input:
    file '*.fastq.gz' from dir(params.dirPath)
    output:
    file '*.html' into params.reportDir

    script:
    """
    fastp -i \${file} -o \${file.baseName}.html
    """
}

process parseHTML {
    input:
    file html from params.reportDir
    output:
    stdout result

    script:
    """
    python3 ${params.htmlScript} \${html}
    """
}

workflow {
    input:
    file(inputFiles) from fastqFiles

    output:
    file('*') into params.reportDir

    fastqFiles = Channel.fromPath("${params.dirPath}/*.fastq.gz")

    fastpAnalysis(inputFiles)
    parseHTML(params.reportDir)
}

