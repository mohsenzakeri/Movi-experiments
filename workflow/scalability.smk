#################################################### scalability rules

rule create_scalability_refs:
    input:
        fasta_list = "{exp}/refs/{exp}.txt",
    output:
        scalability_list = "{exp}/refs/{exp}_{i}.txt",
    run:
        cmd = "head -n{i} {input.fasta_list} > {wildcards.exp}/refs/{wildcards.exp}_{i}.txt"
        print(cmd)
        shell(cmd)