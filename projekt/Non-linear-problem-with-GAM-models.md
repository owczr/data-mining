---
title: "Non-linear problem with GAM models"
author: "Katarzyna Warzecha Zuzanna Stachura Patryk Sroka Shamte Ndiaye Jakub Owczarek"
date: "20-11-2023"
output:
  html_document: default
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(warning = FALSE, echo = TRUE)
```

## Rozwiązywanie problemów nieliniowych za pomocą modeli GAM

Jedną z najwygodniejszych metod przewidywania pomiaru zmiennej na podstawie innych zmiennych jest regresja liniowa. Nie zawsze jednak relacje między zmiennymi są liniowe. W tego typu problemach zastosowanie znajdują inne algorytmy. Przykładem mogą być **uogólnione modele addytywne ( Generalized Additive Models GAM)**, które zostaną przedstwione w poniższym tutorialu.

Modele GAM w swojej najprostszej postaci próbują złagodzić ograniczenie liniowości poprzez znalezienie zbioru funkcji s_i() oraz stałej a0 takich, że:
f(x[i,]) = a0 + s_1(x[i,1]) + s_2(x[i,2]) + … s_n(x[i,n])

Mamy tu do czynienia z pewną konkretną (addytywną) funkcją wejść, która nie będzie wymagała (ewentualnie przekształconej) funkcji
y być funkcją liniową x. Działanie polega na wyborze podstawy, co w sensie technicznym oznacza wybór przestrzeni funkcji, dla których s_n jest jakimś jej elementem. Z praktycznego punktu widzenia jest to sposób na uchwycenie zależności nieliniowych.

Przykład porównania modeli GAM z innymi modelami:

![Rys. 1.: porównanie modeli GAM z innymi](C:\Users\Katarzyna Warzecha\OneDrive\Pulpit\Data Mining\gam1.PNG)

## Przegląd pakietów R pozwalających na implementację modeli GAM

W R istnieje wiele pakietów, które pozwalają na implementację modeli Generalized Additive Models (GAM). Jednym z najpopularniejszych pakietów do tworzenia GAM w R jest **mgcv**. Pakiet ten został opracowany przez autora GAM, Simona N. Wooda. 
Poza tym w R można znależć pakiety: **gam**, **gamlss** (modele addytywne z parametrem położenia, skali i kształtu) czy **gamm4** (pakiet łączący pakiet mgcv i lme4 - pakiet umożliwiający analizę modeli łączonych liniowych i nieliniowych)

| Pakiet  | Zalety |
|---------|--------|
| mgcv    | Jest jednym z najpopularniejszych pakietów do dopasowywania gładkich, nieliniowych związków, oferuje szeroki zakres potężnych narzędzi do modelowania złożonych danych. |
| gam     | Modele GAM są niemal 30-letnie, wiele badań i praktyk przemysłowych opiera się na modelach liniowych i metodach status quo do modelowania. Modele te oferują przejście do bardziej elastycznych modeli, zachowując część interpretowalności. | 
| gamlss  | Nowoczesne podejście oparte na rozkładzie do regresji semiparametrycznej. Zakłada parametryczny rozkład zmiennej odpowiedzi, ale parametry tego rozkładu mogą się zmieniać w zależności od zmiennych objaśniających. Umożliwia modelowanie wszystkich parametrów rozkładu (lokalizacji, skali, kształtu) jako funkcji liniowych, nieliniowych lub gładkich. |


## Argumenty modelu GAM

Wśród argumentów modelu `GAM` w pakiecie `mgcv` najbardziej istotne są argumenty, które mają bezpośredni wpływ na konstrukcję, dopasowanie i interpretację modelu. Oto kilka kluczowych:

- **formula**: Jest to podstawowy argument, który definiuje model. Określa, jakie zmienne są używane w modelu i jak są one powiązane. Użycie gładkich funkcji (np. `s()`, `te()`) w formule pozwala na modelowanie złożonych nieliniowych zależności.

- **family**: Określa rodzaj rozkładu danych i funkcję linkującą, co jest kluczowe dla zrozumienia, jak model interpretuje zależności między zmiennymi. Wybór rodziny (np. `binomial`, `gaussian`) ma znaczący wpływ na to, jak model przetwarza dane i jakie wnioski można z niego wyciągnąć.

- **data**: Zbiór danych, na którym model jest trenowany. Odpowiednie przygotowanie i zrozumienie danych jest kluczowe dla skutecznego modelowania.

- **method**: Metoda szacowania parametrów wygładzania, która ma wpływ na to, jak model dopasowuje gładkie termy do danych. Różne metody (np. `GCV.Cp`, `REML`) mogą prowadzić do różnych wyników i interpretacji modelu.

- **sp**: Wektor parametrów wygładzania, który pozwala na kontrolowanie stopnia wygładzania dla poszczególnych terminów gładkich. Wpływa to na elastyczność modelu i może mieć duży wpływ na dopasowanie modelu oraz na unikanie nadmiernego dopasowania (overfitting).

- **select**: Pozwala na penalizację terminów do zera, co umożliwia modelowi automatyczne wybieranie istotnych predyktorów, co jest szczególnie przydatne w modelach z dużą liczbą zmiennych.

Ponad to w dokumentacji [funkcji GAM](https://www.rdocumentation.org/packages/mgcv/versions/1.9-0/topics/gam) możemy znaleźć wiele więcej argumentów pozwalających na lepsze dostosowanie parametrów naszego modelu.


## Przykład zastosowania

Poniżej przedstawiono zastosowanie modelu GAM dla wygenerowanego ręcznie, przykładowego zbioru danych:

### Użyte pakiety i funkcje 

Celem stworzenia przykładu zaimplementowano następujące pakiety i funkcje:\
- wykresy: pakiet - ggplot2, funkcje - ggplot()\
- tworzenie modelu GAM: pakiet - mgcv, funkcje - gam()\
- wyznaczenie rezyduów: funkcja - predict()\

### Wykorzystane dane 

Dane wykorzystane w przykładzie zostały wygenerowane ręcznie. Utworzono funkcję generującą zbiór punktów, w taki sposób, aby nie była ona zbyt oczywista do wskazania dla niej modelu, dodano szum. Stworzono Data Frame i podzielono go na zbiór uczący i testowy. 

Fragment kodu zawierający generowanie danych wykorzystanych w przykładzie:

```{r}
library(ggplot2)
set.seed(12)
x <- rnorm(2000)
noise <- rnorm(2000, sd = 3)
y <- 3 * sin(5 * x) + cos(2 * x) - 0.8 * (x ^ 2 ) + noise
select <- runif(2000)
d <- data.frame(x = x, y = y)
training <- d[select > 0.1, ]
test <- d[select <= 0.1, ]

