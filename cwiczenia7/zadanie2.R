# Wczytywanie pakietów
library(rpart)
library(lubridate)

setwd("/home/student/Repositories/data-mining/cwiczenia7/")

# Wczytanie danych
randki <- read.csv("Randki1.txt", skip = 1, header = TRUE, sep = "\t")

# Konwersja na date
randki$data_logowania <- as.Date(randki$data_logowania, format = "%d-%m-%Y")

# Ekstrakcja dni, dni tygodnia i miesięcy
randki$dni <- day(randki$data_logowania)
randki$dni_tygodnia <- wday(randki$data_logowania, label = TRUE)
randki$miesiace <- month(randki$data_logowania, label = TRUE)
randki$is_thursday <- dni_tygodnia == "czw"
randki$is_friday <- dni_tygodnia == "pt"

# Eksploracja danych (opcjonalnie)
summary(randki)
str(randki)

# Podział na dane uczące i testowe
set.seed(123)
indices <- sample(1:nrow(randki), 0.7 * nrow(randki))
train_data <- randki[indices, ]
test_data <- randki[-indices, ]

# Budowa drzewa regresyjnego
tree_model <- rpart(Liczba_logowan ~ ., data = train_data, method = "anova")

# Budowa modelu regresji wielorakiej
lm_model <- lm(Liczba_logowan ~ ., data = train_data)

# Predykcja i ocena drzewa regresyjnego
tree_pred <- predict(tree_model, test_data)
tree_mse <- mean((test_data$Liczba_logowan - tree_pred)^2)
tree_mape <- mean(abs(test_data$Liczba_logowan - tree_pred) / test_data$Liczba_logowan)

# Predykcja i ocena regresji wielorakiej
lm_pred <- predict(lm_model, test_data)
lm_mse <- mean((test_data$Liczba_logowan - lm_pred)^2)
lm_mape <- mean(abs(test_data$Liczba_logowan - lm_pred) / test_data$Liczba_logowan)

# Porównanie modeli
print(paste("MSE Drzewo regresyjne:", tree_mse))
print(paste("MSE Regresja wieloraka:", lm_mse))
print(paste("MAPE Drzewo regresyjne:", tree_mape))
print(paste("MAPE Regresja wieloraka:", lm_mape))

# Przed
# [1] "MSE Drzewo regresyjne: 11600.3850841058"
# [1] "MSE Regresja wieloraka: 157106.414952976"
# [1] "MAPE Drzewo regresyjne: 0.0596655717115431"
# [1] "MAPE Regresja wieloraka: 0.241343841352655"

# Z dodanymi kolumnami day, month, is_thursday, is_friday
# [1] "MSE Drzewo regresyjne: 15427.3031441468"
# [1] "MSE Regresja wieloraka: 22249.1557729415"
# [1] "MAPE Drzewo regresyjne: 0.0643823783593678"
# [1] "MAPE Regresja wieloraka: 0.0791520157665521"
