### Preparing set up ####
library(tidyverse)
pheno_data <- read.delim("../../example_data/pheno_data.tsv")

### Pipes to build a super code ###

pheno_data %>%
  head() %>%
  as.data.frame()

pheno_data %>%
  unique()

pheno_data %>%
  na.omit()

### How select columns?

pheno_data %>%
  # Include variables to keep
  select(title, individual, cell_type)

pheno_data %>%
  # With the - you remove the variables that you want
  select(-title)

pheno_data %>%
  # You can remove more than one variables
  select(-title, -individual)

pheno_data %>%
  # With : you indicate that want the variables from x to y
  select(individual:cell_type)

### How filter rows

pheno_data %>%
  filter(cell_type != "PBMC", # cell_type different of PBMC
         # AND
         disease_state == "Healthy control") # only healthy samples

pheno_data %>%
  filter(disease_state == "Healthy control", # only healthy samples
          # AND
         (cell_type == "PBMC" | cell_type == "CD4 memory T cells")) # PBMC or CD4 Mem

pheno_data %>%
  filter(cell_type == "CD8 memory T cells") %>%
  select(-cell_type) %>%
  head()
