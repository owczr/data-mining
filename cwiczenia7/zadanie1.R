library(rpart)
library(randomForest)

setwd("/home/student/Repositories/data-mining/cwiczenia7/")

# Wczytanie danych (załóżmy, że są już w zmiennej `pima_data`)
pima_data <- read.csv(
    "pima-indians-diabetes.txt",
    header = FALSE,
    col.names = c(
        "pregnant", "glucose", "pressure", "triceps", "insulin", "mass", "pedigree", "age", "outcome"
    )
)

# Podział danych na zbiór uczący i testowy
set.seed(123) # Dla powtarzalności wyników
indices <- sample(1:nrow(pima_data), size = 0.7 * nrow(pima_data))
train_data <- pima_data[indices, ]
test_data <- pima_data[-indices, ]

# Budowa drzewa decyzyjnego
tree_model <- rpart(outcome ~ ., data = train_data, method = "class")

# Budowa modelu Random Forest
rf_model <- randomForest(as.factor(outcome) ~ ., data = train_data, ntree = 10, importance = TRUE, nodesize = 5, method = "class")

# Ocena modeli na zbiorze testowym
tree_pred <- predict(tree_model, test_data, type = "class")
rf_pred <- predict(rf_model, test_data)

# Obliczenie dokładności
tree_accuracy <- sum(tree_pred == test_data$outcome) / nrow(test_data)
rf_accuracy <- sum(rf_pred == test_data$outcome) / nrow(test_data)

# Wyświetlenie dokładności
print(tree_accuracy)
print(rf_accuracy)
