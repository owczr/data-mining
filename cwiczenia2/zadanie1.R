setwd('/home/student/Repositories/data-mining/cwiczenia2/')
library(plotly)

df = read.delim('wastewater.txt')
summary(df)

par(mfrow=c(2, 2))
boxplot(df$Sandomierz)
plot(df$Sandomierz, type="l")
hist(df$Sandomierz, breaks=8)

df_cleaned = mutate(
    df,
    a_Sandomierz=ifelse(
        Sandomierz <= 20 | Sandomierz >= 0, Sandomierz, NA 
    )
)

par(mfrow=c(2, 2))
boxplot(df_cleaned$a_Sandomierz)
plot(df_cleaned$a_Sandomierz, type="l")
hist(df_cleaned$a_Sandomierz, breaks=8)
