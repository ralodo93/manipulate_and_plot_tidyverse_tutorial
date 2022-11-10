
plot_to_do <- data.frame(plot = c("volcano plot", "barplot pheno data", "box plot"),
                         x = c("log2FoldChange", "cell_type", "disease_state"),
                         y = c("-log(pvalue)", "?", "expression"),
                         geom = c("points, text","bar, col","boxplot"),
                         skill = c("first plot", "use aes to aggregate data","groups"))

##### Set up #####

library(tidyverse)
norm_counts <- read.delim("../input_data/normalized_counts.tsv") %>%
  column_to_rownames("gene") %>%
  rename_all(funs(stringr::str_replace_all(., 'X', '')))
extended_data <- norm_counts %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = colnames(norm_counts),
               names_to = "sample",
               values_to = "expression")

results <- read.delim("../input_data/results_table.tsv")
gene_info <- read.delim("../input_data/gene_info.tsv")
pheno_data <- read.delim("../input_data/pheno_data.tsv")

### Our first ggplot2 ###

table_to_use <- results %>%
  arrange(desc(abs(log2FoldChange))) %>%
  head(5) %>%
  inner_join(extended_data) %>%
  inner_join(pheno_data, by = c("sample"="title")) %>%
  inner_join(gene_info, by = c("gene"="ensembl_gene_id"))

str(table_to_use)

# 'data.frame':	830 obs. of  15 variables:
#   $ baseMean       : num  17.7 17.7 17.7 17.7 17.7 ...
# $ log2FoldChange : num  4.62 4.62 4.62 4.62 4.62 ...
# $ lfcSE          : num  0.528 0.528 0.528 0.528 0.528 ...
# $ stat           : num  8.75 8.75 8.75 8.75 8.75 ...
# $ pvalue         : num  2.21e-18 2.21e-18 2.21e-18 2.21e-18 2.21e-18 ...
# $ padj           : num  8.53e-14 8.53e-14 8.53e-14 8.53e-14 8.53e-14 ...
# $ gene           : chr  "ENSG00000225972" "ENSG00000225972" "ENSG00000225972" "ENSG00000225972" ...
# $ sample         : chr  "2950_PBMC" "2951_PBMC" "2965_PBMC" "2964_PBMC" ...
# $ expression     : num  2.216 0 0 0.918 0 ...
# $ individual     : int  2950 2951 2965 2964 3015 2972 3019 3022 3114 3115 ...
# $ cell_type      : chr  "PBMC" "PBMC" "PBMC" "PBMC" ...
# $ disease_state  : chr  "Healthy control" "Healthy control" "Healthy control" "Healthy control" ...
# $ gender         : chr  "Male" "Female" "Female" "Female" ...
# $ hgnc_symbol    : chr  "MTND1P23" "MTND1P23" "MTND1P23" "MTND1P23" ...
# $ chromosome_name: chr  "1" "1" "1" "1" ...

ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point()

ggsave(filename = "images/001_starting.png", height = 4, width = 4)

# Setting geom properties
ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point(size = 2, color = "orchid")+
  geom_line(color = "blue")

ggsave(filename = "images/002_add_layers.png", height = 4, width = 4)

# Setting aesthetic
ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point(aes(color = disease_state, size = expression), alpha = 0.5)+
  geom_line(color = "steelblue")

ggsave(filename = "images/003_mapping_points.png", height = 4, width = 4)

# Error!!!
ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point(aes(shape = expression), alpha = 0.5)+
  geom_line(color = "steelblue")



ggplot(data = table_to_use, mapping = aes(y = gene))+
  geom_bar()

ggsave(filename = "images/004_bar.png", height = 4, width = 4)

table_count <- table_to_use %>%
  group_by(gene) %>%
  count()

ggplot(table_count, aes(y = gene, x = n))+
  geom_bar(stat = "identity")

ggplot(table_count, aes(y = gene, x = n))+
  geom_col()




ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point()+
  scale_x_log10()

ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point()+
  scale_x_reverse()

ggplot(data = table_to_use, mapping = aes(y = gene, x = expression))+
  geom_point()+
  scale_x_continuous(limits = c(0, 500))

