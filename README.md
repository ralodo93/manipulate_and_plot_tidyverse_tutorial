# Tutorial for Manipulating and Visualizing Data with `tidyverse`

This tutorial have been made in order to provide good practices to manipulate and visualize data with the packages includes in the library `tidyverse`. The very starting set up consist on install R if you have not intalled it yet. You can download and install from [here](https://www.r-project.org/).

## How use the repository

To illustrate the use of `tidyverse` we will use RNA-Seq data from a Serie of NCBI GEO. This Serie contains RNA-Seq data from multiple samples with and without Alzheimer. These data have been already downloaded and preprocessed in the folder [input_data](./input_data). There are located the tables that are going to be used.

- **pheno_data.tsv** contains the information about all samples that were recruited for the study.
- **normalized_counts.tsv** is the expression matrix, with samples in columns and genes in rows.
- **gene_info.tsv** shows information about the genes
- **results_table.tsv** is the result of applying a differential expression analysis of Alzheimer patients versus Healthy control.

Besides input data we provide three folders. Each folder have a different objective and they are ordered sequentially.

The first one is [0_prepare_data](./0_prepare_data) where there is a R script file with the code to get manually the input data located at input_data. If you are not interested in how download and preprocess the data you can omit this folder.

The rest of folders includes R codes to learn how manipulate ([1_manipulate_data](./1_manipulate_data)) and visualize data ([2_visualize_data](./2_visualize_data)). In addition, there are .md, .Rmd and .html files to understand the code, similar as a step by step tutorial.
