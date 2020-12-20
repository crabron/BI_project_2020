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

A preliminary attempt was made to binning using coverage information, which was unsuccessful. For alignment per assembly, we used two alignment algorithms:

```bwa mem  -t 84 consensus.fasta all.fq | samtools sort -o all.bam
maCMD -p 'Nanopore' -x mc_out/consensus.json -i ../all.fq -t 64 -o mc_out/consensus.sam
```
To generate a file with sequencing depth, the following command was used:

```jgi_summarize_bam_contig_depths --outputDepth true_depth.txt --referenceFasta consensus.fasta  all.bam
```
with result:

```MetaBAT 2 (2.15 (Bioconda)) using minContig 2500, minCV 1.0, minCVSum 1.0, maxP 95%, minS 60, maxEdges 200 and minClsSize 200000. with random seed=1603977749
0 bins  formed.
```

## Search for glycosyl hydrolases with hmmer

To search for domain families of hydroside hydrolases by hmm profile, the following code was used, which launched a search for each .faa file in the directory:

```for filename in *.faa; do
    hmmscan --noali --notextw --acc -E 0.000000000000000001 --cpu 50 -o  hm_${filename}.txt hmm/glyco.hmm $filename
done
```
glyco.hmm - hmm profile, acc - accuracity trashold, filename - prokka output

Post-processing of the obtained results was carried out in jupyter notebook (parse_hmm). Adding Kaiju results to hhmer results was done using the ultimate pipe for each community:

``` cat ../c1_ann.tsv | cut -f2 |grep -f /dev/stdin pr_01.gff | awk '{print $1}' | grep -f /dev/stdin ka_01.tsv | cut -f3 | taxonkit --data-dir ~/storage/temp/  -j 50 lineage | taxonkit --data-dir ~/storage/temp/ -j 50 reformat > kid_01.txt
```

Where - c1_ann.tsv - output from hmmer, pr_01.gff - Prokka output, ka_01.tsv - Kaiju output, taxonkit - add NCBI taxonomy. Visualisation of hmmerscan results have done with com_vis.R script.

## Results

As a result of binning, 10 genomes were obtained from the metagenome
Metagenomes found matches with catalase families responsible for cellulose/hemicellulose decomposition
The collected metagenomes and the most represented groups in which the necessary catalases were found do not coincide.
Differences in taxonomy are more pronounced than differences in the representation of glycoside hydrolase families




