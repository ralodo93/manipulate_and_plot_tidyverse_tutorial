################################################################################
##  This code was written by Raul Lopez-Dominguez and Marisol Benitez-Cantos  ##
################################################################################

##### Set up preparation #####

library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")

pheno_data <- pheno_data %>%
  mutate(
    dummyVar = rnorm(nrow(pheno_data)), # Variable numérica
    dummyVar_op = dummyVar^2, # Utiliza la variable anterior para crear una nueva
    cell_dex = paste0(cell_type,"_",individual), # Variable caracter
    cell_dex = factor(cell_dex), # Modificar una variable ya creada y crear un factor
    bool = ifelse(gender == "Male", T,F)) %>% # Variable booleana
  as_tibble()

# bucle for

result <- data.frame("cell_type"=0, "mean_val"=0)[0,]

for (cell_type in unique(pheno_data$cell_type)){
  result <- rbind(result, 
                  data.frame("cell_type" = cell_type,
                             "mean_val" = mean(pheno_data[pheno_data$cell_type == cell_type,]$dummyVar)))
}

result

# cell_type    mean_val
# 1               PBMC  0.18218122
# 2 CD4 memory T cells -0.06108258
# 3 CD8 memory T cells  0.02614077

# group_by

pheno_data %>%
  group_by(cell_type)

pheno_data %>%
  group_by(cell_type, gender)

# summarize

pheno_data %>%
  group_by(cell_type) %>%
  summarize(mean_val = mean(dummyVar),
            var_val = var(dummyVar))

# # A tibble: 3 x 3
# cell_type          mean_val var_val
# <chr>                 <dbl>   <dbl>
#   1 CD4 memory T cells  -0.0611   0.789
# 2 CD8 memory T cells   0.0261   1.24 
# 3 PBMC                 0.182    1.30

pheno_data %>%
  group_by(cell_type, gender) %>%
  summarize(mean_val = mean(dummyVar),
            var_val = var(dummyVar))

# # A tibble: 6 x 4
# # Groups:   cell_type [3]
# cell_type          gender mean_val var_val
# <chr>              <chr>     <dbl>   <dbl>
#   1 CD4 memory T cells Female -0.210     0.757
# 2 CD4 memory T cells Male    0.0825    0.806
# 3 CD8 memory T cells Female  0.0616    1.35 
# 4 CD8 memory T cells Male   -0.00936   1.16 
# 5 PBMC               Female  0.150     1.70 
# 6 PBMC               Male    0.213     0.964

# count

pheno_data %>%
  group_by(cell_type) %>%
  count()

pheno_data %>%
  group_by(cell_type) %>%
  summarise(n = n())

# # A tibble: 3 x 2
# # Groups:   cell_type [3]
# cell_type              n
# <chr>              <int>
#   1 CD4 memory T cells    55
# 2 CD8 memory T cells    56
# 3 PBMC                  55

# summarise_at

pheno_data %>%
  group_by(cell_type) %>%
  # indicamos las dos columnas de las cuales queremos conocer una serie de resultados
  # usando la función vars()
  summarise_at(vars(dummyVar, dummyVar_op),
               # el segundo parámetro es una lista de funciones que deben tener la estructura:
               # ~function(.)
               list(~mean(.),~median(.)))

# # A tibble: 3 x 5
# cell_type          dummyVar_mean dummyVar_op_mean dummyVar_median dummyVar_op_median
# <chr>                      <dbl>            <dbl>           <dbl>              <dbl>
#   1 CD4 memory T cells       -0.0611            0.778          -0.145              0.410
# 2 CD8 memory T cells        0.0261            1.21            0.132              0.710
# 3 PBMC                      0.182             1.31            0.161              0.617

# slice_head

pheno_data %>%
  group_by(cell_type) %>%
  slice_head(n = 2)

# # A tibble: 6 x 9
# # Groups:   cell_type [3]
# title     individual cell_type          disease_state   gender dummyVar dummyVar_op cell_dex        bool 
# <chr>          <int> <chr>              <chr>           <chr>     <dbl>       <dbl> <fct>           <lgl>
#   1 2950_CD4        2950 CD4 memory T cells Healthy control Male      0.800       0.640 CD4 memory T c~ TRUE 
# 2 2951_CD4        2951 CD4 memory T cells Healthy control Female   -1.24        1.54  CD4 memory T c~ FALSE
# 3 2950_CD8        2950 CD8 memory T cells Healthy control Male     -1.31        1.73  CD8 memory T c~ TRUE 
# 4 2951_CD8        2951 CD8 memory T cells Healthy control Female    0.558       0.311 CD8 memory T c~ FALSE
# 5 2950_PBMC       2950 PBMC               Healthy control Male     -0.624       0.389 PBMC_2950       TRUE 
# 6 2951_PBMC       2951 PBMC               Healthy control Female   -2.53        6.38  PBMC_2951       FALSE