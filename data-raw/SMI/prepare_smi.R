


setwd("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/SMI")

smi <- read.csv("SMI.csv")

save(smi,file="../../data/smi.rda")
