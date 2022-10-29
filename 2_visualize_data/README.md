# Visualize Data with `tidyverse`

The package `tidyverse` contains some useful packages to explore scientific data. In this section we will learn how manipulate this data, which usually is collected in tables or matrices. In this season we will learn the basic concepts of `ggplot2` to visualize your data.

The structure of a table to be used in `ggplot2` is a classic table of records similar to our pheno_data table.

```{r}
pheno_data <- read.delim("../input_data/pheno_data.tsv")
head(pheno_data)
```

## Prepare set up

Prepare `tidyverse` and read all the tables from input_data.

```{r}
library(tidyverse)
norm_counts <- read.delim("../input_data/normalized_counts.tsv") %>%
  column_to_rownames("gene") %>%
  rename_all(funs(stringr::str_replace_all(., 'X', '')))
extended_data <- norm_counts %>%
  rownames_to_column("gene") %>%
  pivot_longer(cols = colnames(norm_counts),
               names_to = "sample",
               values_to = "expression")

results <- read.delim("../input_data/results_table.tsv")
gene_info <- read.delim("../input_data/gene_info.tsv")
pheno_data <- read.delim("../input_data/pheno_data.tsv")
```

## Basic concepts of `ggplot2`

In this section you are going to learn the very basic concepts around `ggplot2`. It is said that `ggplot2` is a plot builder that uses the *grammar of graphics* with an intuitive sintax. As we have said, `ggplot2` only works with tidy data (rows as records).

In the `ggplot2` sintax we can define or differenciate six different layers. Three of then are the main layers, without them we have not any figure. These layers are:

- **data**. The dataset that we want to plot
- **geom**. The type of of plot (points, lines, boxplot, heatmap)
- **aes**. We define the aesthetic as the properties of the geometric object (x and y axis position, color, shape)

The other three layers are:

- **scale**. Module different type of characteristic of the aes, for example to use a different palette.
- **labeling**. Label, title and legend.
- **theme**. Modify the theme of the plot, the details.


### Our first plot

We are going to use only the three main layers to plot the first figure. The plots are created by adding layers with the symbol `+`.

```{r}
# Filter result table
results_filt <- results %>%
  filter(pvalue < 0.01) %>%
  arrange(desc(abs(log2FoldChange))) %>%
  head(10)

# input the dataset in the function ggplot and add a new layer with +
ggplot(results_filt)+
# Add a geom object (points in that case)
  geom_point(
# use aes() to declare aesthetic
    aes(
# declare x and yaxis
        x = gene,
        y = log2FoldChange
      )
    )

# The code without comments:
ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))
```

![](images/001_starting.png)

As you can see, each gene (`x` axis) have a value of log2FoldChange (`y` axis) and it is represented by points.

The first thing that we are going to do is adding more than one layer. For example, besides points we want a bar.

```{r}
# Just add geom_col and declare aes
ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))+
  geom_col(aes(x = gene, y = log2FoldChange))
```
![](images/002_adding_layers.png)

The plot is exactly the same but now we have two geometric object, points and bars.

**aes()** is not only used for `x` and `y` position. You can map your data with colors, shapes, sizes... For example, if we want to include a text with the name of gene in the `xy` coordinates (in the point) we must use **geom_text()** function:

```{r}
# Just add geom_text and declare aes with label
ggplot(results_filt)+
  geom_point(aes(x = gene, y = log2FoldChange))+
  geom_col(aes(x = gene, y = log2FoldChange))+
  geom_text(aes(x = gene, y = log2FoldChange, label = gene))
```
![](images\003_three_layers.png)

Maybe you are thinking that the code lines are too difficult. This is only the way to understand the process of how operates `ggplot2`. In practical, the common way to declare aes is in the `ggplot` function and you only need to declare once.

```{r}
# Declare aes in ggplot()
ggplot(results_filt, aes(x = gene, y = log2FoldChange, label = gene))+
  geom_point()+
  geom_col()+
  geom_text()
```
![](images\003_three_layers.png)

The figure is exactly the same.

### Starting to customize plot
