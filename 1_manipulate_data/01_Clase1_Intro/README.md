# Manipular datos con `tidyverse`

El paquete `tidyverse` contiene varias de las librerías más utilizadas y optimizadas para manipular y explorar datos. En esta primera clase se abordarán los siguientes temas

- Introducción a `dplyr` y `tibble`
- Concepto de `tidy table`
- Uso de pipes

## Introducción a `dplyr` y `tibble`

Estas dos librerías son muy utilizadas a la hora de poder manipular los datos. `dplyr` se basa en un concepto llamado *grammar of data manipulation*, que no es más que la descomposición de un proceso completo sobre una tabla a través de diferentes pasos (también llamados verbos, ya que las funciones cogen nombre de verbos.). Por otro lado, `tibble` es un concepto moderno de lo que usualmente se conocen como data.frame. De ambas librerías se usarán funciones que servirán para manejar los datos y preparlos en un formato de `tidy table`.

## Concepto de `tidy table`

¿Qué es una `tidy table`? La mayoría de los datasets que se utilizan en ciencias de datos ya son `tidy tables`. Una `tidy table` no es más que una tabla en la que cada registro se almacena en una línea o fila diferente mientras que las columnas aportan diferentes variables acerca de ese registro. En los datos de ejemplos propuestos para este curso, una `tidy table` es la tabla **pheno_data** ya que cada fila de la misma contiene información de cada muestra.

```{r}
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

```

Cada fila corresponde a una muestra (*title*) y tiene información acerca de la misma, como el identificador de individuo (*individual*), el tipo celular (*cell_type*), si tiene Alzheimer o no (*disease_state*) y el género (*gender*).

Es de suma importancia mantener este formato ya que `ggplot2` solo aceptará tablas de este modo. En ningún caso se podrán utilizar matrices u otro tipo de formato de tablas.

## Uso de pipes

Para terminar esta clase se abordará el uso de las tuberías (o pipes) en los datasets. Para utilizarlos se usa la función **%>%** del paquete `dplyr`. Pero... ¿qué es una pipe?. Una pipe no es más que una forma de enviar la información que sale de una acción para que se procese en otra acción. Por ejemplo:

```{r}
pheno_data %>% # La pipe está enviando la información de pheno_data a head()
  head() %>% # Ejecuta head() y envía el resultado a as_tibble()
  as_tibble() # Ejecuta as_tibble()
```
La base de las funciones de `dplyr` y `tibble` es el uso de estos pipes con el fin de hacer un código mucho más legible y claro. Además, por lo general suele ser más preciso utilizar una serie de pipe y generar un objeto a guardar que generar un objeto diferente para cada paso que se quiera realizar.