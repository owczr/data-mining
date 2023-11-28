# Wczytywanie pakietów
library(rpart)
library(lubridate)
library(neuralnet)

setwd("/home/student/Repositories/data-mining/cwiczenia10/")

# Wczytanie danych
# randki <- read.csv("Randki1.txt", skip = 1, header = TRUE, sep = "\t")
randki <- Randki1[1:nrow(Randki1) - 1,]

# Usun brakujace wartosci
randki <- randki[complete.cases(randki), ]

# Konwersja na date
randki$data_logowania <- as.Date(randki$data_logowania, format = "%d-%m-%Y")

# Ekstrakcja dni, dni tygodnia i miesięcy
randki$dni <- day(randki$data_logowania)
randki$dni_tygodnia <- wday(randki$data_logowania, label = TRUE)
randki$miesiace <- as.integer(month(randki$data_logowania, label = TRUE))
randki$is_thursday <- as.integer(randki$dni_tygodnia == "czw")
randki$is_friday <- as.integer(randki$dni_tygodnia == "pt")
randki$index <- 1:nrow(randki)
randki$dni_tygodnia <- as.integer(wday(randki$data_logowania, label = TRUE))

# Eksploracja danych (opcjonalnie)
# summary(randki)
# str(randki)

# Podział na dane uczące i testowe
set.seed(123)
indices <- sample(1:nrow(randki), 0.7 * nrow(randki))
train_data <- randki[indices, ]
test_data <- randki[-indices, ]

# Przetowrzenie danych pod sieć neuronową
train_data <- train_data[, c("Liczba_logowan", "dni", "miesiace", "dni_tygodnia", "is_thursday", "is_friday", "index")]
test_data <- test_data[, c("Liczba_logowan", "dni", "miesiace", "dni_tygodnia", "is_thursday", "is_friday", "index")]

# Standaryzacja danych
# train_data[, c("Liczba_logowan", "dni")] <- scale(train_data[, c("Liczba_logowan", "dni")])
# test_data[, c("Liczba_logowan", "dni")] <- scale(test_data[, c("Liczba_logowan", "dni")])

# Budowa modelu sieci neuronowej
print("Fitting model")
model <- neuralnet(
    Liczba_logowan ~ .,
    data = train_data,
    hidden = c(5, 5),
    rep = 5,
    linear.output = TRUE,
)

print("Predicting")
pred <- predict(model, test_data, type = "regression")

mse <- mean((test_data$Liczba_logowan - pred)^2)
mae <- mean(abs(test_data$Liczba_logowan - pred))
mape <- mean(abs(test_data$Liczba_logowan - pred) / test_data$Liczba_logowan)

print(paste("MSE:", mse))
print(paste("MAE:", mae))
print(paste("MAPE:", mape))
plot(model)
# "MSE: 136240.192457037"
# "MAE: 306.234831800745"
# "MAPE: 0.202525427230595"