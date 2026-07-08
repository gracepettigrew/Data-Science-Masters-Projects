#Module 3 Autocorrelation Tutorial 
#only dealing with one variable, time is an important predictor 
#data is chronologically collected 
#autocorrelation is a single variable correlating to itself 
library(TSSS)
data1 <- data("MYE1F")
x11()
plot(MYE1F)

acf(MYE1F)
pacf(MYE1F)

install.packages("fpp2")
library(fpp2)

ausbeer <- fpp2::ausbeer
plot(ausbeer)