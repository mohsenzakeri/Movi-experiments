#################################################### scalability rules

rule create_pangenome_n:
    input:
        fasta_list = "{exp}/refs/hprc.txt",
    output:
        pangenome_txt = "{exp}/refs/hprc_{n}.txt",
        pangenome_fasta = "{exp}/refs/hprc_{n}.fasta"
    run:
        cmd = "head -n {wildcards.n} > {wildcards.exp}/refs/hprc_{wildcards.n}.txt"
        print(cmd)
        shell(cmd)
        cmd = "cat $(grep -v '^#'  {wildcards.exp}/refs/hprc_{wildcards.n}.txt) > {wildcards.exp}/refs/hprc_{wildcards.n}.fasta"
        print(cmd)
        shell(cmd)