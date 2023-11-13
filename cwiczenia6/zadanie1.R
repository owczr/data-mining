table(iris$Species)
cor(iris[-5])
library(psych)
pairs.panels(iris[-5])
boxplot(Sepal.Length~Species, iris)
#własna funkcja do wykonania standaryzacji lub inaczej normalizacji z-score
stand <-function(x) { (x -mean(x))/(sd(x)) }
iris_std<- as.data.frame(lapply(iris[,c(1,2,3,4)],stand ))
iris_std_sp<-data.frame(iris_std, iris$Species)
#podzbiory
set.seed(123)
sets <- sample(1:nrow(iris), 0.75 * nrow(iris))
train_ir<-iris_std_sp[sets,]
test_ir<-iris_std_sp[-sets,]
#klasy poszczególnych obserwacji w podzbiorach
train_ir_class<-iris[sets,5]
test_ir_class<-iris[-sets,5]
#pakiet do modeli klasyfikacyjnych kNN
library(class)
#model 1a
model_ir3 <- knn(train = train_ir[, 1:4], test = test_ir[,1:4], cl = train_ir_class, k=12)
t_ir3<-table(Species=test_ir_class, Prediction=model_ir3)
acc_ir3<-mean(test_ir_class == model_ir3)
acc_ir3

set.seed(123)
library(MASS)
library(caret)
#funkcja standaryzująca, zamiast niej może być np. scale()
stand <-function(x) { (x -mean(x))/(sd(x)) }
data("Boston")
sets <- sample(1:nrow(Boston), 0.75 * nrow(Boston))
train<-Boston[sets,]
train_std<- as.data.frame(lapply(train[,c(1:13)],stand ))
train_y<-train[,14]
test<-Boston[-sets,]
test_std<- as.data.frame(lapply(test[,c(1:13)],stand ))
test_y<-test[,14]
knnm1<- knnreg(train_std, train_y, k=12)
str(knnm1)
pred_y = predict(knnm1, data.frame(test_std))
mse = mean((test_y - pred_y)^2)
rmse = caret::RMSE(test_y, pred_y)
R2 = (cor(test_y, pred_y))^2

acc_ir3
R2
