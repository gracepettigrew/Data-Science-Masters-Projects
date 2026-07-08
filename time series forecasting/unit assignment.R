#Time Series Assignment 
#Name: Grace Pettigrew
#Created in May 2024
#Used apple stock data available from Kaggle (Apple stock Price till 2023 December)
#Looked at an ARIMA Model and a model using Facebook Prophet to forecast stock prices
library(dplyr)
library(zoo)
library(forecast)
library(fpp)
library(ggplot2)
library(tseries)
library(parallel)
library(prophet)
#set your working directory and load the dataset
dat <- read.csv("apple_stock.csv")
View(dat)
#------Data cleaning and exploratory analysis---------------
head(dat)
#get a summary of the data
summary(dat)

#check for missing values
sum(is.na(dat))
#convert the date columne to date format
dat$Date <- as.Date(dat$Date, format= "%Y-%m-%d")

#plot the adjusted closing prices over tiem
ggplot(dat, aes(x = Date, y = Adj.Close)) +
  geom_line(color = "blue") +
  labs(title = "Closing Prices over time", x= "Date", y= "Adjusted Closing Price")

#Plot boxplots of adjusted closing prices by year
dat$Year <- as.factor(format(dat$Date, "%Y"))
ggplot(dat, aes(x = Year, y = Close)) +
  geom_boxplot() +
  labs(title = "Boxplot of Closing Prices by Year", x = "Year", y = "Closing Price")  

#------Convert the data to a time series object-------------
#extract the starting day of the first observation
start_date <- c(2014, 2)

# use ts() function to convert data into a time series
#frequency is 252 as that's the amount of trading days in a year
data.ts <- ts(dat$Adj.Close, frequency = 252, start = start_date)

#plot the time series date
autoplot(data.ts) +
  labs(title = "Adjusted Closing Price of Apple Stock from 2014-2023", x = "Date", y = "Adjusted Closing Stock Price")

#decompose the time series 
decompose_ts <- decompose(data.ts, type = "multiplicative")
plot(decompose_ts)


#log transform the data before differencing
lambda <- BoxCox.lambda(data.ts)
log.ts <- BoxCox(data.ts, lambda)
autoplot(log.ts) +
  labs(title = "BoxCox of Apple Adjusted Closing Price", x = "Year", y = "BoxCox Adjusted Closing Price")

#------Analyse the time series data------------
#check for stationarity through adf test
adf.test(log.ts)

#difference the log transformed data and perform adf test again
Data.diff <- diff(log.ts)
plot(Data.diff)
adf.test(Data.diff)

#plot the acf and pacf plots
par(mfrow=c(1,2))
acf(Data.diff, lag.max = 35)
pacf(Data.diff, lag.max = 35)

#based on acf plot cutting off at lag 1 and 1 and pacf plot cutting off at lag 1 a suggested model of AR(1), MA(1)
#but to evaluate all model choices we can perform a neighbourhood search to determine the best model
#create a for loop to run a neighbourhood search to determine the best ARIMA model
#we will set the paramters for p, q as 0:3 and d=1 as there was only one differencing performed
#the code for this function was created with the help of chatgpt software 
results <- data.frame(p = integer(), d = integer(), q = integer(), AIC = numeric(), BIC = numeric(), AICc = numeric())
models <- list()

# Custom AICc function
AICc <- function(fit) {
  n <- length(fit$residuals)
  k <- length(fit$coef) + 1
  aic <- AIC(fit)
  return(aic + (2 * k * (k + 1)) / (n - k - 1))
}
# Perform the neighborhood search
for (p in 0:3) {
  for (q in 0:3) {
    d <- 1
    order <- c(p, d, q)
    fit <- tryCatch({
      arima(log.ts, order = order)
    }, error = function(e) {
      return(NULL)
    })
    
    if (!is.null(fit)) {
      current_aic <- AIC(fit)
      current_bic <- BIC(fit)
      current_aicc <- AICc(fit)
      results <- rbind(results, data.frame(p = p, d = d, q = q, AIC = current_aic, BIC = current_bic, AICc = current_aicc))
      models[[paste(p, d, q, sep = ",")]] <- fit
    }
  }
}

