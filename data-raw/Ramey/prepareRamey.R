

setwd("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/Ramey")

Ramey <- read.csv("Ramey2.csv")

save(Ramey,file="../../data/Ramey.rda")
