# Supply Chain Profit Analysis & Forecasting

## Project Overview
This project focuses on analyzing supply chain profitability across markets and regions using SQL, Python, and Excel. It combines exploratory data analysis (EDA), KPI-driven SQL analytics, and predictive modeling to uncover profit trends, evaluate year-over-year (YoY) performance, and forecast future profitability. Insights are presented through an interactive Excel dashboard and reproducible SQL scripts.

## Project Objectives
- Analyze profit performance by market and region
- Identify high-performing and stable regions using KPI metrics
- Measure year-over-year (YoY) profit changes
- Evaluate product-level profitability and consistency
- Build predictive models for regional profit forecasting
- Present insights through an interactive dashboard

## Repository Structure
.
├── Work_File.ipynb
├── dashboard.xlsx
├── sql/
│ └── KPI_Code.sql
├── incom2024_delay_example_dataset.csv
├── incom2024_delay_variable_description.csv
└── dataset_pgadmin_ready.csv

## Files Description

### Notebook
**Work_File.ipynb**  
Primary analysis notebook that:
- Loads and preprocesses raw data
- Performs exploratory data analysis (EDA)
- Trains machine learning models (Linear Regression, Decision Tree)
- Generates profit predictions  

Key objects include: `df`, `lr_model1`, `tree_model1`, `predict_profit_region`

### Dashboard
**dashboard.xlsx**  
Interactive Excel dashboard providing:
- Total profit and profit margin KPIs
- Profit analysis by market and region
- Year-over-year growth trends
- Forecasted profit insights

### SQL KPIs
**sql/KPI_Code.sql**  
Contains SQL queries addressing key business problems, including:
- Top regions and markets by average profit per order
- Profit stability and volatility analysis
- Year-over-year regional profitability changes
- Region performance index vs global average
- Market profit trend index
- Top and bottom products by profit (2018)
- Product profit consistency across markets  

All SQL queries are written for **PostgreSQL** and are dashboard-ready.

### Data
- **incom2024_delay_example_dataset.csv** — Original raw dataset  
- **incom2024_delay_variable_description.csv** — Data dictionary and variable definitions  
- **dataset_pgadmin_ready.csv** — Dataset prepared for PostgreSQL ingestion (if used)

## Tools & Technologies
- Python (pandas, numpy, matplotlib, seaborn, scikit-learn)
- SQL (PostgreSQL)
- Excel (Dashboard & KPIs)
- Jupyter Notebook / VS Code
- PostgreSQL / pgAdmin / DBeaver

## Requirements
Install the required Python libraries:
```sh
pip install pandas numpy matplotlib seaborn scikit-learn sqlalchemy psycopg2-binary
```
## Author
**Muhammad Arslan Arshad**
