setwd("/home/student/Repositories/data-mining/cwiczenia4/")
library(zoo)

AirPassengers <- as.data.frame(AirPassengers)

AP <- ts(AirPassengers, start = c(1949,1), frequency = 12) # doesn't work with freq = 1
dAP <- decompose(AP, type = "multiplicative")
dAP_trend <- dAP$trend

dAP_trend

# autoplot(as.zoo(AP), geom = "line") +
  # geom_line(aes(x = time(dAP_trend), y = dAP_trend), color = "green")

air_pass<-read.delim("Series_G.csv", header=FALSE, col.names=c('Passengers', 'Date'))
air_pass
str(air_pass)
air_pass$Date <- as.Date(air_pass$Date, format = "%d.%m.%Y")

plot(air_pass$Passengers~air_pass$Date, type='l')

acf(air_pass$Passengers, na.action = na.pass)
pacf(air_pass$Passengers, na.action = na.pass)

install.packages("tidyverse")
library(tidyverse)
air_pass$Year <- format(air_pass$Date, "%Y")
air_pass <- air_pass %>%
  mutate(IsNewYear=ifelse(format(air_pass$Date, "%m") == "01" , 1, 0))
air_pass <- air_pass %>%
  mutate(IsSummer=ifelse(format(air_pass$Date, "%m") == "06"|format(air_pass$Date, "%m") == "07"|format(air_pass$Date, "%m") == "08"|format(air_pass$Date, "%m") == "09" , 1, 0))