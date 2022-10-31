
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

results_filt_genes <- results_filt %>%
  filter(pvalue < 0.05, abs(log2FoldChange) > 0.5) %>%
  arrange(desc(abs(log2FoldChange))) %>%
  head(10)

ggplot(results_filt_genes, aes(y = ensembl_gene_id, x = -log(pvalue)))+
  geom_col(aes(fill = -log(pvalue)))+
  geom_point(aes(color = log2FoldChange), size = 3)+
  scale_color_distiller(type = "div", palette = "PiYG")+
  scale_fill_distiller(type = "seq", palette = "YlOrBr", direction = 1)

ggsave("images/012_distiller_numeric.png", width = 4, height = 4)

ggplot(results_filt_genes, aes(y = ensembl_gene_id, x = -log(pvalue)))+
  geom_col(aes(fill = -log(pvalue)))+
  geom_point(aes(color = log2FoldChange), size = 3)+
  scale_color_gradient2(low = "darkgreen", high = "firebrick") +
  scale_fill_gradient(low = "gray80", high = "steelblue")

ggsave("images/013_gradient_numeric.png", width = 4, height = 4)


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")

ggsave("images/014_scales_pre.png", width = 4, height = 4)


## limits

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_y_continuous(limits = c(0,5))

ggsave("images/015_scales_limits.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  ylim(c(0,5))


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_y_continuous(limits = c(0, 10), 
                     expand = expansion(mult = c(0, 0.5), 
                                           add = c(0, -3)))

# bottom position will be 0 - (10-0) * 0.0  -0 = 0,
# top position will be 10 + (10-0) * 0.5 +(-3) = 12

ggsave("images/016_scales_expand.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_x_continuous(breaks = c(-1,0,1))

ggsave("images/017_scales_breaks.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_x_continuous(breaks = scales::breaks_width(0.5))

ggsave("images/018_scales_breaks_range.png", width = 4, height = 4)


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_y_continuous(trans = "log10")

ggsave("images/019_scales_trans.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_y_continuous(trans = "sqrt")

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange), size = 1.5)+
  scale_color_distiller(type = "div")+
  scale_y_continuous(trans = "reverse")


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange, size = -log(pvalue)))+
  scale_color_distiller(type = "div")

ggsave("images/020_scales_size_pre.png", width = 4, height = 4)


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange, size = -log(pvalue)))+
  scale_color_distiller(type = "div")+
  scale_size_continuous(range = c(3,10))

ggsave("images/021_scales_size.png", width = 4, height = 4)


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange, size = -log(pvalue), alpha = -log(pvalue)))+
  scale_color_distiller(type = "div")+
  scale_alpha_continuous(range = c(1,0.1))

ggsave("images/022_scales_alpha.png", width = 4, height = 4)


ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange))+
  scale_color_distiller(type = "div")+
  facet_wrap(~chromosome_name)

ggsave("images/023_facet_1.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange))+
  scale_color_distiller(type = "div")+
  facet_wrap(~chromosome_name, scales = "free_y")

ggsave("images/024_facet_2.png", width = 4, height = 4)

ggplot(results_filt, aes(y = -log(pvalue), x = log2FoldChange))+
  geom_point(aes(color = log2FoldChange))+
  scale_color_distiller(type = "div")+
  facet_grid(significant~chromosome_name)

ggsave("images/025_facet_3.png", width = 4, height = 4)
