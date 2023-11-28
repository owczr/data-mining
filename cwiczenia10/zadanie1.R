# Wykonaj model sieci neuronowej dla danych IndianPima. Porównaj jakość z wcześniej
# wykonanym modelem
library(neuralnet)
library(dplyr)
library(caret)

setwd("/home/student/Repositories/data-mining/cwiczenia10")
df <- read.csv(
    "pima-indians-diabetes.txt",
    header = FALSE,
    col.names = c(
        "pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age", "outcome"
    )
)

stand <- function(x) { (x -mean(x)) / (sd(x)) }

features <- df[1:8]
target <- df[9]

features[features == 0] <- NA

features <- as.data.frame(lapply(features, function(x) { replace(x, is.na(x), mean(x, na.rm = TRUE)) }))
features <- as.data.frame(lapply(features, stand))

df <- cbind(features, target)
set.seed(123)

index <- sample(1 : nrow(df), round(0.7 * nrow(df)))

train <- df[index,]
test <- df[-index,]

print("Fitting model")
model <- neuralnet(
    outcome ~ .,
    data = train,
    hidden = 5,
    act.fct = "logistic",
    rep = 5,
    linear.output = FALSE,
    err.fct = "ce",
    threshold = 0.005
)

print("Predicting")
pred <- predict(model, test, type = "class")

# Zaokraglij wynik
pred <- round(pred)

# Confusion matrix
cmatrix <- confusionMatrix(as.factor(pred), as.factor(test$outcome))
print(cmatrix$overall["Accuracy"])

plot(model)
# 0.7695652 
# 0.7652174