# Packages required are loaded 

library(fpp2)
library(ggplot2)
library(car)
library(lmtest)
Data <- read.csv("ARMA_data.csv")

Data.ts <- ts(Data$Score, freq = 1, start = 1824)

plot(Data.ts)
acf(Data.ts)
pacf(Data.ts)

#acf and pacf both cutting off at lag 1 
#fit an AR(1 model)
mod.1 <- Arima(Data.ts, order=c(3,0,0))
#fit an MA(1 model)
mod.2 <- Arima(Data.ts, order=c(0,0,2))
#fit an ARMA(1,1 model)
mod.3 <- Arima(Data.ts, order= c(3,0,2))
#based on the AIC, the AR(1) is the best model
#can check the residuals to assess the models
checkresiduals(mod.1, lag=20)
checkresiduals(mod.2, lag=20)
#both residual plots look stationary in mean 
#both plots have lag activity, seasonality might need to be considered
checkresiduals(mod.3, lag=20)
#trend is similar to other two models, lag is still an issue
#can do a forecast with model we have created 

forecast(mod.2, h=5)

#visualise the forecast
autoplot(Data.ts) + autolayer(forecast(mod.2, h=5)) + ylab("Time Series Data for simulated annual stock exchange") + xlab("Year") +ggtitle("Forecasts from MA(2) with zero mean")
#can see the model is following the original series but its not capturing entire variability of data
#indicating seasonality is present, didn't check for stationarity in mean and variance aswell
#yes model is capturing level of original series very well and doing forecast well as 95% captures entire variability of the data
#longterm forecast would not be ideal. 

