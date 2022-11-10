# Manipular datos con `tidyverse`

El paquete `tidyverse` contiene varias de las librer�as m�s utilizadas y optimizadas para manipular y explorar datos. En esta primera clase se abordar�n los siguientes temas

- Introducci�n a `dplyr` y `tibble`
- Concepto de `tidy table`
- Uso de pipes

## Introducci�n a `dplyr` y `tibble`

Estas dos librer�as son muy utilizadas a la hora de poder manipular los datos. `dplyr` se basa en un concepto llamado *grammar of data manipulation*, que no es m�s que la descomposici�n de un proceso completo sobre una tabla a trav�s de diferentes pasos (tambi�n llamados verbos, ya que las funciones cogen nombre de verbos.). Por otro lado, `tibble` es un concepto moderno de lo que usualmente se conocen como data.frame. De ambas librer�as se usar�n funciones que servir�n para manejar los datos y preparlos en un formato de `tidy table`.

## Concepto de `tidy table`

�Qu� es una `tidy table`? La mayor�a de los datasets que se utilizan en ciencias de datos ya son `tidy tables`. Una `tidy table` no es m�s que una tabla en la que cada registro se almacena en una l�nea o fila diferente mientras que las columnas aportan diferentes variables acerca de ese registro. En los datos de ejemplos propuestos para este curso, una `tidy table` es la tabla **pheno_data** ya que cada fila de la misma contiene informaci�n de cada muestra.

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

Cada fila corresponde a una muestra (*title*) y tiene informaci�n acerca de la misma, como el identificador de individuo (*individual*), el tipo celular (*cell_type*), si tiene Alzheimer o no (*disease_state*) y el g�nero (*gender*).

Es de suma importancia mantener este formato ya que `ggplot2` solo aceptar� tablas de este modo. En ning�n caso se podr�n utilizar matrices u otro tipo de formato de tablas.

## Uso de pipes

Para terminar esta clase se abordar� el uso de las tuber�as (o pipes) en los datasets. Para utilizarlos se usa la funci�n **%>%** del paquete `dplyr`. Pero... �qu� es una pipe?. Una pipe no es m�s que una forma de enviar la informaci�n que sale de una acci�n para que se procese en otra acci�n. Por ejemplo:

```{r}
pheno_data %>% # La pipe est� enviando la informaci�n de pheno_data a head()
  head() %>% # Ejecuta head() y env�a el resultado a as_tibble()
  as_tibble() # Ejecuta as_tibble()
```
La base de las funciones de `dplyr` y `tibble` es el uso de estos pipes con el fin de hacer un c�digo mucho m�s legible y claro. Adem�s, por lo general suele ser m�s preciso utilizar una serie de pipe y generar un objeto a guardar que generar un objeto diferente para cada paso que se quiera realizar.