# Uso de **select()** y **filter()**

En esta clase se explicar� en profundidad el uso de las funciones **select()** y **filter()** del paquete `dplyr`, as� como algunas buenas pr�cticas o trucos para su uso.

- Seleccionar las columnas que se quieren mostrar con **select()**.
- Filtrar las filas que no cumplen ciertas condiciones con **filter()**.

```{r}
library(tidyverse)
pheno_data <- read.delim("../../input_data/pheno_data.tsv")
```


## **select()**

La funci�n **select()** es una de las m�s usadas y una de las m�s sencillas de entender. Se aplica sobre un data.frame o tibble y genera un data.frame o tibble en el cual se han seleccionado solo algunas de las columnas que conten�a el dataset original. El uso m�s extendido de **select()** es simplemente introduciendo el nombre de las columnas que se desean mantener.

```{r}
pheno_data %>%
  select(title, individual) %>% # Mantener title y individual. Eliminar el resto
  head()
  
# # A tibble: 6 x 2
# title     individual
# <chr>          <int>
#   1 2950_PBMC       2950
# 2 2951_PBMC       2951
# 3 2965_PBMC       2965
# 4 2964_PBMC       2964
# 5 3015_PBMC       3015
# 6 2972_PBMC       2972
```

Sin embargo, no es la �nica forma de usar **select()**. Se pueden seleccionar las columnas que est�n colocadas entre una y otra (por ejemplo, seleccionar las columnas entre *individual* y *disease_state*) o eliminar alguna columna en concreto.

```{r}
pheno_data %>%
  select(individual:disease_state) # Selecciona las columnas entre individual y disease_state

pheno_data %>%
  select(-title,-individual) # Elimina las columnas title y individual
```

### Buenas pr�cticas de **select()**

Una de las cosas que se pueden hacer aprovechando las capacidades de **select()** es ordenar las columnas del dataset. En este caso no se seleciona ninguna columna, sino que se altera el orden de las mismas.

```{r}
pheno_data %>%
  select(individual, cell_type, disease_state, gender, title)
```

**select()** tambi�n funciona con algunas funciones de `tidyverse` como **starts_with()** o **ends_with()**, es decir, funciones que utilizan la b�squeda de patrones o expresiones regulares.

```{r}
pheno_data %>%
  select(ends_with("e")) # Selecciona las columnas que acaben con "e"
```

En caso de tener un vector externo con el nombre de las columnas que se quieren seleccionar, se debe usar la funci�n **all_of()** o **any_of()**.

```{r}
keep_cols <- c("title","gender","cell_type")

pheno_data %>%
  select(all_of(keep_cols))
```

## **filter()**

La funci�n **filter()** se utiliza para mantener ciertas filas que cumplen con las condiciones que se le indican. El m�todo m�s usual de usar **filter()** es indicando que columna o columnas deben cumplir una determinada condici�n.

```{r}
pheno_data %>%
  filter(cell_type == "PBMC") %>% # Solo mantener las filas cuyo cell_type sea PBMC
  head()

# title individual cell_type   disease_state gender
# 1 2950_PBMC       2950      PBMC Healthy control   Male
# 2 2951_PBMC       2951      PBMC Healthy control Female
# 3 2965_PBMC       2965      PBMC Healthy control Female
# 4 2964_PBMC       2964      PBMC Healthy control Female
# 5 3015_PBMC       3015      PBMC Healthy control   Male
# 6 2972_PBMC       2972      PBMC Healthy control Female
```

Las condiciones que se incluyen dentro de **filter()** pueden ser m�ltiples y tan complejas como sea necesario. Las funciones de filtro m�s utilizadas son los operadores relacionales (==, >, <=, != etc), operadores l�gicos (&, |, !), el operador %in%, o **is.na()**, **between()** y **near()**.

```{r}
pheno_data %>%
  # Keep the rows with the cell_type different from "PBMC"
  filter(gender != "Male",
         # And with the disease_state equal to "Healthy control"
         disease_state == "Healthy control") %>%
  head()
```