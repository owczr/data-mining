library(ggplot2)
set.seed(12)
x <- rnorm(2000)
noise <- rnorm(2000, sd = 3)
y <- 3 * sin(5 * x) + cos(2 * x) - 0.8 * (x ^ 2 ) + noise
select <- runif(2000)
d <- data.frame(x = x, y = y)
training <- d[select > 0.1, ]
test <- d[select <= 0.1, ]

ggplot(training, aes(x = x, y = y)) + geom_point(alpha = 0.4) 


library(mgcv)
gam_model <- gam(y ~ s(x), data = training)
gam_model

training$gam_pred <- predict(gam_model, training)
ggplot(training, aes(x = x, y = y)) + 
  geom_point(alpha = 0.2) + 
  geom_line(aes(y = gam_pred, 
                color = 'GAM'), size = 1.3)  +
  scale_colour_manual(
    name="MODEL", 
    values=c(GAM = "#DE3163")) +
  theme(legend.position = c(0.9, 0.9)) +
  theme(legend.background=element_rect(fill="white", colour="black"))

#analiza 
summary(gam_model)

## RMSE gam
resid_gam <- training$y - predict(gam_model)
rmse_gam <- sqrt(mean(resid_gam ^ 2))

## RMSE liniowy 
linear_model <- lm(y ~ x, data = training)
resid_linear <- training$y - predict(linear_model)
rmse_lin <- sqrt(mean(resid_linear ^ 2))

#r^2 gam
r2_gam <- summary(gam_model)$r.sq
#r^2 liniowy
r2_lin <- summary(linear_model)$r.sq


#AIC gam
aic_gam <- AIC(gam_model)
aic_gam
#AIC liniowy
aic_lin <- AIC(linear_model)

rmse <- c(rmse_gam,rmse_lin)
r2 <- c(r2_gam,r2_lin)
aic <-c(aic_gam,aic_lin)
rows <- c('GAM','Model Liniowy')

porownanie <- data.frame("RMSE" = rmse, "R Squared" = r2, "AIC" = aic)
porownanie
rownames(porownanie) <- rows                        
porownanie
