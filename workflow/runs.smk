chm13_fasta = config["CHM13_FASTA"]
pbsim2_dir = config["PSBISM2_DIR"]
pbsim2_binary = pbsim2_dir + "/src/pbsim"

#################################################### run rules

rule run_minimap2:
    input:
        index = "{exp}/indexes/minimap2.{ref}.{alphabet}/minimap2.index",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        alignments = "{exp}/runs/{sample}.{ref}.{alphabet}.minimap2.alignments.paf",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.minimap2.alignments.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.minimap2.alignments.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.minimap2.alignments.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = " --secondary=no -t 16 -x map-ont -o {output.alignments} {input.index} {input.reads}"
        cmd = create_command(output.time, minimap2, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule run_fulgor:
    input:
        index = "{exp}/indexes/fulgor.{ref}.{alphabet}/fi.hybrid.index",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_alignments = "{exp}/runs/{sample}.{ref}.{alphabet}.fulgor.pseudo_alignments",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.fulgor.pseudo_alignments.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.fulgor.pseudo_alignments.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.fulgor.pseudo_alignments.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = "pseudoalign -i {input.index} -q {input.reads} -o {output.pseudo_alignments} -t 1"
        cmd = create_command(output.time, fulgor, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule run_spumoni:
    input:
        index = "{exp}/indexes/spumoni.{ref}.{alphabet}/sp.fa.thrbv.spumoni",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni.pseudo_lengths",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni.pseudo_lengths.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni.pseudo_lengths.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = "run -r {wildcards.exp}/indexes/spumoni.{wildcards.ref}.{wildcards.alphabet}/sp -p {input.reads} -P -n"
        cmd = create_command(output.time, spumoni, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.pseudo_lengths {output.pseudo_lengths}")

rule run_spumoni2:
    input:
        index = "{exp}/indexes/spumoni2.{ref}.{alphabet}/sp.bin.thrbv.spumoni",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni2.pseudo_lengths",
        report = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni2.report",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni2.pseudo_lengths.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni2.pseudo_lengths.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni2.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = "run -r {wildcards.exp}/indexes/spumoni2.{wildcards.ref}.{wildcards.alphabet}/sp -p {input.reads} -P -m -c"
        cmd = create_command(output.time, spumoni, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.pseudo_lengths {output.pseudo_lengths}")
        shell("mv {input.reads}.report {output.report}")

rule run_movi_default:
    input:
        index = "{exp}/indexes/movi_default.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = "query-pf {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_command(output.time, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.default.mpml.bin {output.pseudo_lengths}")

rule run_movi_constant:
    input:
        index = "{exp}/indexes/movi_constant.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths",
        log = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.log",
        time = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.time",
        cmd = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/runs")
        options = "query-pf {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_command(output.time, movi_constant, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.constant.mpml.bin {output.pseudo_lengths}")

#################################################### fasta rules

rule fastq_to_fasta:
    input:
        fastq = "{exp}/reads/{sample}.fastq"
    output:
        fasta = "{exp}/reads/{sample}.fasta"
    run:
        shell("cat {input.fastq} | paste - - - - |cut -f1,2| sed 's/@/>/'g | tr -s \"/t\" \"/n\" > {output.fasta}")

#################################################### fasta rules

rule simulate_pbsim2:
    input:
        fasta = chm13_fasta
    output:
        fastq = "{exp}/reads/pbsim2_{model}_{depth}X.fastq",
        log = "{exp}/reads/pbsim2_{model}_{depth}X.fastq.log",
        time = "{exp}/reads/pbsim2_{model}_{depth}X.fastq.time",
        cmd = "{exp}/reads/pbsim2_{model}_{depth}X.fastq.cmd"
    run:
        options = "--hmm_model {pbsim2_dir}/data/{wildcards.model}.model --prefix pbsim2_{wildcards.model}_{wildcards.depth}X --depth {wildcards.depth} {input.fasta}"
        cmd = create_command(output.time, pbsim2_binary, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("cat pbsim2_{wildcards.model}_{wildcards.depth}X*.fastq > {output.fastq}")
        shell("rm pbsim2_{wildcards.model}_{wildcards.depth}X*")