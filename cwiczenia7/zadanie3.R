# Wczytywanie pakietów
library(rpart)
library(randomForest)

setwd("/home/student/Repositories/data-mining/cwiczenia7/")

# Wczytanie danych
data <- read.csv('Life Expectancy Data.csv', col.names = c(
    "Country","Year","Status","LifeExpectancy", "AdultMortality",
    "InfantDeaths","Alcohol","PercentageExpenditure","HepatitisB",
    "Measles", "BMI", "UnderFiveDeaths","Polio","TotalExpenditure",
    "Diphtheria", "HIVAIDS", "GDP","Population", "Thinness1_19Years",
     "Thinness5_9Years","IncomeCompositionOfResources", "Schooling"
    )
)

# print(head(data))
# print(summary(data))

# Przygotowanie danych
data <- na.omit(data) # Obsługa braku danych

# Usuniecie Country i Status
data <- subset(data, select = -c(Country, Status))

# Podział na dane uczące i testowe
set.seed(123)
indices <- sample(1:nrow(data), 0.7 * nrow(data))
train_data <- data[indices, ]
test_data <- data[-indices, ]

# Budowa modelu regresji liniowej
model_lm <- lm(LifeExpectancy ~ ., data = train_data)

# Budowa modelu drzewa decyzyjnego
model_tree <- rpart(LifeExpectancy ~ ., data = train_data)

# Budowa modelu lasu losowego
model_rf <- randomForest(LifeExpectancy ~ ., data = train_data)

# Ocena modeli
lm_pred <- predict(model_lm, test_data)
tree_pred <- predict(model_tree, test_data)
rf_pred <- predict(model_rf, test_data)

# Obliczanie R^2
r2_lm  <- (cor(test_data$LifeExpectancy, lm_pred))^2
r2_tree  <- (cor(test_data$LifeExpectancy, tree_pred))^2
r2_rf  <- (cor(test_data$LifeExpectancy, rf_pred))^2

# Porównanie wyników
print(paste("R^2 Regresja liniowa:", r2_lm))
print(paste("R^2 Drzewo decyzyjne:", r2_tree))
print(paste("R^2 Las losowy:", r2_rf))
