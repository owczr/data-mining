setwd("/home/student/Repositories/data-mining/cwiczenia1")
df = read.csv("Real_estate.csv")

str(df)

cor_matrixp = round(cor(df[2:8]), 2)
#cor_matrixs = round(cor(df[1:8]), 2)

#par(mfrow=c(1,2))
corr_p = corrplot(cor_matrixp)
#corr_s = corrplot(cor_matrixs)

par(mfrow=c(2, 3))
hist(df$X1.transaction.date)
hist(df$X2.house.age)
hist(df$X3.distance.to.the.nearest.MRT.station)
hist(df$X4.number.of.convenience.stores)
hist(df$X5.latitude)
hist(df$X6.longitude)

par(mfrow=c(2, 3))
plot(df$Y.house.price.of.unit.area~df$X1.transaction.date)
plot(df$Y.house.price.of.unit.area~df$X2.house.age)
plot(df$Y.house.price.of.unit.area~df$X3.distance.to.the.nearest.MRT.station)
plot(df$Y.house.price.of.unit.area~df$X4.number.of.convenience.stores)
plot(df$Y.house.price.of.unit.area~df$X5.latitude)
plot(df$Y.house.price.of.unit.area~df$X6.longitude)

par(mfrow=c(2, 3))
boxplot(df$X1.transaction.date)
boxplot(df$X2.house.age)
boxplot(df$X3.distance.to.the.nearest.MRT.station)
boxplot(df$X4.number.of.convenience.stores)
boxplot(df$X5.latitude)
boxplot(df$X6.longitude)


