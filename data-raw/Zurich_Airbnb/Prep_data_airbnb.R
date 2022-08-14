

setwd("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/Zurich_Airbnb")

airbnb <- read.csv("tomslee_airbnb_zurich_1363_2017-06-22.csv")

airbnb <- subset(airbnb,(price<500)&(room_type=="Entire home/apt"))

eq <- lm(price~bedrooms+accommodates+log(1+reviews)+neighborhood,data=airbnb)
eq <- lm(price~bedrooms+accommodates,
         data=airbnb)
summary(eq)
#FILE = paste("/Figures/Figure_airbnb1.pdf",sep="")
#pdf(file=paste(getwd(),FILE,sep=""),pointsize=3,width=4, height=4)

eq <- lm(price~bedrooms+accommodates+neighborhood,
         data=airbnb)
summary(eq)

save(airbnb,file="../../data/airbnb.rda")

for(i in 1:dim(airbnb)[1]){
  points(airbnb$longitude[i],airbnb$latitude[i],pch=1,cex=(airbnb$price[i]/200))
}

# # compute distances between locations:
# n <- dim(airbnb)[1]
# Dist <- matrix(NaN,n,n)
# for(i in 1:n){
#   for(j in 1:i){
#     dx <- airbnb$longitude[i] - airbnb$longitude[j]
#     dy <- airbnb$latitude[i] - airbnb$latitude[j]
#     Dist[i,j] <-sqrt(dx^2 + dy^2)
#   }
# }
# prod_resid <- matrix(eq$residuals,n,n) * t(matrix(eq$residuals,n,n))
# plot(c(Dist),c(prod_resid))

