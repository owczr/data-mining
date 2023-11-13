library(dplyr)

df <- mtcars

model1 <- lm(mpg ~ cyl + disp + wt + vs, data = mtcars)

summary(model1)

model2 <- lm(mpg ~ cyl + disp + wt, data = mtcars)

summary(model2)

model3 <- lm(mpg ~ cyl + wt, data = mtcars)

summary(model3)

library(minpack.lm)

model2 <- nls(mpg ~ a0 * b1 ^ wt, data = mtcars, start = list(a0 = 1, b1 = 2))

summary(model2)

model2_results<-data.frame(pred=49.65969*0.74559^mtcars$wt,
                           real=mtcars$mpg)

model2_results

model2_results <- model2_results %>% mutate(res = real - pred)

model2_R2 <- (cor(model2_results$real, model2_results$pred)) ^ 2

model2_R2  # 0.8106254

pairs(mtcars)

plot(mpg ~ wt, data = mtcars)
plot(mpg ~ disp, data = mtcars)
plot(mpg ~ hp, data = mtcars)

model3 <- nls(mpg ~ a0 * b1 ^ disp, data = mtcars, start = list(a0 = 1, b1 = 1))

model3_summary <- summary(model3)

a0 <- model3_summary$parameters[1]
b1 <- model3_summary$parameters[2]

model3_results <- data.frame(pred = a0*b1^mtcars$wt,real=mtcars$mpg)

model3_results <- model3_results %>% mutate(res = real - pred)

model3_R2 <- (cor(model3_results$real, model3_results$pred)) ^ 2
model3_R2
summary(model3)

# wt = 0.8106253, 50 0.1
# hp = 0.7541081
# disp = 0.7535378

mtcars$disp

mtcars <- mtcars %>% 
  mutate(cyl8 = (cyl == 8))
mtcars <- mtcars %>% 
  mutate(cyl6 = (cyl == 6))
mtcars <- mtcars %>% 
  mutate(cyl4 = (cyl == 4))

mtcars

model3 <- nls(
  mpg ~ a0 * b1^wt + b2 ^ cyl4,
  data = mtcars,
  start = list(a0 = 50, b1 = 2, b2 = 3)
)

model3_summary <- summary(model3)

a0 <- model3_summary$parameters[1]
b1 <- model3_summary$parameters[2]
b2 <- model3_summary$parameters[3]
# b3 <- model3_summary$parameters[4]

model3_results<-data.frame(
  pred = a0 * b1^mtcars$wt + b2 ^ mtcars$cyl4,
  real=mtcars$mpg
)

model3_results <- model3_results %>% mutate(res = real - pred)

model3_R2 <- (cor(model3_results$real, model3_results$pred)) ^ 2
model3_R2
summary(model3)

# mpg ~ a0 * b1^wt + b2*cyl4, R2 =  0.8446665
# mpg ~ a0 * b1^wt + b2^cyl4, R2 =  0.8452799
# mpg ~ a0 * b1^wt + b2*cyl4 + b3 * cyl8, R2 = 0.8487145
