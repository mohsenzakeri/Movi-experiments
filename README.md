# Movi experiments

This repository includes the workflow for the main experiments in:
>[Zakeri, Mohsen, Brown, Nathaniel K., Ahmed, Omar Y., Gagie, Travis, and Langmead, Ben. "Movi: a fast and cache-efficient full-text pangenome index". bioRxiv preprint (2023)](https://www.biorxiv.org/content/10.1101/2023.11.04.565615v2)

### Main tools benchmarkeed in the experiments of the paper

- Movi: [https://github.com/mohsenzakeri/Movi](https://github.com/mohsenzakeri/Movi/releases/tag/v1.0)
- SPUMONI: [https://github.com/oma219/spumoni](https://github.com/oma219/spumoni/tree/v2.0.7)
- Fulgor: [https://github.com/jermp/fulgor](https://github.com/jermp/fulgor/releases/tag/v1.0.0)
- minimap2: [https://github.com/lh3/minimap2](https://github.com/lh3/minimap2/releases/tag/v2.26)
- Bowtie2: [https://github.com/BenLangmead/bowtie2](https://github.com/BenLangmead/bowtie2/tree/v2.5.3)
- r-index: https://github.com/oma219/r-index

### Instructions
After cloning the repository, please modify the config file `workflow/config.yaml` to include the correct paths on your system. For the `MAIN_DIR`, use the path to the main directory of this repository.

To create the results, please install `Snakemake` and then run the following from the `workflow` directory of the repository:
```
Snakemake -c1
```
