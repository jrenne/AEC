
data <- read.csv("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/Mortality/mortality_and_GDP.csv")


x <- log(data$GDP)
y <- data$IMR

eq <- lm(y ~ x)

plot(x,y,pch=19)
abline(eq,col="red")

summary(eq)


