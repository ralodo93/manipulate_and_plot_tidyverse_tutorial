# Uso de **mutate()**, **rename()** y **arrange()**

En esta clase se explicará en profundidad el uso de las funciones **mutate()**, **rename()**  y **arrange()** del paquete `dplyr`, así como algunas buenas prácticas o trucos para su uso.

- Crear una nueva variable con **mutate()**.
- Cambiar el nombre de las columnas con **rename()**.
- Ordenar la tabla con **arrange()**.

```{r}
library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")
```


## **mutate()**

La función **mutate()** se utiliza para crear una nueva variable. Esta variable puede utilizar las propias columnas de la tabla o datos externos. Para utilizarla tan solo se debe atribuir el nombre de la variable a crear y definir su contenido.

```{r}
pheno_data <- pheno_data %>%
  mutate(
    dummyVar = rnorm(nrow(pheno_data)), # Variable numérica
    dummyVar_op = dummyVar^2, # Utiliza la variable anterior para crear una nueva
    cell_dex = paste0(cell_type,"_",individual), # Variable caracter
    cell_dex = factor(cell_dex), # Modificar una variable ya creada y crear un factor
    bool = ifelse(gender == "Male", T,F)) %>% # Variable booleana
  as_tibble()

pheno_data

# # A tibble: 166 x 9
# title     individual cell_type disease_state       gender dummyVar dummyVar_op cell_dex  bool
# <chr>          <int> <chr>     <chr>               <chr>     <dbl>       <dbl> <fct>     <lgl>
#   1 2950_PBMC       2950 PBMC      Healthy control     Male    0.00861   0.0000741 PBMC_2950 TRUE
# 2 2951_PBMC       2951 PBMC      Healthy control     Female  0.0638    0.00407   PBMC_2951 FALSE
# 3 2965_PBMC       2965 PBMC      Healthy control     Female  0.371     0.138     PBMC_2965 FALSE
# 4 2964_PBMC       2964 PBMC      Healthy control     Female  0.563     0.317     PBMC_2964 FALSE
# 5 3015_PBMC       3015 PBMC      Healthy control     Male    0.770     0.592     PBMC_3015 TRUE
# 6 2972_PBMC       2972 PBMC      Healthy control     Female -0.217     0.0472    PBMC_2972 FALSE
# 7 3019_PBMC       3019 PBMC      Healthy control     Female -1.30      1.69      PBMC_3019 FALSE
# 8 3022_PBMC       3022 PBMC      Alzheimer's disease Male    1.29      1.66      PBMC_3022 TRUE
#  9 3114_PBMC       3114 PBMC      Alzheimer's disease Female -1.32      1.74      PBMC_3114 FALSE
# 10 3115_PBMC       3115 PBMC      Alzheimer's disease Male    0.105     0.0110    PBMC_3115 TRUE
# # ... with 156 more rows
```

## `rename()`

Con la función **rename()** se pueden renombrar nombres de una o más columnas.

