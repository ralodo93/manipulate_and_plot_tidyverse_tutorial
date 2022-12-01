library(tidyverse)
results <- read.delim("../../input_data/results_table.tsv")
gene_info <- read.delim("../../input_data/gene_info.tsv")


# inner_join

results_filt <- results %>% filter(log2FoldChange > 2)
gene_info_filt <- gene_info %>% filter(chromosome_name == "X")

results_filt %>%
  inner_join(gene_info_filt,
             by = c("gene" = "ensembl_gene_id"))

# baseMean log2FoldChange    lfcSE     stat     pvalue      padj            gene hgnc_symbol chromosome_name
# 1 1.5400973       3.293303 1.529176 2.153646 0.03126793 0.9999792 ENSG00000102271       KLHL4               X
# 2 0.4380945       2.039263 1.856920 1.098197 0.27211865 0.9999792 ENSG00000229331      GK-IT1               X
# 3 0.7224753       2.982983 1.997325 1.493489 0.13530920 0.9999792 ENSG00000230916    MTCO1P53               X


# right_join

results_filt %>%
  right_join(gene_info,by = c("gene" = "ensembl_gene_id")) %>%
  as_tibble()

# # A tibble: 38,871 x 9
# baseMean log2FoldChange lfcSE  stat pvalue  padj gene            hgnc_symbol chromosome_name
# <dbl>          <dbl> <dbl> <dbl>  <dbl> <dbl> <chr>           <chr>       <chr>          
#   1    1.08            2.12  1.12 1.90  0.0577  1.00 ENSG00000006659 LGALS14     19             
# 2    0.515           2.29  1.24 1.85  0.0643  1.00 ENSG00000007866 TEAD3       6              
# 3    0.625           2.16  1.21 1.79  0.0741  1.00 ENSG00000021488 SLC7A9      19             
# 4    6.19            2.33  1.08 2.16  0.0306  1.00 ENSG00000064300 NGFR        17             
# 5    1.37            3.13  1.23 2.54  0.0111  1.00 ENSG00000100191 SLC5A4      22             
# 6    1.54            3.29  1.53 2.15  0.0313  1.00 ENSG00000102271 KLHL4       X              
# 7    0.586           2.48  1.73 1.43  0.152   1.00 ENSG00000104055 TGM5        15             
# 8    0.373           2.01  2.18 0.920 0.357   1.00 ENSG00000104723 TUSC3       8              
# 9    2.35            2.45  1.45 1.69  0.0918  1.00 ENSG00000105131 EPHX3       19             
# 10    0.445           2.34  1.99 1.18  0.239   1.00 ENSG00000106006 HOXA6       7              
# # ... with 38,861 more rows


# left_join

gene_info %>%
  left_join(results_filt,by = c("ensembl_gene_id" = "gene")) %>%
  as_tibble()

# # A tibble: 38,871 x 9
# ensembl_gene_id hgnc_symbol chromosome_name baseMean log2FoldChange lfcSE  stat pvalue  padj
# <chr>           <chr>       <chr>              <dbl>          <dbl> <dbl> <dbl>  <dbl> <dbl>
#   1 ENSG00000000003 TSPAN6      X                     NA             NA    NA    NA     NA    NA
# 2 ENSG00000000419 DPM1        20                    NA             NA    NA    NA     NA    NA
# 3 ENSG00000000457 SCYL3       1                     NA             NA    NA    NA     NA    NA
# 4 ENSG00000000460 C1orf112    1                     NA             NA    NA    NA     NA    NA
# 5 ENSG00000000938 FGR         1                     NA             NA    NA    NA     NA    NA
# 6 ENSG00000000971 CFH         1                     NA             NA    NA    NA     NA    NA
# 7 ENSG00000001036 FUCA2       6                     NA             NA    NA    NA     NA    NA
# 8 ENSG00000001084 GCLC        6                     NA             NA    NA    NA     NA    NA
# 9 ENSG00000001167 NFYA        6                     NA             NA    NA    NA     NA    NA
# 10 ENSG00000001460 STPG1       1                     NA             NA    NA    NA     NA    NA
# # ... with 38,861 more rows

# full_join

results_filt %>%
  full_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  as_tibble()

# # A tibble: 1,434 x 9
# baseMean log2FoldChange lfcSE  stat pvalue  padj gene            hgnc_symbol chromosome_name
# <dbl>          <dbl> <dbl> <dbl>  <dbl> <dbl> <chr>           <chr>       <chr>          
#   1    1.08            2.12  1.12 1.90  0.0577  1.00 ENSG00000006659 NA          NA             
# 2    0.515           2.29  1.24 1.85  0.0643  1.00 ENSG00000007866 NA          NA             
# 3    0.625           2.16  1.21 1.79  0.0741  1.00 ENSG00000021488 NA          NA             
# 4    6.19            2.33  1.08 2.16  0.0306  1.00 ENSG00000064300 NA          NA             
# 5    1.37            3.13  1.23 2.54  0.0111  1.00 ENSG00000100191 NA          NA             
# 6    1.54            3.29  1.53 2.15  0.0313  1.00 ENSG00000102271 KLHL4       X              
# 7    0.586           2.48  1.73 1.43  0.152   1.00 ENSG00000104055 NA          NA             
# 8    0.373           2.01  2.18 0.920 0.357   1.00 ENSG00000104723 NA          NA             
# 9    2.35            2.45  1.45 1.69  0.0918  1.00 ENSG00000105131 NA          NA             
# 10    0.445           2.34  1.99 1.18  0.239   1.00 ENSG00000106006 NA          NA             
# # ... with 1,424 more rows

results_filt %>%
  full_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  slice_tail(n = 10) %>%
  as_tibble()

# # A tibble: 10 x 9
# baseMean log2FoldChange lfcSE  stat pvalue  padj gene            hgnc_symbol chromosome_name
# <dbl>          <dbl> <dbl> <dbl>  <dbl> <dbl> <chr>           <chr>       <chr>          
#   1       NA             NA    NA    NA     NA    NA ENSG00000283400 ""          X              
# 2       NA             NA    NA    NA     NA    NA ENSG00000283435 "MIR1321"   X              
# 3       NA             NA    NA    NA     NA    NA ENSG00000283463 "HSFX4"     X              
# 4       NA             NA    NA    NA     NA    NA ENSG00000283599 ""          X              
# 5       NA             NA    NA    NA     NA    NA ENSG00000283638 ""          X              
# 6       NA             NA    NA    NA     NA    NA ENSG00000283644 "ETDC"      X              
# 7       NA             NA    NA    NA     NA    NA ENSG00000283697 "HSFX3"     X              
# 8       NA             NA    NA    NA     NA    NA ENSG00000283737 ""          X              
# 9       NA             NA    NA    NA     NA    NA ENSG00000283743 ""          X              
# 10       NA             NA    NA    NA     NA    NA ENSG00000284391 ""          X  