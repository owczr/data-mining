setwd("/home/student/Repositories/data-mining/case-study")

# Wczytywanie pakietów
library(readr)
library(dplyr)
library(ggplot2)
library(cluster)

# Wczytywanie danych
file_path <- 'diamonds.txt'
diamonds_df <- read.csv(file_path, skip = 12)

# Wyświetlanie pierwszych kilku wierszy danych
print(head(diamonds_df))

# Wybór cech numerycznych do klasteryzacji
features <- c('carat', 'depth', 'table', 'price', 'x', 'y', 'z')
data_for_clustering <- select(diamonds_df, all_of(features))

# Standaryzacja danych
data_scaled <- scale(data_for_clustering)

# # Użycie metody łokcia do określenia optymalnej liczby klastrów
# wcss <- numeric(10)
# for (i in 1:10) {
#   kmeans_result <- kmeans(data_scaled, centers = i, nstart = 25)
#   wcss[i] <- kmeans_result$tot.withinss
# }

# # Rysowanie wyników metody łokcia
# plot(1:10, wcss, type = 'b', pch = 19, frame = FALSE, 
#      xlab = "Liczba klastrów", ylab = "Suma kwadratów wewnątrz klastrów")

# Tworzenie modelu k-średnich z arbitralnie wybraną liczbą klastrów, np. 5
n_clusters <- 4
set.seed(42) # dla reprodukowalności wyników
kmeans_model <- kmeans(data_scaled, centers = n_clusters, nstart = 25)

# Dodawanie etykiet klastrów do oryginalnego zbioru danych
diamonds_df$cluster <- kmeans_model$cluster

# Wyświetlanie pierwszych kilku wierszy dataframe z etykietami klastrów
print(head(diamonds_df))

# Wizualizacja klastrów
ggplot(diamonds_df, aes(x = carat, y = price, color = factor(cluster))) +
  geom_point(alpha = 0.5) +
  labs(title = "Wizualizacja klastrów dla cech 'carat' i 'price'",
       x = "Carat",
       y = "Price",
       color = "Klaster") +
  theme_minimal()
