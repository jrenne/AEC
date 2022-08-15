

setwd("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/Zurich_Airbnb")

airbnb <- read.csv("tomslee_airbnb_zurich_1363_2017-06-22.csv")

airbnb <- subset(airbnb,(price<300)&(room_type=="Entire home/apt"))

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

library(rgdal)
library(AEC)
par(mar=c(0,0,0,0))
plot(zurich_districts,col="light gray",border="white",lwd=3)
for(i in 1:dim(airbnb)[1]){
  points(airbnb$longitude[i],airbnb$latitude[i],pch=1,cex=(airbnb$price[i]/200))
}

# compute distances between locations:
n <- dim(airbnb)[1]
Dist <- matrix(NaN,n,n)
dx <- matrix(airbnb$longitude,n,n) - t(matrix(airbnb$longitude,n,n))
dy <- matrix(airbnb$latitude,n,n) - t(matrix(airbnb$latitude,n,n))
Dist <- sqrt(dx^2+dy^2)
x <- Dist[lower.tri(Dist)]
prod_resid <- matrix(eq$residuals,n,n) * t(matrix(eq$residuals,n,n))
y <- prod_resid[lower.tri(prod_resid)]

N <- 100000
par(plt=c(.1,.9,.1,.9))
plot(x[1:N],y[1:N])

summary(lm(y~I(1/(.001+x))))

eqCov <- nls(y ~ a/(.001 + b*x)+c,#algorithm = "plinear",
             start = list(a = .24,b=1,c=-13))
summary(eqCov)

stop()

for(i in 1:n){
  for(j in 1:i){
    dx <- airbnb$longitude[i] - airbnb$longitude[j]
    dy <- airbnb$latitude[i] - airbnb$latitude[j]
    Dist[i,j] <-sqrt(dx^2 + dy^2)
  }
}
prod_resid <- matrix(eq$residuals,n,n) * t(matrix(eq$residuals,n,n))
plot(c(Dist),c(prod_resid))

