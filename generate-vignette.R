# božstva CRAN-u žádají oběti...

library(knitr)
system("rm ./vignettes/*")
knit("./vignette.Rmd.orig",
     output = "./vignettes/vignette.Rmd")

