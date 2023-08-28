# Omics data analysis (WSBIM2122)

- Course material: https://uclouvain-cbio.github.io/WSBIM2122/

I you wish to build this book locally, you'll need
[bookdown](https://bookdown.org/yihui/bookdown/) and a fork of
[msmbstyle](https://github.com/lgatto/msmbstyle).

```{r combilebook1, eval=FALSE}
install.packages("bookdown")
devtools::install_github("lgatto/msmbstyle")
```

In the course's work directory, simply type

```{r combilebook2, eval=FALSE}
bookdown::render_book(".")
```