# Add rank columns for each metric
results$AIC_rank <- rank(results$AIC)
results$BIC_rank <- rank(results$BIC)
results$AICc_rank <- rank(results$AICc)

# Calculate combined rank
results$combined_rank <- results$AIC_rank + results$BIC_rank + results$AICc_rank

# Sort results by combined rank and keep the top 10 models
results <- results[order(results$combined_rank), ]
top10results <- head(results, 10)

# Display the top 10 models' summary
for (i in 1:nrow(top10results)) {
  order_str <- paste(top10results$p[i], top10results$d[i], top10results$q[i], sep = ",")
  cat("\nModel Order (p,d,q):", order_str, "\n")
  print(summary(models[[order_str]]))
  cat("\nAIC:", top10results$AIC[i])
  cat("\nBIC:", top10results$BIC[i])
  cat("\nAICc:", top10results$AICc[i], "\n")
}

# Display the top 10 results data frame
print(top10results)

Model_1 <- Arima(data.ts, order=c(1,1,0), include.mean=TRUE, include.drift=FALSE, lambda= lambda)
summary(Model_1)
checkresiduals(Model_1, lag.max = 20)
#-----Re-fit and forecast the model on the original time series------
# At this stage we will re-fit the data
autoplot(data.ts) + ggtitle("Apple adjsuted stock closing prices from 2014 to 2023")+
  xlab("Year") + ylab("Adjusted Closing Price") + autolayer(fitted(Model_1))+autolayer(fitted(Model_1))

#Do forecast for the next 3years
#252trade days * 3 being 756
Data.forecast <- forecast(Model_1, h=756)

# Plot the original data with forecasts
autoplot(data.ts) + ggtitle("3year Forecast of Apple Stock Prices")+
  xlab("Year") + ylab("Adjusted Closing Prices") + autolayer(fitted(Model_1))+
  autolayer(forecast(Data.forecast)) + theme(legend.position="none")

#----Fitting a prophet model to the time series data-------
# Prepare the data for Prophet
data_prophet <- dat %>%
  select(Date, Adj.Close) %>%
  rename(ds = Date, y = Adj.Close) %>%
  mutate(ds = as.Date(ds))

# Fit the Prophet model
m <- prophet(data_prophet, daily.seasonality=TRUE)

# Make a future dataframe
future <- make_future_dataframe(m, periods = 1095)

# Forecast
forecast <- predict(m, future)

# Ensure the ds column in forecast is of Date class
forecast$ds <- as.Date(forecast$ds)
# Plot the forecast
plot(m, forecast) +
  add_changepoints_to_plot(m)
prophet_plot_components(m, forecast)

# Plot actual vs predicted with prediction intervals
ggplot() +
  geom_line(data = data_prophet, aes(x = ds, y = y), color = 'blue', linewidth = 1, alpha = 0.6) +
  geom_line(data = forecast, aes(x = ds, y = yhat), color = 'red', linewidth = 1, alpha = 0.8) +
  geom_ribbon(data = forecast, aes(x = ds, ymin = yhat_lower, ymax = yhat_upper), fill = 'grey', alpha = 0.4) +
  labs(title = 'Actual vs Predicted with Prediction Intervals',
       x = 'Date',
       y = 'Adjusted Close Price') +
  theme_minimal()

#evaluate the model based on mae and rmse 
df_cv <- cross_validation(m, initial = 2475, period = 365.25, horizon = 1095, units = 'days')
df_p <- performance_metrics(df_cv)

cat("Mean Absolute Error (MAE):", df_p$mae[1], "\n")
cat("Root Mean Squared Error (RMSE):", df_p$rmse[1], "\n")

head(df_cv)
head(df_p)
