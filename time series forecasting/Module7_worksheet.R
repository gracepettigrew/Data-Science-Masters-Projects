# Packages required are loaded 

library(fpp2)
library(ggplot2)
library(car)
library(lmtest)
library(forecast)
library(car)
library(gridExtra)

#import data
sales <- read.csv ("Sales.csv")

#convert the sales data to a timeseries
sales <- ts(sales$Sales, start= c(1992,1), frequency = 12)
plot(sales, xlab = "Year", ylab="Retail Sales")
title("Retail Sales from 1992 to 2023")
#log transfomr the sales data 
sales.ts <- ts(log(sales$Sales), start= c(1992,1), frequency = 12)

acf(sales.ts)

plot(sales.ts, xlab = "Year", ylab="Log of Retail Sales")
title("Retail Sales from 1992 to 2023")

shapiro.test(decompose(sales.ts,type="multiplicative")$random)


# Fitting seasonal models - using trigonometric function (via fourier function)

ln.AP <- ts(log(sales$Sales), freq =12, start = c(1992,1))
plot(log(sales.ts))
AP.reg1 <- tslm(ln.AP ~ trend + fourier(ln.AP, K=1)) #fourier function is function of sine/cosine to introduce oscillating behaviour
#k= number of oscillations in the period
summary(AP.reg1)

# Argument K controls the frequency of oscillation in the fourier function

AP.reg2 <- tslm(ln.AP ~ trend + fourier(ln.AP, K=2))
summary(AP.reg2)

AP.reg3 <- tslm(ln.AP ~ trend + fourier(ln.AP, K=3))
summary(AP.reg3)
anova(AP.reg2, AP.reg3) #compare which model is best as models are nested

dwtest(AP.reg3)
# Forecast the next two year data

t <- length(ln.AP) + seq(24)
S <- fourier(ts(t,freq=12),K=3)
new.data <- data.frame(cbind(trend = t,S))
fcast.AP <- forecast(AP.reg3 , new.data)
summary(fcast.AP)


autoplot(ln.AP) + xlab("Year") + autolayer(fitted(AP.reg3)) +
  autolayer(forecast(fcast.AP)) + theme(legend.position = "none") +
  ggtitle("Forecast of Retail Sales Data for the next 24months")

# To get the bias corrected back-adjustment, we can use the fact that the Box-Cox transform is the natural log when lambda =0

AP.reg <- tslm(sales ~ trend + fourier(sales,K=3) , lambda=0)

t <- length(ln.AP) + seq(24)
S <- fourier(ts(t,freq=12),K=3)
new.data <- data.frame(cbind(trend = t,S))
fcast.AP <- forecast(AP.reg , new.data, lambda=0, biasadj=TRUE)
summary(fcast.AP)

autoplot(sales) + xlab("Year") + ylab("Sales") +
  autolayer(forecast(fcast.AP)) +
  ggtitle("Forecast of Retail Sales Data after performing bias corrected 
          back-adjustment")


# Modelling seasonality using dummy variables
#choose the lambda using boxcox function to find optimal lambda value for the series
#0 lambda=natural log
#box cox log transform the data
boxCox(sales~ seq(1:length(sales))
       + factor(rep(1:12, length.out=length(sales))), lambda = seq(0,1,by=0.01))

#from box cox lambda= 0.8 is ideal
Sales.ssa <- BoxCox(sales, lambda = 0.1)
autoplot(Sales.ssa) + xlab("Year") + ylab("Log of Retail Sales") +
  ggtitle(expression(paste("Retail Sales with Box-Cox Transform where ", lambda, "= 0.1")))
Sales.ssa


AP.reg4 <- tslm(sales~ trend + season,lambda=0.1)
summary(AP.reg4)


t <- length(ln.AP) + seq(24)
new.data <- data.frame(trend = t)
fcast.AP.1 <- forecast(AP.reg4 , new.data, lambda=0.1, biasadj=TRUE)
summary(fcast.AP.1)

autoplot(sales) + xlab("Year") + ylab("Sales") + autolayer(forecast(fcast.AP.1)) +
  ggtitle("Forecast of Retail Sales Data after performing bias corrected 
          back-adjustment")
autoplot(ln.AP) + xlab("Year") + autolayer(fitted(AP.reg4)) +
  autolayer(forecast(fcast.AP.1)) + theme(legend.position = "none") +
  ggtitle("Forecast of Retail Sales Data for the next 24months")
