library(fpp2)
library(ggplot2)
library(car)
library(gridExtra)
library(forecast)
library(fma)

#splitting the time series into the various components to then forecast 
#using either additive or multiplicative is driven by the shape of the data
#look at the variability or oscillations happening in the dataset
#if it is highly uniform across time, then to decompose the additive is best approach 
#seasonality strong in the data and variability growing with time- decompose then multiplicative will be best approach
#use multiple and then compare, can use performance measures to estimate the observed data
#may have to write own function to generate mse, rmsea etc to do model diagnosis
#to investigate seasonality, you want to check the white noise assumption, that it doesn't contain
#any useful information, perform residual analysis of autocorrelation, normality 
#there is a periodic pattern 



souvenir <- read.csv("souvenir.csv")

souvenir.ts <- ts(log(souvenir$Sales), start= c(1987,1), frequency = 12)

acf(souvenir.ts)

plot(souvenir.ts, xlab = "Year", ylab="Log of Sales")
title("Souvenir Sales from 1987 to 1994")

# estimation of trend via moving average of order 12

trend.souvenir <- na.omit(ma(souvenir.ts, order = 12))

autoplot(souvenir.ts) + 
  autolayer(trend.souvenir) + 
  xlab("Year") + ylab("Log of Sales")+
  ggtitle("Monthly Souvenir Sales from 1987 to 1994")

#detrended data
detrended.souvenir <- souvenir.ts - trend.souvenir
autoplot(detrended.souvenir) + xlab("Year") + ylab("Log of Sales")+
  ggtitle("Monthly Souvenir Sales from 1987 to 1994")

#detrended multplicative data
detrended.souvenirm <- souvenir.ts / trend.souvenir
autoplot(detrended.souvenirm) + xlab("Year") + ylab("Log of Sales")+
  ggtitle("Monthly Souvenir Sales from 1987 to 1994")

# Additive decomposition - is the default method for decompose() function

decompose(souvenir.ts)

#alternatively
autoplot(decompose(souvenir.ts))

#checking the residuals
Box.test(decompose(souvenir.ts)$random, lag=48, fitdf=12, type= "Lj")

shapiro.test(decompose(souvenir.ts)$random)

#seasonally-adjusted data 
adj.souvenir <- decompose(souvenir.ts)$random + decompose(souvenir.ts)$trend
#plot with the original data
autoplot(souvenir.ts) + xlab("Year") + ylab("Log of Sales") +
  ggtitle("Monthly Souvenir Sales from 1987 to 1994") +
  autolayer(adj.souvenir, series = "Seasonally-Adjusted Data")

# Multiplicative decomposition

decompose(souvenir.ts,type="multiplicative")

autoplot(decompose(souvenir.ts,type="multiplicative"))


#checking the residuals
Box.test(decompose(souvenir.ts, type="multiplicative")$random, lag=48, fitdf=12, type= "Lj")

shapiro.test(decompose(souvenir.ts, type="multiplicative")$random)

#seasonally-adjusted data
adj.souvenirts <- decompose(souvenir.ts,type="multiplicative")$random*decompose(souvenir.ts,type="multiplicative")$trend

#plot with the original data
autoplot(souvenir.ts) + xlab("Year") + ylab("Log of Sales") +
  ggtitle("Monthly Souvenir Sales from 1987 to 1994") +
  autolayer(adj.souvenirts, series = "Seasonally-Adjusted Data")

plot1 <- autoplot(adj.souvenirts)
plot2 <- ggAcf(adj.souvenirts, lag.max = 36)
plot3 <- ggAcf(diff(adj.souvenirts), lag.max = 36)

# library(gridExtra)
grid.arrange(plot1, plot2, plot3, ncol = 3)

plot1 <- autoplot(adj.souvenir)
plot2 <- ggAcf(adj.souvenir, lag.max = 36)
plot3 <- ggAcf(diff(adj.souvenir), lag.max = 36)

# library(gridExtra)
grid.arrange(plot1, plot2, plot3, ncol = 3)

# Seasonal naive 

souvenir.fitted <- snaive(adj.souvenir, h =36)

plot(souvenir.fitted)


# Cumulative moving average

souvenir.fitted_2 <- meanf(adj.souvenir, h=36)
plot(souvenir.fitted_2)


# Drift method

souvenir.fitted_3 <- rwf(huron, drift = T, h=36)
plot(souvenir.fitted_3)


# performance measures
accuracy(souvenir.fitted$x, souvenir.fitted$fitted)
accuracy(souvenir.fitted_3$x, souvenir.fitted_3$fitted)

model_holt <- holt(na.omit(adj.souvenir), h = 36)
model_hw_additive <- hw(na.omit(adj.souvenir), seasonal = "additive", h = 36)
model_hw_multiplicative <- hw(na.omit(adj.souvenir), seasonal = "multiplicative", h = 36)

accuracy(model_holt$x, model_holt$fitted)
accuracy(model_hw_additive$x, model_hw_additive$fitted)
accuracy(model_hw_multiplicative$x, model_hw_multiplicative$fitted)

# With a significant spike at lag 1 for the differenced data, we will fit exponential moving average
tcast <- hw(na.omit(adj.souvenir), seasonal = "multiplicative", h =36)
autoplot(tcast) + xlab("Year") + ylab("Log of Sales") +
  ggtitle("Forecast of the seasonally-adjusted Souvenir sales") +
  guides(colour=guide_legend(title="Forecast"))

# Let's fit seasonal naive for the seasonal component
scast <- snaive(window(decompose(souvenir.ts,type="additive")$seasonal,end=c(1994,1)-.5),h=36)
autoplot(scast) + xlab("Year") + ylab("Log of Sales") +
  ggtitle("Forecast of seasonal component of Souvenir Sales")

# Note that the seasonal component will be calcualted until the end of the dataset when the forecast package is loaded. 
# Hence, half a period is needs to be removed from the end of the dataset

# Combined forecast is obtained as
fcast <- tcast$mean + scast$mean


autoplot(souvenir.ts) + 
  xlab("Year") + ylab("Log of Sales") +
  autolayer(fcast , color="blue" , series = "Forecast") +
  ggtitle("Forecast of Souvenir Sales for the next 24 months")