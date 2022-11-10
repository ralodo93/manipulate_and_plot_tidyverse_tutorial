################################################################################
##  This code was written by Raul Lopez-Dominguez and Marisol Benitez-Cantos  ##
################################################################################

##### Set up preparation #####

library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")
head(as_tibble(pheno_data))

# # A tibble: 6 x 5
# title     individual cell_type disease_state   gender
# <chr>          <int> <chr>     <chr>           <chr> 
#   1 2950_PBMC       2950 PBMC      Healthy control Male  
# 2 2951_PBMC       2951 PBMC      Healthy control Female
# 3 2965_PBMC       2965 PBMC      Healthy control Female
# 4 2964_PBMC       2964 PBMC      Healthy control Female
# 5 3015_PBMC       3015 PBMC      Healthy control Male  
# 6 2972_PBMC       2972 PBMC      Healthy control Female

##### Pipes #####

pheno_data %>% # La pipe está enviando la información de pheno_data a head()
  head() %>% # Ejecuta head() y envía el resultado a as_tibble()
  as_tibble() # Ejecuta as_tibble()