```{r}
pheno_data %>%
  rename("title_new" = "title") # Pon el nuevo nombre a la columna que desees cambiar

# # A tibble: 166 x 9
# title_new individual cell_type disease_state       gender dummyVar dummyVar_op cell_dex  bool
# <chr>          <int> <chr>     <chr>               <chr>     <dbl>       <dbl> <fct>     <lgl>
#   1 2950_PBMC       2950 PBMC      Healthy control     Male   -0.00785   0.0000616 PBMC_2950 TRUE
# 2 2951_PBMC       2951 PBMC      Healthy control     Female -1.36      1.86      PBMC_2951 FALSE
# 3 2965_PBMC       2965 PBMC      Healthy control     Female -1.45      2.09      PBMC_2965 FALSE
# 4 2964_PBMC       2964 PBMC      Healthy control     Female  0.514     0.264     PBMC_2964 FALSE
# 5 3015_PBMC       3015 PBMC      Healthy control     Male   -0.189     0.0358    PBMC_3015 TRUE
# 6 2972_PBMC       2972 PBMC      Healthy control     Female  0.319     0.102     PBMC_2972 FALSE
# 7 3019_PBMC       3019 PBMC      Healthy control     Female -0.665     0.443     PBMC_3019 FALSE
# 8 3022_PBMC       3022 PBMC      Alzheimer's disease Male    1.36      1.85      PBMC_3022 TRUE
#  9 3114_PBMC       3114 PBMC      Alzheimer's disease Female -0.688     0.473     PBMC_3114 FALSE
# 10 3115_PBMC       3115 PBMC      Alzheimer's disease Male   -0.414     0.171     PBMC_3115 TRUE
# # ... with 156 more rows

pheno_data %>%
  # Puedes cambiar el nombre de más de una columna
  rename("title_new" = "title", "cell_dex_new" = "cell_type")

# # A tibble: 166 x 9
# title_new individual cell_dex_new disease_state       gender dummyVar dummyVar_op cell_dex  bool
# <chr>          <int> <chr>        <chr>               <chr>     <dbl>       <dbl> <fct>     <lgl>
#   1 2950_PBMC       2950 PBMC         Healthy control     Male   -0.00785   0.0000616 PBMC_2950 TRUE
# 2 2951_PBMC       2951 PBMC         Healthy control     Female -1.36      1.86      PBMC_2951 FALSE
# 3 2965_PBMC       2965 PBMC         Healthy control     Female -1.45      2.09      PBMC_2965 FALSE
# 4 2964_PBMC       2964 PBMC         Healthy control     Female  0.514     0.264     PBMC_2964 FALSE
# 5 3015_PBMC       3015 PBMC         Healthy control     Male   -0.189     0.0358    PBMC_3015 TRUE
# 6 2972_PBMC       2972 PBMC         Healthy control     Female  0.319     0.102     PBMC_2972 FALSE
# 7 3019_PBMC       3019 PBMC         Healthy control     Female -0.665     0.443     PBMC_3019 FALSE
# 8 3022_PBMC       3022 PBMC         Alzheimer's disease Male    1.36      1.85      PBMC_3022 TRUE
#  9 3114_PBMC       3114 PBMC         Alzheimer's disease Female -0.688     0.473     PBMC_3114 FALSE
# 10 3115_PBMC       3115 PBMC         Alzheimer's disease Male   -0.414     0.171     PBMC_3115 TRUE
# # ... with 156 more rows
```

## `arrange()`

Para ordenar una tabla en base a una o varias columnas se utiliza la función **arrange()**.

