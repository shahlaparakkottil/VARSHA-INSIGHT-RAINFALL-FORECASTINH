import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

st.set_page_config(
    page_title="Varsha Insight",
    layout="wide"
)

df = pd.read_csv("cleaned_rainfall_dataset.csv")
forecast_df = pd.read_csv("rainfall_forecast_2018_2030.csv")
alert_df = pd.read_csv("rainfall_alerts_advisory.csv")

st.title("🌧️ Varsha Insight: Rainfall Prediction & Climate Analysis System")

st.write("""
This application analyzes historical rainfall data, forecasts future rainfall,
detects drought and heavy rainfall conditions, and provides farmer advisory recommendations.
""")

menu = st.sidebar.radio(
    "Select Section",
    [
        "Home",
        "Rainfall Analysis",
        "Forecasting",
        "Alert System",
        "Project Summary"
    ]
)

if menu == "Home":
    st.header("Project Overview")

    col1, col2, col3 = st.columns(3)

    col1.metric("Total Records", df.shape[0])
    col2.metric("Subdivisions", df["SUBDIVISION"].nunique())
    col3.metric("Forecast Years", "2018 - 2030")

    st.subheader("Dataset Preview")
    st.dataframe(df.head())

elif menu == "Rainfall Analysis":
    st.header("Historical Rainfall Analysis")

    subdivision = st.selectbox(
        "Select Subdivision",
        df["SUBDIVISION"].unique()
    )

    sub_df = df[df["SUBDIVISION"] == subdivision]

    st.subheader(f"Annual Rainfall Trend - {subdivision}")

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(sub_df["YEAR"], sub_df["ANNUAL"], marker="o")
    ax.set_xlabel("Year")
    ax.set_ylabel("Annual Rainfall (mm)")
    ax.set_title("Annual Rainfall Trend")
    ax.grid(True)
    st.pyplot(fig)

    st.subheader("Rainfall Category Distribution")

    category_count = df["Rainfall_Category"].value_counts()

    fig, ax = plt.subplots(figsize=(6, 4))
    ax.bar(category_count.index, category_count.values)
    ax.set_xlabel("Rainfall Category")
    ax.set_ylabel("Count")
    ax.set_title("Drought / Normal / Heavy Rainfall Count")
    st.pyplot(fig)

elif menu == "Forecasting":
    st.header("Subdivision-wise Rainfall Forecast")

    subdivision = st.selectbox(
        "Select Subdivision",
        forecast_df["SUBDIVISION"].unique()
    )

    sub_forecast = forecast_df[
        forecast_df["SUBDIVISION"] == subdivision
    ]

    st.dataframe(sub_forecast)

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(
        sub_forecast["YEAR"],
        sub_forecast["FORECAST_RAINFALL"],
        marker="o"
    )
    ax.set_xlabel("Year")
    ax.set_ylabel("Forecast Rainfall (mm)")
    ax.set_title(f"Rainfall Forecast 2018-2030 - {subdivision}")
    ax.grid(True)
    st.pyplot(fig)

elif menu == "Alert System":
    st.header("Rainfall Alert & Farmer Advisory System")

    subdivision = st.selectbox(
        "Select Subdivision",
        alert_df["SUBDIVISION"].unique()
    )

    sub_alert = alert_df[
        alert_df["SUBDIVISION"] == subdivision
    ]

    st.dataframe(
        sub_alert[
            [
                "SUBDIVISION",
                "YEAR",
                "FORECAST_RAINFALL",
                "Alert",
                "Farmer_Advisory"
            ]
        ]
    )

    st.subheader("Alert Distribution")

    alert_count = alert_df["Alert"].value_counts()

    fig, ax = plt.subplots(figsize=(7, 4))
    ax.bar(alert_count.index, alert_count.values)
    ax.set_xlabel("Alert Type")
    ax.set_ylabel("Count")
    ax.set_title("Forecast Alert Distribution")
    ax.tick_params(axis="x", rotation=20)
    st.pyplot(fig)

elif menu == "Project Summary":
    st.header("Project Summary")

    st.success("""
    ✔ Historical Rainfall Analysis Completed

    ✔ Rainfall Forecast Generated from 2018 to 2030

    ✔ Drought Detection System Implemented

    ✔ Heavy Rainfall Alert System Implemented

    ✔ Farmer Advisory Recommendations Generated

    ✔ Subdivision-wise Forecasting Completed for 36 Indian Regions
    """)

    st.subheader("Project Objective")

    st.write("""
    This system helps farmers, researchers, planners, and policymakers analyze
    rainfall patterns, forecast future rainfall, detect drought and heavy rainfall
    conditions, and support climate-informed agricultural decision making.
    """)