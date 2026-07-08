#install package MASS
install.packages("MASS")
library(MASS)
library(fpp2)
library(fma)
library(forecast)
library(ggplot2)

mydata <- EuStockMarkets[,1]
str(mydata)
# Naive method 1

# plot the time series plot and autocorrelation function
plot(mydata)

acf(mydata)

# implement naive estimation in R via naive() function in the forecast package to forecast 12 time points in the future

mydata.fitted <- naive(mydata, h=20)

mydata.fitted

plot(mydata.fitted)

# plot of the estimated series overlayed on the observed series and the 12 future points forecast
autoplot (mydata,series="Huron Data") +
  autolayer (fitted(mydata.fitted),series="Naive Estimate")+ 
  autolayer (forecast (mydata.fitted),series="Forecast",PI=F) +
  xlab("Year") + ylab("Water Level (Feet)")

autoplot (mydata,series="Huron Data") +
  autolayer (fitted(mydata.fitted),series="Naive Estimate")+ 
  autolayer (forecast (mydata.fitted),series="Forecast",PI=T) +
  xlab("Year") + ylab("Water Level (Feet)")


# Naive method 2

naive2<- function (x, h=20) {if (requireNamespace ("forecast", quietly = TRUE)) {
  fc <- forecast::Arima(x,order=c(0,2,0))
  fm <- forecast::forecast (fc,h)
  
  return(fm)
} else {
  stop("Package \"forecast\" needed for this function to work. Please install it.", call. = FALSE)    
}
}

# difference the data to make it stationary. This is required because naive 2 will be fitted as an Arima model, which requires
# stationarity condition. We will discuss Arima in detail later in the semester

mydata.diff <- diff(mydata, differences = 2)
plot(mydata.diff)

acf(mydata.diff)

mydata.fitted_1 <- naive2(mydata, h =20)
mydata.fitted_1

autoplot (mydata,series="Huron Data") +
  autolayer (fitted(mydata.fitted_1),series="Naive 2 Estimate")+ 
  autolayer (forecast (mydata.fitted_1),series="Naive 2 Forecast",PI=F) +
  autolayer (fitted(mydata.fitted),series="Naive 1 Estimate")+ 
  autolayer (forecast (mydata.fitted),series="Naive 1 Forecast",PI=F)+
  xlab("Year") + ylab("Water Level (Feet)")


# Seasonal naive 

mydata <- forecast::mydataind
plot(mydata)

mydata.fitted <- snaive(mydata, h =36)

plot(mydata.fitted)


# Cumulative moving average

mydata.fitted_2 <- meanf(mydata, h=20)
plot(mydata.fitted_2)


# Drift method

mydata.fitted_3 <- rwf(mydata, drift = T, h=20)
plot(mydata.fitted_3)


# performance measures
accuracy(mydata.fitted$x, mydata.fitted$fitted)
accuracy(mydata.fitted_3$x, mydata.fitted_3$fitted)
# Cross-validation 80/20 split

# Comparing with competing models (here we compare exponential moving average, cumulative 
# mean model and drift method)

# Determine the total number of observations in the data
total_obs <- length(mydata)

# Calculate the index to split the data into 80/20
split_index <- ceiling(0.8 * total_obs)

# Print the split index (optional)
print(split_index)


#split data into training and testing sets
train.data <- window(mydata, end=1997)
test.data <- window(mydata, start=1997)

# Fit models using the training data
model_1 <- naive(train.data, h = 20, initial = "simple")
model_2 <- meanf(train.data, h = 20)
model_3 <- rwf(train.data, drift = TRUE, h = 20)

# Plotting forecasts
autoplot(mydata) +
  autolayer(forecast(model_1), series = "Naive method", PI = TRUE) + 
  autolayer(forecast(model_2), series = "Cumulative Mean", PI = TRUE) +
  autolayer(forecast(model_3), series = "Drift method", PI = TRUE) +
  xlab("Year") + ylab("Stock Market Changes(%)") +
  ggtitle("Forecast Comparison of Daily Stock Market Changes in Germany") +
  guides(colour = guide_legend(title = "Forecast"))

# Assess accuracy of the naive model
accuracy(model_1, test.data)
accuracy(model_2, test.data) #cumulative mean
accuracy(model_3, test.data) #drift
#look at RMSE, MAE, MAPE
#create a table for this in worksheet, then choose the best, naive slightly better
#all models are wrong but some of them are useful

# Generate forecast objects with prediction intervals
forecast_model_1 <- forecast(model_1, h = 20, PI = TRUE)
forecast_model_2 <- forecast(model_2, h = 20, PI = TRUE)
forecast_model_3 <- forecast(model_3, h = 20, PI = TRUE)

mydata.fitted_3 <- rwf(mydata, drift = T, h=20, PI = TRUE)
plot(mydata.fitted_3, main = "Forecasted Values with Drift Model", xlab = "Year", ylab = "Stock Market Changes(%)")
