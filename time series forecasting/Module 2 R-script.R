
# Set your working directory 

# Objectives of time series analysis; 
# a) description - effectively express and visualise the characteristics (features) of the time series
# b) modeling - effectively capture the stochastic structure of the series by identifying an appropriate model
# c) prediction - to estimate the future behaviour of the time series by using information extracted from current and past observations
# d) signal extraction - extracting essential signals or useful information from time series corresponding to the objective of the analysis.
install.packages("TSSS")
library(TSSS)
# Load data into R

alcohol <- read.csv("alcohol-by-volume.csv")

# The data frame has four columns of variables.You can select targeted variable via subsetting.
# Your data frame must be converted in a time series object using the ts() function

beer.volume <- ts(alcohol$Beer, start=1944)

# The time series can then be visualised as follows. 
# Note that if you want to open a separate window for the plot you can use X11()

plot(beer.volume)

# Plotting multiple series on the single panel

wine.volume <- ts(na.omit(alcohol$Wine), start = 1960)
spirit.volume <- ts(na.omit(alcohol$Spirits), start = 1960)
cider.volume <- ts(na.omit(alcohol$Cider), start = 2004)

# We can use the ts.plot() function, and colour code the series for easy identification

ts.plot(beer.volume,wine.volume,spirit.volume,cider.volume,
        col =c("green", "red", "purple", "blue"))
#Wine is having an increase in growth over time
#spirits are increasing but gradient is not as steep as other alcohols
# Add legend to guide interpretation

legend("topleft", c("Beer","Wine","Spirits", "Cider"),
       col =c("green", "red", "purple", "blue"), lty = 1)


# Data sampled with frequency

CPI <- read.csv("CPI-change.csv")

# Data frame has 9 variables, let's focus on the series for Australia. It is a quarterly data so the frequency will be 4.

CPI.aus <- ts(CPI$Australia, frequency = 4, start = 1949)

# plot the time series and add lines to highlight 
plot(CPI.aus)
abline(a=3, b=0, lty=2, col="red")
abline(a=2, b=0, lty=2, col="red")

#irregular time series pattern, long term cyclical? not seasonality

# Time series decompositionhttp://127.0.0.1:25539/graphics/plot_zoom_png?width=1200&height=900

# There are several time series data sets in R. If you want to view the full list use the line of code below
#http://127.0.0.1:25539/graphics/plot_zoom_png?width=1200&height=900
library(help="datasets")
plot(sunspot.year)
data(WHARD)
plot(WHARD)

season(WHARD, trend.order = 2, seasonal.order = 1, ar.order = 0, trade = TRUE,
       log = TRUE)

data(HAKUSAN)
plot(HAKUSAN)
data(BLSALLFOOD)
plot(BLSALLFOOD)
season(BLSALLFOOD, trend.order = 2, seasonal.order = 1, ar.order = 0, trade = TRUE,
       log = TRUE)

data("MYE1F")
plot(MYE1F)
# Let's use the 'Airpassenger' data set for this illustration

plot(AirPassengers)

#looking at monthly air travel, the features are increasing trends, strong seasonality- regular, repetitive structure over time
#the variance in the time series is increasing with time, it funnels out, as you move along the oscillation gets wider 

# Discuss the key features of the series

# Now let's decompose the series into the various components (trend+cycle, season, irregular). We will use the decompose()
# function

plot(decompose(AirPassengers))

#first panel is observed data, #second panel isolates the trend

# Decomposition may be done additively or multiplicatively We will discuss this in details in Module 6. The default is additive

plot(decompose(AirPassengers, type = "multiplicative"))
