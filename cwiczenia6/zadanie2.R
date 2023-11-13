setwd("/home/student/Repositories/data-mining/cwiczenia6/")
real_estate <- read.csv("Real_estate.csv")
real_estate$y = real_estate$Y.house.price.of.unit.area
real_estate$x1 = real_estate$X1.transaction.date
real_estate$x2 = real_estate$X2.house.age
real_estate$x3 = real_estate$X3.distance.to.the.nearest.MRT.station
real_estate$x4 = real_estate$X4.number.of.convenience.stores
real_estate$x5 = real_estate$X5.latitude
real_estate$x6 = real_estate$X6.longitude

library(corrplot)
corr_matrix<-round(cor(real_estate[2:8]),2)
corrplot(corr_matrix)

# Załóżmy, że dane zostały wczytane i są dostępne jako `real_estate`
# Podział danych na zbiór treningowy i testowy
set.seed(123) # Zapewnienie powtarzalności wyników
n <- nrow(real_estate)
splits <- sample(1:n, 0.95 * n)
train_data <- real_estate[splits, ]
test_data <- real_estate[-splits, ]

# Budowa modelu regresji prostej liniowej
linear_model <- lm(y ~ x3, data=train_data)

# Predykcja na 5% danych testowych
predictions_linear <- predict(linear_model, newdata=test_data)

# Ocena jakości modelu
summary(linear_model) # Wyświetla R-squared i inne statystyki

# Budowa modelu regresji wielorakiej
multiple_model <- lm(y ~ x3 + x4 + x5, data=train_data)

# Predykcja na 5% danych testowych
predictions_multiple <- predict(multiple_model, newdata=test_data)

# Ocena jakości modelu
summary(multiple_model)

# Estymacja wartości początkowych
optim_fun <- function(params) {
  a <- params[1]
  b <- params[2]
  c <- params[3]
  sum((train_data$y - (a + b * exp(-c * train_data$x3)))^2)
}

# Dobrze jest podać realistyczne wartości początkowe
opt <- optim(c(1, 1, 0.1), optim_fun, method = "BFGS")

# Sprawdzenie wyników
a <- opt$par[1]
b <- opt$par[2]
c <- opt$par[3]

start_vals = list(a=a, b=b, c=c)

# Budowa modelu nieliniowego
nonlinear_model <- nls(y ~ a + b * exp(-c * x3), data = train_data, start = start_vals)

# Predykcja na 5% danych testowych
predictions_nonlinear <- predict(nonlinear_model, newdata=test_data)

# Ocena jakości modelu
summary(nonlinear_model)

library(class)
# Przygotowanie danych (standaryzacja)
scale_train_data <- scale(train_data[,-which(names(train_data) == "y")])
scale_test_data <- scale(test_data[,-which(names(test_data) == "y")])

# Budowa modelu kNN regresji
knn_model <- knnreg(scale_train_data, train_data$y, k=5)

# Predykcje
predictions_knn <- predict(knn_model, data.frame(scale_test_data))

# Ocena jakości modelu
mse_knn <- mean((test_data$y - predictions_knn)^2)

# Obliczamy błędy predykcji dla każdego modelu
mse_linear <- mean((test_data$y - predictions_linear)^2)
mse_multiple <- mean((test_data$y - predictions_multiple)^2)
mse_nonlinear <- mean((test_data$y - predictions_nonlinear)^2)

knn_R2 = (cor(test_data$y, predictions_knn))^2
linear_R2 = (cor(test_data$y, predictions_linear))^2
multiple_R2 = (cor(test_data$y, predictions_multiple))^2
nonlinear_R2 = (cor(test_data$y, predictions_nonlinear))^2

# Porównujemy MSE
mse_comparison <- data.frame(Linear=mse_linear, Multiple=mse_multiple, Nonlinear=mse_nonlinear, kNN=mse_knn)

# Porównujemy R2
R2_comparison <- data.frame(Linear=linear_R2, Multiple=multiple_R2, Nonlinear=nonlinear_R2, kNN=knn_R2)

mse_comparison
R2_comparison