ggplot(training, aes(x = x, y = y)) + geom_point(alpha = 0.4) 
```

### Wykonanie przykładowego modelowania

Zastosowano model GAM dla danych wygenerowanych w poprzednim kroku. Dokonano wizualizacji dopasowania modelu do utworzonego wcześniej zbioru:

```{r}
library(ggplot2)
library(mgcv)

gam_model <- gam(y ~ s(x), data = training)
gam_model
```

```{r}
training$gam_pred <- predict(gam_model, training)
ggplot(training, aes(x = x, y = y)) + 
  geom_point(alpha = 0.2) + 
  geom_line(aes(y = gam_pred, 
                color = 'GAM'), size = 1.3)  +
  scale_colour_manual(
    name="MODEL", 
    values=c(GAM = "#DE3163")) +
  theme(legend.position = c(0.9, 0.9)) +
  theme(legend.background=element_rect(fill="white", colour="black"))
```

Przeanalizowano stworzony wcześniej model:

```{r}
summary(gam_model)
```

Porównano wykonany model z modelem liniowym. W tym celu zbadano RMSE, R^2 oraz AIC:

```{r}
## RMSE gam
resid_gam <- training$y - predict(gam_model)
rmse_gam <- sqrt(mean(resid_gam ^ 2))

## RMSE liniowy 
linear_model <- lm(y ~ x, data = training)
resid_linear <- training$y - predict(linear_model)
rmse_lin <- sqrt(mean(resid_linear ^ 2))

#r^2 gam
r2_gam <- summary(gam_model)$r.sq
#r^2 liniowy
r2_lin <- summary(linear_model)$r.sq


#AIC gam
aic_gam <- AIC(gam_model)
#AIC liniowy
aic_lin <- AIC(linear_model)

rmse <- c(rmse_gam,rmse_lin)
r2 <- c(r2_gam,r2_lin)
aic <-c(aic_gam,aic_lin)
rows <- c('GAM','Model Liniowy')

porownanie <- data.frame("RMSE" = rmse, "R Squared" = r2, "AIC" = aic)
rownames(porownanie) <- rows                        
porownanie
```

Wobec powyższych statystyk zaobserwować można wyraźnie większą efektywność modelu GAM w stosunku do modelu liniowego.

