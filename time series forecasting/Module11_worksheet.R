# Seasonal ARIMA(p,d,q)(P,D,Q)[m]
# set your working directory 
#load your packages using the library() function
install.packages("fitAR")
library(forecast)
library(fpp)
library(ggplot2)

# load your csv file- using the monthly mild production data on BB 
Data_demo <- read.csv("Sales.csv")

# use ts() function to convert data into a time series
Data_ts <- ts(Data_demo$Sales, frequency = 12,start=1992)

#plot time series using plot()
plot(Data_ts)

# To remove the trend we have to difference the time series (d=1)
Data_diff <- diff(Data_ts)

# Plot to check stability in the trend
plot(Data_diff)

# Since seasonality is strong in the differenced data, we have to perform seasonal 
# differencing as well (D=1)
#lag is 12 because the time series is in months 
#cyclicity isn't uniform, can last for however long but in seasonality
#the same pattern is repeating each year 
Data_season_diff <- diff(Data_diff, lag=12)

# Plot the seasonal differenced data to check stationarity
#looking like white noise now, quite random and highly unpredictable 
plot(Data_season_diff)
adf.test(Data_season_diff)
# To determine the order of the seasonal and non-seasonal parts of our model,
# we will investigate the acf and pacf of the seasonally-differenced data

# To display acf and pacf side-by-side, you can use par() function
par(mfrow=c(1,2))
acf(Data_season_diff, lag=100)
pacf(Data_season_diff, lag=100)

# Firstly, observe the non-seasonal behaviour of acf and pacf
# It can be observed that both acf and pacf cut off after lag 2, therefore we will
# fit AR(p = 2) and MA(q = 2) and compare AIC.
# Secondly, observe the seasonal behaviour of acf and pacf
# It can be observed that acf cuts off after lag 2 (referring lag 12 because the seasonal
# index, m =12), whilst pacf decays geometrically. This implies that a seasonal MA(Q=1)
# will be appropriate
# Note that we have differenced the data at the ordinary (d=1) and seasonal (D=1) levels. 
# Combining the seasonal and non-seasonal parts results in the following candidate of models.
# 1. If we consider MA(2) for the non-seasonal part, we will get SARIMA(0,1,2)(0,1,1)[12]
# 2. If we consider AR(2) for the non-seasonal part, we will get SARIMA(2,1,0)(0,1,1)[12]

# To fit each of the model, use the Arima() function
Model_1 <- Arima(Data_ts, order = c(0,1,1),seasonal = c(0,1,1))
Model_2 <- Arima(Data_ts, order = c(1,1,0),seasonal = c(0,1,1))
Model_3 <- Arima(Data_ts, order = c(1,1,1), seasonal = c(0,1,1))
Model_4 <- Arima(Data_ts, order = c(1,1,2), seasonal = c(0,1,1))
Model_5 <- Arima(Data_ts, order = c(1,1,3),seasonal = c(0,1,1))
Model_6 <- Arima(Data_ts, order = c(1,1,4),seasonal = c(0,1,1))
Model_7 <- Arima(Data_ts, order = c(2,1,1), seasonal = c(0,1,1))
Model_8 <- Arima(Data_ts, order = c(2,1,2), seasonal = c(0,1,1))
Model_9 <- Arima(Data_ts, order = c(3,1,1),seasonal = c(0,1,1))
Model_10 <- Arima(Data_ts, order = c(4,1,1),seasonal = c(0,1,1))

# Use the summary() function to examine model output
summary(Model_1)
summary(Model_2)
summary(Model_3)
summary(Model_4)
summary(Model_5)
summary(Model_6)
summary(Model_7)
summary(Model_8)
summary(Model_9)
summary(Model_10)

checkresiduals(Model_6)
# Model_2 return marginally small AIC, AICc and BIC scores, therefore it is
# preferred over Model_1. So our choice of model for the milk production data
# is SARIMA(1,1,0)(0,1,1)[12]
#two models are almost identical 
#compare at least 10 neighbouring models before making final determination
#can write a forloop to do that 
#set initials values and write for loop to use various combinations of them
#can set a bound so up to 3 for lower case p,q and P, Q
#for each of the order parameters that would be okay 
#fit the model, look at the AIC, AICc and BIC 

# Check residuals
#you can see theres no autocorrelation in the ACF plot
#the residuals are centred around zeor
#the variability is uniform over time (top plot)
#normality looks reasonable for the residuals and are well behaved
#model is adequate 
summary(Model_3)
checkresiduals(Model_3)

# Here we visualise the fitted and forecast made with our preferred model
#the model is doing reasonably well for forecasting 
#forecast is very good 


autoplot(Data_ts)+ggtitle("Forecast of Sales for the next 3 years")+
  xlab("Year") + ylab("Sales") + autolayer(fitted(Model_6))+
  autolayer(forecast(Model_6,h=36))
# And it all ended in a smile.
