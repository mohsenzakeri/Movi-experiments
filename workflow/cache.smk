spumoni_cache = "/home/mzakeri1/spumoni/build_cache_release/spumoni"

def create_cache_command(cache_output, binary, options, log_output):
    return "valgrind --tool=cachegrind --cachegrind-out-file=" + cache_output + " " + binary + " " + options + " > " + log_output + " 2>&1"

#################################################### cache rules

rule cache_spumoni:
    input:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.spumoni.pseudo_lengths",
        index = "{exp}/indexes/spumoni.{ref}.{alphabet}/sp.fa.thrbv.spumoni",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        cache = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.spumoni.pseudo_lengths",
        log = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.spumoni.pseudo_lengths.log",
        cmd = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.spumoni.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/cache")
        options = "run -r {wildcards.exp}/indexes/spumoni.{wildcards.ref}.{wildcards.alphabet}/sp -p {input.reads} -P -n"
        cmd = create_cache_command(output.cache, spumoni_cache, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("rm {input.reads}.pseudo_lengths")

rule cache_movi_default:
    input:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_default.pseudo_lengths",
        index = "{exp}/indexes/movi_default.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        cache = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_default.pseudo_lengths",
        log = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_default.pseudo_lengths.log",
        cmd = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_default.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/cache")
        options = "query-pf {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_cache_command(output.cache, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("rm {input.reads}.default.mpml.bin")

rule cache_movi_constant:
    input:
        pseudo_lengths = "{exp}/runs/{sample}.{ref}.{alphabet}.movi_constant.pseudo_lengths",
        index = "{exp}/indexes/movi_constant.{ref}.{alphabet}/movi_index.bin",
        reads = "{exp}/reads/{sample}.fasta"
    output:
        cache = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_constant.pseudo_lengths",
        log = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_constant.pseudo_lengths.log",
        cmd = "{exp}/cache/{sample}.{ref}.{alphabet}.cachegrind.movi_constant.pseudo_lengths.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/cache")
        options = "query-pf {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet} {input.reads} 16"
        cmd = create_cache_command(output.cache, movi_constant, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)
        shell("rm {input.reads}.constant.mpml.bin")