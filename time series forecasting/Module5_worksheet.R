# Packages required are loaded

library(fpp2)
library(forecast)
library(ggplot2)
library(fma)


#hw is holt winter 
# Exponential moving average models

souvenir <- read.csv("souvenir.csv")

souvenir.ts <- ts(log(souvenir$Sales), start= c(1987,1), frequency = 12)


#split data into training and testing sets
train.data <- window(souvenir.ts, end=c(1992,12))
test.data <- window(souvenir.ts, start=1993)

# Fit models using the training data
model_snaive <- snaive(train.data, h = 12)
model_holt <- holt(train.data, h = 12)
model_hw_additive <- hw(train.data, seasonal = "additive", h = 12)
model_hw_multiplicative <- hw(train.data, seasonal = "multiplicative", h = 12)

accuracy(model_snaive, test.data) #seasonal naive
accuracy(model_holt, test.data) #holt
accuracy(model_hw_additive, test.data) #holt winter
accuracy(model_hw_multiplicative, test.data) #holt winter multiplicative


autoplot (souvenir.ts) +
  autolayer (forecast(model_snaive),series="Seasonal Naive", PI=F)+ 
  autolayer (forecast (model_holt),series="Holt",PI=F) +
  autolayer (forecast (model_hw_additive),series="Holt Winter Additive",PI=F)+
  autolayer (forecast (model_hw_multiplicative), series = "Holt Winter Multiplicative",PI=F)+
  xlab("Year") + ylab("Log of Sales") +
  ggtitle("Percentatge of Men with a full Beard") +
  guides(colour=guide_legend(title="Forecast"))

# check the residuals
checkresiduals(model_hw_multiplicative)

# check that the residiuals are centered around zero
t.test(residuals(model_hw_multiplicative))

# check normality of the residuals
shapiro.test(residuals(model_hw_multiplicative))
qqnorm(residuals(model_hw_multiplicative))
qqline(residuals(model_hw_multiplicative))

plot(model_hw_multiplicative, xlab= "Year", ylab = "Log(Sales)")


autoplot(souvenir.ts) +
  autolayer (forecast(model_hw_multiplicative), series = "Holt Winter Multiplicative", PI=F)+
  xlab("Year") + ylab("Log of Sales") +
  ggtitle("Forecasts from Holt-Winters' Multiplicative Method") +
  guides(colour=guide_legend(title="Forecast"))