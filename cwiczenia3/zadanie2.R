setwd("/home/student/Repositories/data-mining/cwiczenia3")
library(tidyverse)

df <- read.delim(
    "Series_G.csv",
    header = FALSE,
    col.names = c("Passengers", "Date")
)

print(df)

df$Date <- as.Date(df$Date, "%d.%m.%Y")

df <- df %>% mutate(Month = format())

plot(df$Passengers ~ df$Date, type = "l")

print(df)