################################################################################
##  This code was written by Raul Lopez-Dominguez and Marisol Benitez-Cantos  ##
################################################################################

##### Set up preparation #####

library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")

## select()

pheno_data %>%
  select(title, individual) %>% # Mantener title y individual. Eliminar el resto
  as_tibble()

# # A tibble: 166 x 2
# title     individual
# <chr>          <int>
#   1 2950_PBMC       2950
# 2 2951_PBMC       2951
# 3 2965_PBMC       2965
# 4 2964_PBMC       2964
# 5 3015_PBMC       3015
# 6 2972_PBMC       2972
# 7 3019_PBMC       3019
# 8 3022_PBMC       3022
# 9 3114_PBMC       3114
# 10 3115_PBMC       3115
# # ... with 156 more rows


pheno_data %>%
  select(individual:disease_state) %>% # Selecciona las columnas entre individual y disease_state
  as_tibble()

# # A tibble: 166 x 3
# individual cell_type disease_state      
# <int> <chr>     <chr>              
#   1       2950 PBMC      Healthy control    
# 2       2951 PBMC      Healthy control    
# 3       2965 PBMC      Healthy control    
# 4       2964 PBMC      Healthy control    
# 5       3015 PBMC      Healthy control    
# 6       2972 PBMC      Healthy control    
# 7       3019 PBMC      Healthy control    
# 8       3022 PBMC      Alzheimer's disease
#  9       3114 PBMC      Alzheimer's disease
# 10       3115 PBMC      Alzheimer's disease
# # ... with 156 more rows


pheno_data %>%
  select(-title,-individual) %>% # Elimina las columnas title y individual
  as_tibble()

# # A tibble: 166 x 3
# cell_type disease_state       gender
# <chr>     <chr>               <chr> 
#   1 PBMC      Healthy control     Male  
# 2 PBMC      Healthy control     Female
# 3 PBMC      Healthy control     Female
# 4 PBMC      Healthy control     Female
# 5 PBMC      Healthy control     Male  
# 6 PBMC      Healthy control     Female
# 7 PBMC      Healthy control     Female
# 8 PBMC      Alzheimer's disease Male  
#  9 PBMC      Alzheimer's disease Female
# 10 PBMC      Alzheimer's disease Male  
# # ... with 156 more rows


pheno_data %>%
  select(individual, cell_type, disease_state, gender, title) %>%
  as_tibble()

# # A tibble: 166 x 5
# individual cell_type disease_state       gender title    
# <int> <chr>     <chr>               <chr>  <chr>    
#   1       2950 PBMC      Healthy control     Male   2950_PBMC
# 2       2951 PBMC      Healthy control     Female 2951_PBMC
# 3       2965 PBMC      Healthy control     Female 2965_PBMC
# 4       2964 PBMC      Healthy control     Female 2964_PBMC
# 5       3015 PBMC      Healthy control     Male   3015_PBMC
# 6       2972 PBMC      Healthy control     Female 2972_PBMC
# 7       3019 PBMC      Healthy control     Female 3019_PBMC
# 8       3022 PBMC      Alzheimer's disease Male   3022_PBMC
#  9       3114 PBMC      Alzheimer's disease Female 3114_PBMC
# 10       3115 PBMC      Alzheimer's disease Male   3115_PBMC
# # ... with 156 more rows


pheno_data %>%
  select(ends_with("e")) %>% # Selecciona las columnas que acaben con "e"
  as_tibble()

# # A tibble: 166 x 3
# title     cell_type disease_state      
# <chr>     <chr>     <chr>              
#   1 2950_PBMC PBMC      Healthy control    
# 2 2951_PBMC PBMC      Healthy control    
# 3 2965_PBMC PBMC      Healthy control    
# 4 2964_PBMC PBMC      Healthy control    
# 5 3015_PBMC PBMC      Healthy control    
# 6 2972_PBMC PBMC      Healthy control    
# 7 3019_PBMC PBMC      Healthy control    
# 8 3022_PBMC PBMC      Alzheimer's disease
#  9 3114_PBMC PBMC      Alzheimer's disease
# 10 3115_PBMC PBMC      Alzheimer's disease
# # ... with 156 more rows


keep_cols <- c("title","gender","cell_type")

pheno_data %>%
  select(all_of(keep_cols)) %>%
  as_tibble()

# # A tibble: 166 x 3
# title     gender cell_type
# <chr>     <chr>  <chr>    
#   1 2950_PBMC Male   PBMC     
# 2 2951_PBMC Female PBMC     
# 3 2965_PBMC Female PBMC     
# 4 2964_PBMC Female PBMC     
# 5 3015_PBMC Male   PBMC     
# 6 2972_PBMC Female PBMC     
# 7 3019_PBMC Female PBMC     
# 8 3022_PBMC Male   PBMC     
# 9 3114_PBMC Female PBMC     
# 10 3115_PBMC Male   PBMC     
# # ... with 156 more rows

## filter()

pheno_data %>%
  filter(cell_type == "PBMC") %>% # Solo mantener las filas cuyo cell_type sea PBMC
  as_tibble()

# # A tibble: 55 x 5
# title     individual cell_type disease_state       gender
# <chr>          <int> <chr>     <chr>               <chr> 
#   1 2950_PBMC       2950 PBMC      Healthy control     Male  
# 2 2951_PBMC       2951 PBMC      Healthy control     Female
# 3 2965_PBMC       2965 PBMC      Healthy control     Female
# 4 2964_PBMC       2964 PBMC      Healthy control     Female
# 5 3015_PBMC       3015 PBMC      Healthy control     Male  
# 6 2972_PBMC       2972 PBMC      Healthy control     Female
# 7 3019_PBMC       3019 PBMC      Healthy control     Female
# 8 3022_PBMC       3022 PBMC      Alzheimer's disease Male  
#  9 3114_PBMC       3114 PBMC      Alzheimer's disease Female
# 10 3115_PBMC       3115 PBMC      Alzheimer's disease Male  
# # ... with 45 more rows


pheno_data %>%
  filter(gender != "Male", # Género diferente de "Male"
         disease_state == "Healthy control", # Solo "Healthy control"
         # cell type que incluya los valores del vector
         cell_type %in% c("CD4 memory T cells","CD8 memory T cells")) %>% 
  as_tibble()

# # A tibble: 32 x 5
# title    individual cell_type          disease_state   gender
# <chr>         <int> <chr>              <chr>           <chr> 
#   1 2951_CD4       2951 CD4 memory T cells Healthy control Female
# 2 2965_CD4       2965 CD4 memory T cells Healthy control Female
# 3 2964_CD4       2964 CD4 memory T cells Healthy control Female
# 4 2999_CD4       2999 CD4 memory T cells Healthy control Female
# 5 2972_CD4       2972 CD4 memory T cells Healthy control Female
# 6 3292_CD4       3292 CD4 memory T cells Healthy control Female
# 7 3344_CD4       3344 CD4 memory T cells Healthy control Female
# 8 3454_CD4       3454 CD4 memory T cells Healthy control Female
# 9 3420_CD4       3420 CD4 memory T cells Healthy control Female
# 10 2948_CD4       2948 CD4 memory T cells Healthy control Female
# # ... with 22 more rows