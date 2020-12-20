# BI_project_2020

The work describes the annotation of metagenomic assemblies of four cellulolytic microbial communities obtained from various substrates (straw, sawdust, leaf litter).

Student: Grigory Gladkov

Supervisors: Mike Raiko, Lavrentiy Danilov

## Aims and tasks

Find the differences between microbial communities that break down cellulose on straw and leaf litter from ONT assemblies.

Tasks:

- de novo binning (MetaBAT2), compare with reference base binning (Kaiju), compare with 16S data

- find community-specific glycoside hydrolases


## Binning and quality control

Binning was done using Metabat2 with followed command:

```metabat2 -i consensus.fasta -o metabat2_bins_3```

Quality control was done out using CheckM:

```checkm lineage_wf -x fa  -f checkm/N2_MAGs_checkm.tab -t 50 metabat2_bins_3/ out/
checkm qa ./out/lineage.ms ./out -o 2 -f res --tab_table -t 20
```

For ssu extraction, we use ssu_finder:

```checkm ssu_finder consensus.fasta bins/ out/ -x fa -t 20```

where ``out`` - out folder, ```metabat2_bins_3``` - folder with bins, ```-t``` - number of used threads, ```-x``` format of fasta file, ```consensus.fasta``` - assemblies.




