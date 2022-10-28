################################################################################
##  This code was written by Raul Lopez-Dominguez and Marisol Benitez-Cantos  ##
################################################################################

##### Set up preparation #####

library(tidyverse)
pheno_data <- read.delim("../input_data/pheno_data.tsv")

##### Pipes #####

pheno_data %>%
  head() %>%
  as.data.frame()

pheno_data %>%
  unique()

pheno_data %>%
  na.omit()

##### Basic Functions #####

### select() ###

pheno_data %>%
  # Select title and individual
  select(title, individual) %>%
  head()

pheno_data %>%
  # Select columns between title and disease_state
  select(title:disease_state) %>%
  head()

pheno_data %>%
  # Remove title and individual columns
  select(-title,-individual) %>%
  head()

pheno_data %>%
  # Not select anything, but the order of the columns changes
  select(individual, cell_type, disease_state, gender, title) %>%
  head()


### rename() ###

pheno_data %>%
  # Put the new name and equalise to the old name
  rename("title_new" = "title") %>%
  head()

pheno_data %>%
  # You can change some colnames
  rename("title_new" = "title", "cell_dex_new" = "cell_type") %>%
  head()


### filter() ###

pheno_data %>%
  # Keep the rows with the cell_type different from "PBMC"
  filter(cell_type != "PBMC",
         # And with the disease_state equal to "Healthy control"
         disease_state == "Healthy control") %>%
  head()

pheno_data %>%
  # Keep the rows with individual 3139 or 3153
  filter(individual %in% c("3139","3153")) %>%
  head()

pheno_data %>%
  # Keep the rows that are different from 3139 or 3153
  filter(!individual %in% c("3139","3153")) %>%
  head()



### mutate() ###

# In that case we are going to save a new variable named pheno_data_with_dummy
pheno_data_with_dummy <- pheno_data %>%
  # Use mutate to create numeric variable named dummyVar
  mutate(dummyVar = rnorm(nrow(pheno_data)),
         # another numeric variable named dummyVar2
         dummyVar2 = rnorm(nrow(pheno_data), mean = 5),
         # Calculate the product of dummyVar and dummyVar2
         product = dummyVar*dummyVar2,
         # Create a character variable join two variables with paste0
         cell_dex = paste0(cell_type,"_",individual),
         # Reuse an existing variable and convert to factor
         cell_type = factor(cell_type),
         # Reuse an existing variable and conver into to boolean
         gender = ifelse(gender == "Female",T,F))

pheno_data_with_dummy %>%
  head()


### arrange() ###

pheno_data_with_dummy %>%
  # numeric variable sorted ascending
  arrange(product) %>%
  head()

pheno_data_with_dummy %>%
  # numeric variable sorted descending (function desc())
  arrange(desc(product)) %>%
  head()

pheno_data_with_dummy %>%
  # character variable sorted from A to Z
  arrange(disease_state) %>%
  head()

pheno_data_with_dummy %>%
  # character variable sorted from Z to A
  arrange(desc(disease_state)) %>%
  head()

pheno_data_with_dummy %>%
  # character variable sorted asc.
  arrange(disease_state,
          # numeric variable sorted desc.
          desc(product)) %>%
  head()


##### Aggregate and summarize variables #####

pheno_data_with_dummy %>%
  summarize(mean_dummy = mean(dummyVar),
            mean_dummy2 = mean(dummyVar2))

pheno_data_with_dummy %>%
  # We want to get the same stats from two columns inside vars()
  summarise_at(vars(dummyVar, dummyVar2),
               # The list of functions are mean and median
               list(~mean(.),~median(.)))
# Important keep the structure: ~function(.)

pheno_data_with_dummy %>%
  group_by(cell_type) %>%
  summarise(mean_value = mean(dummyVar))

pheno_data_with_dummy %>%
  group_by(cell_type, gender) %>%
  summarise(mean_value = mean(dummyVar))

