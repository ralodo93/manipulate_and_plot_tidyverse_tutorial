
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

### data ###

ggplot(data = pheno_data)

ggplot(data = results, mapping = aes(y = log2FoldChange, x = baseMean))

ggplot(results, aes(y = log2FoldChange, x = baseMean)) +
  geom_point()

ggplot(results) +
  geom_point(aes(y = log2FoldChange, x = baseMean))

ggplot() +
  geom_point(data = results, aes(y = log2FoldChange, x = baseMean))

ggsave("images/001_starting.png", height = 4, width = 4)

# Filter gene_info and join results
results_filt <- gene_info %>%
  filter(chromosome_name %in% c("1","2","3")) %>%
  inner_join(results, by = c("ensembl_gene_id" = "gene")) %>%
  mutate(significant = ifelse(padj < 0.05 & abs(log2FoldChange) > 0.5,"Significant","No Significant"))

ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue))) +
  geom_point(color = "blue", size = 3)+
  geom_line(color = "darkgreen")

ggsave("images/002_adding_layers.png", height = 4, width = 4)


ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue), color = chromosome_name)) +
  geom_point(size = 3)+
  geom_line()

ggsave("images/003_adding_color.png", height = 4, width = 4)

ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue))) +
  geom_point(aes(size = lfcSE, color = chromosome_name))+
  geom_line()

ggsave("images/004_color_points.png", height = 4, width = 4)

ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue))) +
  geom_point(aes(size = lfcSE, color = chromosome_name))+
  geom_line()+
  geom_text(aes(label = ensembl_gene_id), size = 2)

ggsave("images/005_error_text.png", height = 4, width = 4)

results_filt_text <- results_filt %>%
  filter(significant == "Significant")

ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue))) +
  geom_point(aes(size = lfcSE, color = chromosome_name))+
  geom_line()+
  geom_text(data = results_filt_text,aes(label = ensembl_gene_id), size = 2)

ggsave("images/006_good_text.png", height = 4, width = 4)


ggplot(results_filt, aes(x = log2FoldChange, y = -log(pvalue))) +
  geom_text(data = results_filt_text,aes(label = ensembl_gene_id), size = 2)+
  geom_point(aes(size = lfcSE, color = chromosome_name))+
  geom_line()

ggsave("images/007_reorder_layers.png", height = 4, width = 4)


ggplot(pheno_data, aes(x = cell_type))+
  geom_bar()

ggsave("images/008_stat_bar.png", height = 4, width = 4)


pheno_data_count <- pheno_data %>%
  group_by(cell_type) %>%
  count()

ggplot(pheno_data_count, aes(x = cell_type, y = n))+
  geom_bar(stat = "identity")

ggplot(pheno_data_count, aes(x = cell_type, y = n))+
  geom_col()

###

ggplot(pheno_data, aes(x = cell_type, color = gender, fill = disease_state))+
  geom_bar()

ggsave("images/009_color_and_fill.png", width = 4, height = 4)

ggplot(pheno_data, aes(x = cell_type, color = gender, fill = disease_state))+
  geom_bar()+
  scale_fill_brewer(type = "qual", palette = "Dark2")+
  scale_color_brewer(type = "qual", palette = "Set3")

ggsave("images/010_brewer_change_qual.png", width = 4, height = 4)

ggplot(pheno_data, aes(x = cell_type, color = gender, fill = disease_state))+
  geom_bar()+
  scale_fill_manual(values = c("Alzheimer's disease" = "gray70",
                               "Healthy control" = "gray30"))+
  scale_color_manual(values = c("Female" = "orange",
                                "Male" = "darkblue"))

ggsave("images/011_manual_change_qual.png", width = 4, height = 4)
