import pandas as pd
from pygam import LinearGAM, s, f
from sklearn.metrics import mean_squared_error, r2_score


def run():
    df_cleaned = process()
    X_train, X_test, y_train, y_test = split(df_cleaned)
    gam(X_train, X_test, y_train, y_test)


def process():
    df = pd.read_csv("wastewater.txt", sep="\s+", names=["Date", "Sandomierz"], skiprows=1)
    df["Date"] = pd.to_datetime(df["Date"].astype(str), format="%Y.%m")
    df["Sandomierz"] = df["Sandomierz"].fillna(df["Sandomierz"].mean())
    df = df.set_index("Date")
    df_cleaned = df[df["Sandomierz"] < 10]
    df_cleaned = df_cleaned[df_cleaned["Sandomierz"] > -10]

    return df_cleaned


def split(df_cleaned):
    X = df_cleaned.index.values
    y = df_cleaned["Sandomierz"].values

    X_train = X[: int(0.8 * len(X))]
    X_test = X[int(0.8 * len(X)) :] 

    y_train = y[: int(0.8 * len(y))]    
    y_test = y[int(0.8 * len(y)) :]

    return X_train, X_test, y_train, y_test


def gam(X_train, X_test, y_train, y_test):
    gam = LinearGAM(s(0))
    gam.fit(X_train, y_train)


    y_pred = gam.predict(X_test)

    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    print(f'Mean Squared Error: {mse}')
    print(f'R-squared: {r2}')
    print(gam.summary())


if __name__ == "__main__":
    run()
