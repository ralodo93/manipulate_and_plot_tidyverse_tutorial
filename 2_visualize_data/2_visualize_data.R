
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

### First plot ###

# Filter result table
results_filt <- results %>%
  filter(pvalue < 0.01) %>%
  arrange(desc(abs(log2FoldChange))) %>%
  mutate(greater_or_lower = ifelse(log2FoldChange > 0, "Greater", "Lower")) %>%
  head(10)

# input the dataset in the function ggplot and add a new layer with +
ggplot(results_filt)+
  # Add a geom object (points in that case)
  geom_point(
    # use aes() to declare aesthetic
    aes(
      # declare x and yaxis
      x = gene,
      y = log2FoldChange
    )
  )

# The code without comments:
ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))

ggsave("images/001_starting.png", height = 5, width = 5)

ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))+
  geom_col(aes(x = gene, y = log2FoldChange))

ggsave("images/002_adding_layers.png", height = 5, width = 5)

ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))+
  geom_col(aes(x = gene, y = log2FoldChange))+
  geom_text(aes(x = gene, y = log2FoldChange, label = gene))

ggsave("images/003_three_layers.png", height = 5, width = 5)

# Declare aes in ggplot()
ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_point()+
  geom_col()+
  geom_text()

#### Start customizing

# add characteristic
ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_point(size = 3, shape = 7)+
  geom_col(fill = "pink", alpha = 0.8)+
  geom_text(size = 2, nudge_y = -1.5,angle = 90)


# Change the order of layers
ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_col(fill = "pink", alpha = 0.8)+
  geom_point(size = 3, shape = 7)+
  geom_text(size = 2, nudge_y = -1.5,angle = 90)

# Improve text

ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_col(fill = "pink", alpha = 0.8)+
  geom_point(size = 3, shape = 7)+
  geom_text(data = results_filt %>% filter(log2FoldChange > 0),
            size = 2, nudge_y = -1.5,angle = 90)

ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_col(fill = "pink", alpha = 0.8)+
  geom_point(size = 3, shape = 7)+
  geom_text(data = results_filt %>% filter(log2FoldChange > 0),
            size = 2, nudge_y = -1.5,angle = 90)+
  geom_text(data = results_filt %>% filter(log2FoldChange < 0),
            size = 2, nudge_y = 1.5,angle = 90)

### adding more aes

ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene,
                         fill = greater_or_lower, size = abs(log2FoldChange)))+
  geom_col(alpha = 0.8)+
  geom_point(shape = 7)+
  geom_text(data = results_filt %>% filter(log2FoldChange > 0),
            size = 2, nudge_y = -1.5,angle = 90)+
  geom_text(data = results_filt %>% filter(log2FoldChange < 0),
            size = 2, nudge_y = 1.5,angle = 90)
