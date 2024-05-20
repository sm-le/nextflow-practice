#!/usr/bin/env nextflow
// shebang to declare nextflow as an interpreter

// parameter declaration
params.greeting = 'Hello world!'
// channel initialization 
greeting_ch = Channel.of(params.greeting) 

// begin SPLITLETTERS process block
process SPLITLETTERS { 
    // input qualifiers as val
    input: 
    val x 

    output: 
    path 'chunk_*' 

    script: 
    //"""
    //printf '$x' | split -b 6 - chunk_
    //"""
    """
    #!/home/smlee/miniconda3/bin/python3
    x='$x'
    for i, word in enumerate(x.split()):
        with open(f"chunk_{i}", "w") as f:
            f.write(word)
    """
    } 

process CONVERTTOUPPER { 
    input: 
    path y 

    output: 
    stdout 

    script: 
    """
    #!/home/smlee/miniconda3/bin/python3
    with open('$y') as f:
        print(f.read().upper())
    """
    
    //"""
    //cat $y | tr '[a-z]' '[A-Z]'
    //"""
} 

// start of the workflow block or scopre
workflow { 
    letters_ch = SPLITLETTERS(greeting_ch) 
    results_ch = CONVERTTOUPPER(letters_ch.flatten()) 
    results_ch.view { it } 
} 