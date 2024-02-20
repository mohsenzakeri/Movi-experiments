rindex = config['RINDEX_BUILD'] + "/ri-align"

#################################################### count rules

rule count_rindex:
    input:
        index = "{exp}/indexes/rindex.{ref}.{alphabet}/ref.fa.ri",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        counts = "{exp}/counts/{sample}.{ref}.{alphabet}.rindex.count",
        log = "{exp}/counts/{sample}.{ref}.{alphabet}.rindex.count.log",
        time = "{exp}/counts/{sample}.{ref}.{alphabet}.rindex.count.time",
        cmd = "{exp}/counts/{sample}.{ref}.{alphabet}.rindex.count.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/counts")
        options = "count {wildcards.exp}/indexes/rindex.{wildcards.ref}.{wildcards.alphabet}/ref.fa {input.reads} > {output.counts}"
        cmd = "{t} {output.time} {rindex} " + options + " 2>{output.log}"
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule count_movi_default:
    input:
        index = "{exp}/indexes/movi_default.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_default.count",
        log = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_default.count.log",
        time = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_default.count.time",
        cmd = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_default.count.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/counts")
        options = "count-pf {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_command(output.time, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.default.matches {output.pseudo_lengths}")

rule count_movi_constant:
    input:
        index = "{exp}/indexes/movi_constant.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        pseudo_lengths = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_constant.count",
        log = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_constant.count.log",
        time = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_constant.count.time",
        cmd = "{exp}/counts/{sample}.{ref}.{alphabet}.movi_constant.count.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/counts")
        options = "count-pf {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_command(output.time, movi_constant, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("mv {input.reads}.constant.matches {output.pseudo_lengths}")