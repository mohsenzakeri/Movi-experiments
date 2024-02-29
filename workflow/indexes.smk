pfp = config["PFP_BUILD"] + "/pfp_thresholds"
prepare_ref = config['MOVI_BUILD'] + "/prepare_ref"
bconstructor = config["R_PERMUTE_BUILD"] + "/test/src/build_constructor"
rconstructor = config["R_PERMUTE_BUILD"] + "/test/src/run_constructor"
rindex_build = config['RINDEX_BUILD'] + "/ri-buildfasta"
bowtie2_build = config["BOWTIE2_DIR"] + "/bowtie2-build"

#################################################### index rules

rule build_bowtie2_index:
    input:
        fasta = "{exp}/refs/{ref}.fasta"
    output:
        bt1 = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.1.bt2l",
        bt2 = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.2.bt2l",
        bt3 = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.3.bt2l",
        log = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.build.log",
        time = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.build.time",
        cmd = "{exp}/indexes/bowtie2.{ref}.{alphabet}/bowtie2.build.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/bowtie2.{wildcards.ref}.{wildcards.alphabet}")
        options = "--large-index {input.fasta} {wildcards.exp}/indexes/bowtie2.{wildcards.ref}.{wildcards.alphabet}/bowtie2"
        cmd = create_command(output.time, bowtie2_build, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_minimap2_index:
    input:
        fasta = "{exp}/refs/{ref}.fasta"
    output:
        indx = "{exp}/indexes/minimap2.{ref}.{alphabet}/minimap2.index",
        log = "{exp}/indexes/minimap2.{ref}.{alphabet}/build.minimap2.log",
        time = "{exp}/indexes/minimap2.{ref}.{alphabet}/build.minimap2.time",
        cmd = "{exp}/indexes/minimap2.{ref}.{alphabet}/build.minimap2.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/minimap2.{wildcards.ref}.{wildcards.alphabet}")
        options =  " -x map-ont -d {output.indx} {input.fasta}"
        cmd = create_command(output.time, minimap2, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_fulgor_index:
    input:
        fasta_list = "{exp}/refs/{ref}.txt"
    output:
        indx = "{exp}/indexes/fulgor.{ref}.{alphabet}/fi.hybrid.index",
        log = "{exp}/indexes/fulgor.{ref}.{alphabet}/build.fulgor.log",
        time = "{exp}/indexes/fulgor.{ref}.{alphabet}/build.fulgor.time",
        cmd = "{exp}/indexes/fulgor.{ref}.{alphabet}/build.fulgor.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/fulgor.{wildcards.ref}.{wildcards.alphabet}")
        options = "build -l {input.fasta_list} -o {wildcards.exp}/indexes/fulgor.{wildcards.ref}.{wildcards.alphabet}/fi -k 31 -m 19 -d /tmp/ -t 16 "
        cmd = create_command(output.time, fulgor, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_rindex:
    input:
        fasta = "{exp}/indexes/rindex.{ref}.{alphabet}/ref.fa"
    output:
        indx = "{exp}/indexes/rindex.{ref}.{alphabet}/ref.fa.ri",
        log = "{exp}/indexes/rindex.{ref}.{alphabet}/build.rindex.log",
        time = "{exp}/indexes/rindex.{ref}.{alphabet}/build.rindex.time",
        cmd = "{exp}/indexes/rindex.{ref}.{alphabet}/build.rindex.cmd"
    run:
        options = "-b bigbwt {input.fasta}"
        cmd = create_command(output.time, rindex_build, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_spumoni_index:
    input:
        fasta_list = "{exp}/refs/{ref}.txt"
    output:
        indx = "{exp}/indexes/spumoni.{ref}.{alphabet}/sp.fa.thrbv.spumoni",
        log = "{exp}/indexes/spumoni.{ref}.{alphabet}/build.spumoni.log",
        time = "{exp}/indexes/spumoni.{ref}.{alphabet}/build.spumoni.time",
        cmd = "{exp}/indexes/spumoni.{ref}.{alphabet}/build.spumoni.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/spumoni.{wildcards.ref}.{wildcards.alphabet}")
        options = "build -i {input.fasta_list} -o {wildcards.exp}/indexes/spumoni.{wildcards.ref}.{wildcards.alphabet}/sp -P -n"
        cmd = create_command(output.time, spumoni, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_movi_default_index:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        bwt = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt",
        thresholds = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.thr_pos",
    output:
        indx = "{exp}/indexes/movi_default.{ref}.{alphabet}/movi_index.bin",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.movi.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.movi.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.movi.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet}")
        options = "build reg {input.fasta} {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet}/"
        cmd = create_command(output.time, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule build_movi_constant_index:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        bwt = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt",
        thresholds = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.thr_pos",
        d_construct="{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.d_construct",
        d_col="{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.d_col"
    output:
        indx = "{exp}/indexes/movi_constant.{ref}.{alphabet}/movi_index.bin",
        log = "{exp}/indexes/movi_constant.{ref}.{alphabet}/build.movi.log",
        time = "{exp}/indexes/movi_constant.{ref}.{alphabet}/build.movi.time",
        cmd = "{exp}/indexes/movi_constant.{ref}.{alphabet}/build.movi.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet}")
        options = "build constant {input.fasta} {wildcards.exp}/indexes/movi_constant.{wildcards.ref}.{wildcards.alphabet}/"
        cmd = create_command(output.time, movi_constant, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

#################################################### pre-process rules

rule run_pfp:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa"
    output:
        bwt = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt",
        thresholds = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.thr_pos",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.pfp.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.pfp.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.pfp.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet}")
        options = "-f {input.fasta}"
        cmd = create_command(output.time, pfp, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule movi_prepare_ref:
    input:
        fasta_list = "{exp}/refs/{ref}.txt"
    output:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.prepare_ref.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.prepare_ref.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.prepare_ref.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet}")
        options = "{input.fasta_list} {output.fasta} list"
        cmd = create_command(output.time, prepare_ref, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule rpermute_run_constructor:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        d_construct = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.d_construct"
    output:
        d_col = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.d_col",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.run_constructor.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.run_constructor.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.run_constructor.cmd"
    run:
        options = "{input.fasta} -d 5"
        cmd = create_command(output.time, rconstructor, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule rpermute_build_constructor:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        bwt_heads = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt.heads",
        bwt_len = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt.len",
    output:
        d_construct = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.d_construct",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.build_constructor.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.build_constructor.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.build_constructor.cmd"
    run:
        options = input.fasta
        cmd = create_command(output.time, bconstructor, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule movi_rlbwt:
    input:
        fasta = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa",
        bwt = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt"
    output:
        bwt_heads = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt.heads",
        bwt_len = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa.bwt.len",
        log = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.rlbwt.log",
        time = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.rlbwt.time",
        cmd = "{exp}/indexes/movi_default.{ref}.{alphabet}/build.rlbwt.cmd"
    run:
        shell("mkdir -p {wildcards.exp}/indexes/movi_default.{wildcards.ref}.{wildcards.alphabet}")
        options = " rlbwt " + input.fasta
        cmd = create_command(output.time, movi_default, options, output.log)
        print(cmd)
        shell("echo {cmd} > {output.cmd}")
        shell(cmd)

rule prepare_rindex:
    input:
        fasta_in = "{exp}/indexes/movi_default.{ref}.{alphabet}/ref.fa"
    output:
        fasta_out = "{exp}/indexes/rindex.{ref}.{alphabet}/ref.fa"
    run:
        shell("mkdir -p {wildcards.exp}/indexes")
        shell("mkdir -p {wildcards.exp}/indexes/rindex.{wildcards.ref}.{wildcards.alphabet}")
        shell("cp {input.fasta_in} {output.fasta_out}")

rule list_to_fasta:
    input:
        fasta_list = "{exp}/refs/{ref}.txt"
    output:
        fasta = "{exp}/refs/{ref}.fasta"
    run:
        shell("cat $(grep -v '^#'  {inpur.fasta_list} > {output.fasta}")