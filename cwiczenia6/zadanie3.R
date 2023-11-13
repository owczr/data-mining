library(mlbench)

# Wczytanie danych Pima Indians Diabetes
data(PimaIndiansDiabetes)
pima <- PimaIndiansDiabetes

# Analiza danych
summary(pima)
str(pima)
any(is.na(pima)) # Czy są jakieś brakujące dane?

pima_clean <- pima
zero_columns <- c("glucose", "pressure", "triceps", "insulin", "mass") # Kolumny, gdzie 0 uznajemy za brakujące wartości

for (column in zero_columns) {
  pima_clean[, column][pima_clean[, column] == 0] <- median(pima_clean[, column][pima_clean[, column] != 0], na.rm = TRUE)
}
# Normalizacja danych
pima_scaled <- as.data.frame(scale(pima_clean[, -ncol(pima_clean)])) # Nie skalujemy ostatniej kolumny, która jest etykietą

# Dodanie etykiety z powrotem do zbioru danych
pima_scaled$diabetes <- pima$diabetes

# Podział na zbiory uczące i testowe
set.seed(123) # Dla powtarzalności wyników
index <- sample(1:nrow(pima_scaled), 0.7 * nrow(pima_scaled))
train_set <- pima_scaled[index, ]
test_set <- pima_scaled[-index, ]

library(class)

# Wypróbowanie różnych wartości k
ks <- c(1, 3, 5, 7, 9, 11, 13, 15)
for (k in ks) {
  set.seed(123) # Dla powtarzalności wyników
  pred <- knn(train = train_set[, -ncol(train_set)], test = test_set[, -ncol(test_set)], cl = train_set$diabetes, k = k)
  
  # Macierz pomyłek
  cm <- table(Observed = test_set$diabetes, Predicted = pred)
  print(cm)
  
  conf_matrix <- confusionMatrix(data = pred, reference = test_set[, ncol(test_set)])
  accuracy <- conf_matrix$overall['Accuracy']
  f1_score <- conf_matrix$byClass['F1']
  
  # Precyzja, czułość, specyficzność
  precision <- diag(cm) / rowSums(cm)
  sensitivity <- cm[2,2] / sum(cm[2,])
  specificity <- cm[1,1] / sum(cm[1,])
  
  cat("\nk =", k, "\n")
  cat("Precyzja =", precision, "\n")
  cat("Czułość =", sensitivity, "\n")
  cat("Specyficzność =", specificity, "\n")
  cat("Celność =", accuracy, "\n")
  cat("F1 =", f1_score, "\n")
}

