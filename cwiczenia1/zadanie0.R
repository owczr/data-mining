library(liver)
library(corrplot)

data("cereal")

str(cereal)

plot(cereal$rating)

hist(cereal$rating)

boxplot(cereal$rating)

boxplot(cereal$rating~cereal$type)

boxplot(cereal$rating~cereal$manuf)

cor_matrixp = round(cor(cereal[4:16]), 2)

cor_matrixs = round(cor(cereal[4:16]), 2)

par(mfrow=c(1,2))
corr_p = corrplot(cor_matrixp)
corr_s = corrplot(cor_matrixs)

train = cereal[-c(5, 15, 25, 35, 55),]
test = cereal[c(5, 15, 25, 35, 55),]

