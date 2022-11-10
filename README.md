# Tutorial para manipular y visualizar datos con `tidyverse`

Este tutorial se ha realizado con el fin de dar a conocer los conceptos clave, as� como una serie de buenas pr�cticas a la hora de manipular y generar gr�ficos con el paquete de R `tidyverse`. Este paquete incluye una serie de librer�as dirigidas a generar tablas de tipo *tidy table* con las que se pueden generar gr�ficos muy personalizados con `ggplot2`. Antes de comenzar, los requisitos iniciales del curso son:

- Tener instalado tanto R como la librer�a `tidyverse` desde [aqu�](https://www.r-project.org/).
- Conocimientos muy b�sicos de programaci�n en R.

## �C�mo puedo usar este repositorio?

En este repositorio hay tres carpetas numeradas: 

- [0_prepare_data](0_prepare_data) donde est� alojado el c�digo que hemos usado para generar los datos se van a usar de ejemplo. No es necesario para este curso.

- [1_manipulate_data](1_manipulate_data) donde se alojan las diferentes clases acerca de como se pueden manejar los datos utilizando algunas de las librer�a que incluye `tidyverse`, tales como `dplyr` o `tibble`.

- [2_visualize_data](2_visualize_data) donde se alojan las diferentes clases en las que se muestran  los conceptos b�sicos de `ggplot2` y como sacar rendimiento del mismo para generar figuras muy personalizadas.

Adem�s, se incluye una carpeta llamada [input_data](input_data) en la cual se incluyen los datos de ejemplo que se van a utilizar. Estos datos de ejemplo proceden de un dataset descargado de NCBI GEO que incluye datos de RNA-Seq de m�ltiples muestras con y sin Alzheimer. Para ilustrar como manejar las librer�as de `tidyverse` se usar�n las siguientes tablas:

- **pheno_data.tsv** contiene la informaci�n cl�nica de las muestras.
- **normalized_counts.tsv** es la matriz de expresi�n de cada muestra. Con genes en filas y muestras en columnas.
- **gene_info.tsv** muestra informaci�n sobre los genes
- **results_table.tsv** es el resultado de aplicar un an�lisis de expresi�n diferencial entre las muestras de pacientes con Alzheimer y las muestras sanas.
