library(cluster)
library(stats)
library(dplyr)
library(ggplot2)
setwd("/home/student/Repositories/data-mining/case-study")
# Wczytywanie danych
file_path <- 'diamonds.txt'
diamonds_df <- read.csv(file_path, skip = 12)

# Standaryzacja danych
features <- c('carat', 'depth', 'table', 'price', 'x', 'y', 'z')
data_scaled <- scale(select(diamonds_df, all_of(features)))

# ## Wykonanie modeli hierarchicznych z metryką Manhattan
# hclust1 <- agnes(data_scaled, method = "complete", metric = "manhattan")
# hclust2 <- agnes(data_scaled, method = "average", metric = "manhattan")

# Wykonanie modeli k-średnich
set.seed(42)
kmeans1 <- kmeans(data_scaled, centers = 4, iter.max = 100, nstart = 25, algorithm = "MacQueen")
kmeans2 <- kmeans(data_scaled, centers = 4, iter.max = 100, nstart = 25, algorithm = "Lloyd")

# Głosowanie na klaster docelowy
# Przycinanie drzew hierarchicznych do 4 klastrów
# cutree1 <- cutree(hclust1, k = 4)
# cutree2 <- cutree(hclust2, k = 4)

# Przygotowanie ramki danych z przypisaniami klastrów
# clusters <- data.frame(cutree1, cutree2, kmeans1$cluster, kmeans2$cluster)
clusters <- data.frame(kmeans1$cluster, kmeans2$cluster)
# Funkcja do głosowania na klaster docelowy

vote_for_cluster <- function(row) {
  as.integer(names(sort(table(row), decreasing = TRUE)[1]))
}

# Przypisywanie klastra docelowego
final_cluster <- apply(clusters, 1, vote_for_cluster)

# Dodawanie klastera docelowego do oryginalnego zbioru danych
diamonds_df$final_cluster <- final_cluster

# Wizualizacja klastrów
ggplot(diamonds_df, aes(x = carat, y = price, color = factor(final_cluster))) +
  geom_point(alpha = 0.5) +
  labs(title = "Wizualizacja klastrów dla cech 'carat' i 'price'",
       x = "Carat",
       y = "Price",
       color = "Klaster") +
  theme_minimal()