### Not run ###
results <- data.frame(cell_type = 0, gender = 0, mean = 0)[0,]
for (cell_type in unique(pheno_data_with_dummy$cell_type)){
  for (gender in unique(pheno_data_with_dummy$gender)){
    meta_data_filt <- pheno_data_with_dummy[pheno_data_with_dummy$cell_type == cell_type & pheno_data_with_dummy$gender == gender,]
    results <- rbind(results, data.frame(cell_type = cell_type,
                                         gender = gender,
                                         mean = mean(meta_data_filt$dummyVar)))
  }
}

print(results)

### Run from this

pheno_data %>%
  group_by(cell_type, gender) %>%
  summarize(n = n())

# Alternative: use count() instead of summarize()
pheno_data %>%
  group_by(cell_type, gender) %>%
  count()

pheno_data %>%
  group_by(cell_type) %>%
  do(head(.,3))


##### Join two datasets #####

results <- read.delim("../input_data/results_table.tsv")
gene_info <- read.delim("../input_data/gene_info.tsv")

results_filt <- results %>%
  filter(log2FoldChange > 1)
gene_info_filt <- gene_info %>%
  filter(chromosome_name == "X")

results_filt %>%
  inner_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  head()

results_filt %>%
  full_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  head()

results_filt %>%
  full_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  tail()

# We use gene_info to have all chromosome_name possibilities
results_filt %>%
  left_join(gene_info, by = c("gene" = "ensembl_gene_id")) %>%
  head()

# We use results to have rows with all log2FoldChange values
results %>%
  right_join(gene_info_filt, by = c("gene" = "ensembl_gene_id")) %>%
  head()

##### Pivot tables #####

norm_counts <- read.delim("../input_data/normalized_counts.tsv")
head(norm_counts[,1:5])

norm_counts <- norm_counts %>%
  column_to_rownames("gene") %>%
  rename_all(funs(stringr::str_replace_all(., 'X', '')))

head(norm_counts[,1:5])

extended_data <- norm_counts %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = colnames(norm_counts),
               names_to = "sample",
               values_to = "expression")

extended_data %>%
  head()

matrix_data <- extended_data %>%
  pivot_wider(names_from = "sample",
              values_from = "expression") %>%
  column_to_rownames("gene")

head(matrix_data[,1:5])


##### Advanced examples #####

norm_counts <- read.delim("../input_data/normalized_counts.tsv") %>%
  column_to_rownames("gene") %>%
  rename_all(funs(stringr::str_replace_all(., 'X', '')))

results <- read.delim("../input_data/results_table.tsv")
gene_info <- read.delim("../input_data/gene_info.tsv")
pheno_data <- read.delim("../input_data/pheno_data.tsv")

### example 1

gene_info %>%
  filter(hgnc_symbol != "") %>%
  inner_join(results, by = c("ensembl_gene_id" = "gene")) %>%
  filter(log2FoldChange > 1, pvalue < 0.05) %>%
  arrange(desc(log2FoldChange)) %>%
  select(hgnc_symbol, log2FoldChange, pvalue)

### example 2

norm_counts %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = colnames(norm_counts),
               names_to = "sample",
               values_to = "expression") %>%
  inner_join(gene_info, by = c("gene" = "ensembl_gene_id")) %>%
  filter(chromosome_name == "1") %>%
  inner_join(pheno_data, by = c("sample" = "title")) %>%
  group_by(disease_state, gene) %>%
  summarize(mean = mean(expression),
            median = median(expression),
            min = min(expression),
            max = max(expression))

### example 3

norm_counts %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = colnames(norm_counts),
               names_to = "sample",
               values_to = "expression") %>%
  inner_join(pheno_data, by = c("sample" = "title")) %>%
  inner_join(gene_info, by = c("gene" = "ensembl_gene_id")) %>%
  filter(chromosome_name %in% c("1","2","3")) %>%
  group_by(gene, disease_state) %>%
  summarize(mean_expr = mean(expression)) %>%
  pivot_wider(names_from = "disease_state", values_from = "mean_expr") %>%
  mutate(diff_mean = `Alzheimer's disease` - `Healthy control`) %>%
  select(gene, diff_mean) %>%
  left_join(gene_info, by = c("gene" = "ensembl_gene_id")) %>%
  arrange(desc(diff_mean)) %>%
  head()
