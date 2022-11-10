################################################################################
##  This code was written by Raul Lopez-Dominguez and Marisol Benitez-Cantos  ##
################################################################################

##### Set up preparation #####

library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")

## select()

pheno_data %>%
  select(title, individual) %>% # Mantener title y individual. Eliminar el resto
  head() %>%
  as_tibble()

# # A tibble: 6 x 2
# title     individual
# <chr>          <int>
#   1 2950_PBMC       2950
# 2 2951_PBMC       2951
# 3 2965_PBMC       2965
# 4 2964_PBMC       2964
# 5 3015_PBMC       3015
# 6 2972_PBMC       2972

pheno_data %>%
  select(individual:disease_state) # Selecciona las columnas entre individual y disease_state

pheno_data %>%
  select(-title,-individual) # Elimina las columnas title y individual

pheno_data %>%
  select(ends_with("e"))

keep_cols <- c("title","gender","cell_type")

pheno_data %>%
  select(all_of(keep_cols))


## filter()

pheno_data %>%
  filter(cell_type == "PBMC") %>%
  head()

# title individual cell_type   disease_state gender
# 1 2950_PBMC       2950      PBMC Healthy control   Male
# 2 2951_PBMC       2951      PBMC Healthy control Female
# 3 2965_PBMC       2965      PBMC Healthy control Female
# 4 2964_PBMC       2964      PBMC Healthy control Female
# 5 3015_PBMC       3015      PBMC Healthy control   Male
# 6 2972_PBMC       2972      PBMC Healthy control Female
