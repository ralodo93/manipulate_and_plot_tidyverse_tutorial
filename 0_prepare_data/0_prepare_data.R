############################################################################
############################################################################
###                                                                      ###
###                              SECTION 0:                              ###
###             DESCRIPTION OF HOW DOWNLOAD AND PREPARE DATA             ###
###                                                                      ###
############################################################################
############################################################################

## Verify/install libraries
if (!("BiocManager" %in% installed.packages())){install.packages("BiocManager")}
if (!("GEOquery" %in% installed.packages())){BiocManager::install("GEOquery",ask = F,update = F)}
if (!("DESeq2" %in% installed.packages())){BiocManager::install("DESeq2",ask = F,update = F)}
if (!("biomaRt" %in% installed.packages())){BiocManager::install("biomaRt",ask = F,update = F)}
if (!("tidyverse" %in% installed.packages())){install.package("tidyverse")}
if (!("vroom" %in% installed.packages())){install.package("vroom")}

## Load libraries
library(GEOquery)
library(DESeq2)
library(tidyverse)
library(vroom)
library(biomaRt)

## Create folder where save tables
example_folder <- "../input_data/"
dir.create(example_folder, showWarnings = F)

## Increase vroom connection size to download data
Sys.setenv(VROOM_CONNECTION_SIZE=800072)

## Get GSE info
gse_info <- getGEO("GSE153104")$GSE153104_series_matrix.txt.gz

## Get pheno data
pheno_data <- gse_info@phenoData@data %>%
  mutate(individual = stringr::str_split(title, "_") %>% map_chr(., 1)) %>%
  dplyr::select(title, individual, `cell type:ch1`, `disease state:ch1`, `gender:ch1`) %>%
  as.data.frame()

rownames(pheno_data) <- pheno_data$title
colnames(pheno_data) <- c("title","individual","cell_type","disease_state","gender")

## Download counts
g_table <- getGEOSuppFiles("GSE153104")

expression_counts <- vroom("GSE153104/GSE153104_all_counts.tsv.gz")
expression_counts$gene_id <- gsub('\\..+$', '', expression_counts$gene_id)

## Download gene info
ensembl = useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
gene_info <- getBM(attributes=c('ensembl_gene_id',
                                'hgnc_symbol',
                                'chromosome_name'),
                   filters = "ensembl_gene_id",
                   values = expression_counts$gene_id,
                   mart = ensembl)

expression_counts <- expression_counts %>%
  filter(gene_id %in% gene_info$ensembl_gene_id) %>%
  column_to_rownames("gene_id") %>%
  as.data.frame()

## Use DESeq2 to compare data
dds <- DESeqDataSetFromMatrix(countData = expression_counts,
                              colData = pheno_data,
                              design = ~ disease_state)

dds <- DESeq(dds)

## Get result table
results_table <- as.data.frame(results(dds, contrast=c("disease_state","Alzheimer's disease","Healthy control")))
results_table$gene <- rownames(results_table)

## Get normalized counts
normalized_counts <- as.data.frame(counts(dds, normalized = TRUE))
sample_names <- colnames(normalized_counts)
normalized_counts$gene <- rownames(normalized_counts)
normalized_counts <- normalized_counts[,c("gene",sample_names)]


## Save Pheno Data
vroom_write(x = pheno_data, file = paste0(example_folder,"/pheno_data.tsv"),quote = "none")

## Save Normalized Counts
vroom_write(x = normalized_counts, file = paste0(example_folder,"/normalized_counts.tsv"),quote = "none")

## Save Results 
vroom_write(x = results_table, file = paste0(example_folder,"/results_table.tsv"),quote = "none")

## Save Gene Info
vroom_write(x = gene_info, file = paste0(example_folder,"/gene_info.tsv"), quote = "none")

unlink("GSE153104", recursive = TRUE)
