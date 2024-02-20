#################################################### logs rules

rule run_movi_default_logs:
    input:
        cache = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_default.pseudo_lengths",
        index = "{exp}/indexes/movi_default.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        costs = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.costs",
        scans = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.scans",
        fastforwards = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.fastforwards",
        time = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.time",
        log = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.log",
        cmd = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/logs")
        options = "query-pf {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16 logs"
        cmd = create_command(output.time, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("rm {input.reads}.default.mpml.bin")
        shell("mv {input.reads}.default.costs {output.costs}")
        shell("mv {input.reads}.default.scans {output.scans}")
        shell("mv {input.reads}.default.fastforwards {output.fastforwards}")

rule run_movi_constant_logs:
    input:
        cache = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_constant.pseudo_lengths",
        index = "{exp}/indexes/movi_constant.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        costs = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.costs",
        scans = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.scans",
        fastforwards = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.fastforwards",
        time = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.time",
        log = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.log",
        cmd = "{exp}/logs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/logs")
        options = "query-pf {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16 logs"
        cmd = create_command(output.time, movi_constant, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("rm {input.reads}.constant.mpml.bin")
        shell("mv {input.reads}.constant.costs {output.costs}")
        shell("mv {input.reads}.constant.scans {output.scans}")
        shell("mv {input.reads}.constant.fastforwards {output.fastforwards}")