```{r}
pheno_data %>%
  arrange(dummyVar) # Ordenar de menor a mayor una columna numérica

# # A tibble: 166 x 9
# title     individual cell_type          disease_state       gender dummyVar dummyVar_op cell_dex   bool
# <chr>          <int> <chr>              <chr>               <chr>     <dbl>       <dbl> <fct>      <lgl>
#   1 3190_CD4m       3190 CD4 memory T cells Healthy control     Female    -2.56        6.56 CD4 memor~ FALSE
# 2 3195_PBMC       3195 PBMC               Healthy control     Male      -2.49        6.21 PBMC_3195  TRUE
# 3 3170_PBMC       3170 PBMC               Alzheimer's disease Female    -2.09        4.35 PBMC_3170  FALSE
#  4 3204_CD8m       3204 CD8 memory T cells Healthy control     Female    -2.01        4.02 CD8 memor~ FALSE
#  5 3152_CD4m       3152 CD4 memory T cells Alzheimer's disease Male      -1.80        3.23 CD4 memor~ TRUE
# 6 3330_CD8m       3330 CD8 memory T cells Alzheimer's disease Male      -1.73        3.00 CD8 memor~ TRUE
#  7 3277_CD8m       3277 CD8 memory T cells Healthy control     Female    -1.63        2.66 CD8 memor~ FALSE
#  8 3182_CD8        3182 CD8 memory T cells Alzheimer's disease Male      -1.57        2.48 CD8 memor~ TRUE
# 9 3180_PBMC       3180 PBMC               Healthy control     Male      -1.49        2.23 PBMC_3180  TRUE
# 10 3175_CD4        3175 CD4 memory T cells Alzheimer's disease Male      -1.49        2.23 CD4 memor~ TRUE
# # ... with 156 more rows

pheno_data %>%
  arrange(desc(dummyVar)) # Ordenar de mayor a menor una columna numérica

# # A tibble: 166 x 9
# title     individual cell_type          disease_state       gender dummyVar dummyVar_op cell_dex   bool
# <chr>          <int> <chr>              <chr>               <chr>     <dbl>       <dbl> <fct>      <lgl>
#   1 3345_CD8m       3345 CD8 memory T cells Healthy control     Male       2.39        5.69 CD8 memor~ TRUE
# 2 3183_CD4        3183 CD4 memory T cells Alzheimer's disease Male       2.17        4.71 CD4 memor~ TRUE
#  3 3342_CD8m       3342 CD8 memory T cells Alzheimer's disease Male       2.06        4.25 CD8 memor~ TRUE
# 4 2983_CD4        2983 CD4 memory T cells Alzheimer's disease Female     1.89        3.57 CD4 memor~ FALSE
#  5 3635_CD4        3635 CD4 memory T cells Healthy control     Male       1.67        2.77 CD4 memor~ TRUE
#  6 3420_PBMC       3420 PBMC               Healthy control     Female     1.57        2.45 PBMC_3420  FALSE
#  7 2951_CD8        2951 CD8 memory T cells Healthy control     Female     1.54        2.38 CD8 memor~ FALSE
#  8 3022_CD4        3022 CD4 memory T cells Alzheimer's disease Male       1.48        2.20 CD4 memor~ TRUE
# 9 3115_CD4        3115 CD4 memory T cells Alzheimer's disease Male       1.48        2.18 CD4 memor~ TRUE
# 10 3139_CD8        3139 CD8 memory T cells Alzheimer's disease Male       1.42        2.02 CD8 memor~ TRUE
# # ... with 156 more rows

pheno_data %>%
  arrange(disease_state, # Ordenar de menor a mayor una columna caracter
          dummyVar) # En caso de empate, ordenar de menor a mayor la variable dummyVar

# # A tibble: 166 x 9
# title     individual cell_type          disease_state       gender dummyVar dummyVar_op cell_dex   bool
# <chr>          <int> <chr>              <chr>               <chr>     <dbl>       <dbl> <fct>      <lgl>
#   1 3170_PBMC       3170 PBMC               Alzheimer's disease Female    -2.09        4.35 PBMC_3170  FALSE
#  2 3152_CD4m       3152 CD4 memory T cells Alzheimer's disease Male      -1.80        3.23 CD4 memor~ TRUE
# 3 3330_CD8m       3330 CD8 memory T cells Alzheimer's disease Male      -1.73        3.00 CD8 memor~ TRUE
#  4 3182_CD8        3182 CD8 memory T cells Alzheimer's disease Male      -1.57        2.48 CD8 memor~ TRUE
# 5 3175_CD4        3175 CD4 memory T cells Alzheimer's disease Male      -1.49        2.23 CD4 memor~ TRUE
#  6 3118_PBMC       3118 PBMC               Alzheimer's disease Female    -1.40        1.97 PBMC_3118  FALSE
# 7 3153_PBMC       3153 PBMC               Alzheimer's disease Male      -1.28        1.65 PBMC_3153  TRUE
#  8 2983_CD8        2983 CD8 memory T cells Alzheimer's disease Female    -1.22        1.49 CD8 memor~ FALSE
# 9 3155_PBMC       3155 PBMC               Alzheimer's disease Female    -1.12        1.26 PBMC_3155  FALSE
# 10 3279_CD8        3279 CD8 memory T cells Alzheimer's disease Female    -1.08        1.16 CD8 memor~ FALSE
# # ... with 156 more rows
```
