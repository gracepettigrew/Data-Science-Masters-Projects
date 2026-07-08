library(forecast)
library(ggplot2)
library(tseries)
library(fpp2)
library(car)
library(lmtest)
library(fitARMA)
data(AirPassengers)
dat <- AirPassengers

plot(dat)
abline(reg= lm(dat ~ time(dat)))

boxplot(dat~cycle(dat), xlab= "Months", ylab= "Passenger Numbers ('000)", main="Monthly AirPassengers from 1949 to 1961")
dattsDecomp <- decompose(dat, type = "multiplicative")
plot(dattsDecomp)
#box cox log transform the data
boxCox(AirPassengers~ seq(1:length(AirPassengers))
       + factor(rep(1:12, length.out=length(AirPassengers))), lambda = seq(0,1,by=0.01))
boxCox
airpassengersBox <- autoplot(airpassengers.ssa) + xlab("Year") + ylab("Log of Retail Sales") +
  ggtitle(expression(paste("Retail Sales with Box-Cox Transform where ", lambda, "= 0.2")))


adf.test(airpassengers.ssa)
airpassengers.ssa <- BoxCox(AirPassengers, lambda = 0.2)

adf.test(AirPassengers)
adf.test(AirPassengers, alternative = "stationary", k=24)
plot(AirPassengers, main="Air Passenger numbers from 1949 to 1961")
tsdata <- ts(log(AirPassengers), frequency = 12)
plot(tsdata)
Data.diff <- diff(airpassengers.ssa)
par(mfrow=c(1,3))
plot(Data.diff)
acf(Data.diff)
pacf(Data.diff)


Model_1 <- Arima(dat, order=c(2,1,1))
Model_2 <- Arima(dat, order=c(2,1,4))
Model_3 <- Arima(dat, order=c(2,1,8))
Model_4 <- Arima(dat, order=c(2,1,11))
Model_5 <- Arima(dat, order=c(2,1,12))
Model_6 <- Arima(dat, order=c(2,1,13))

#To view the model output use summary()
summary(Model_1)
summary(Model_2)
summary(Model_3)
summary(Model_4)
summary(Model_5)
summary(Model_6)

Model_1 <- Arima(dat, order=c(2,1,1), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_2 <- Arima(dat, order=c(2,1,4), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_3 <- Arima(dat, order=c(2,1,8), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_4 <- Arima(dat, order=c(2,1,11), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_5 <- Arima(dat, order=c(2,1,12), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_6 <- Arima(dat, order=c(2,1,13), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)

#To view the model output use summary()
summary(Model_1)
summary(Model_2)
summary(Model_3)
summary(Model_4)
summary(Model_5)
summary(Model_6)

Model_1 <- Arima(dat, order=c(0,1,1), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_2 <- Arima(dat, order=c(0,1,4), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_3 <- Arima(dat, order=c(0,1,8), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_4 <- Arima(dat, order=c(2,1,11), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_5 <- Arima(dat, order=c(2,1,14), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)
Model_6 <- Arima(dat, order=c(2,1,12), include.mean=TRUE, include.drift=FALSE, lambda = 0.2)

#To view the model output use summary()
summary(Model_1)
summary(Model_2)
summary(Model_3)
summary(Model_4)
summary(Model_5)
summary(Model_6)

#Do your model diagnostic check (compare AICs and choose the model with least AIC). 
#From our example, ARIMA(3,1,1) returned the lowest AIC score, so it is preferred over Model.ar2

checkresiduals(Model_5)

# The residual check produced satisfactory results, so we can ahead and forecast with the model

# At this stage we will re-fit the data
autoplot(dat) + ggtitle("Population of Sheep; 1867 to 1939")+
  xlab("Year") + ylab("Population (thousand)") + autolayer(fitted(Model_6))


# Do 10 forecasting
Data.forecast <- forecast(Model_5,h=3*12)


# plot everything on one panel

autoplot(dat) + ggtitle("AirPassenger Time-Series 1949 to 1961")+
  xlab("Year") + ylab("Number of AirPassengers") + autolayer(fitted(Model_5))+
  autolayer(forecast(Data.forecast)) + theme(legend.position="none")

arimaModel <- auto.arima(dat, d = 1, max.p = 5, max.q = 10)
summary(arimaModel)
forecastarima <- forecast(arimaModel, h=3*12)
autoplot(dat) + ggtitle("AirPassenger Time-Series 1949 to 1961") +
  xlab("Year") + ylab("Number of AirPassengers") + autolayer(fitted(arimaModel)) +
  autolayer(forecast(forecastarima)) + theme(legend.position="none")