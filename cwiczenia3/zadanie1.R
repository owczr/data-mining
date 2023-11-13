library(liver)
library(MLmetrics)
data("cereal")

# train <- cereal[-c(5, 15, 25, 35, 55), ]
# test <- cereal[c(5, 15, 25, 35, 55), ]

sets <- sample(1:nrow(cereal), 0.9 * nrow(cereal))
train <- cereal[sets, ]
test <-  cereal[-sets, ]

m1 <- lm(rating ~ sugars, train)
summary(m1)

aic_m1 <- AIC(m1)
bic_m1 <- BIC(m1)

hist(m1$residuals)

pred_m1 <- predict(m1, newdata=test)

mape_m1 <- MAPE(pred_m1, test$rating)

print(mape_m1)

#%%
