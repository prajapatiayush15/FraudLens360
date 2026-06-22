#  FraudLens360: Fraud Detection in Financial Transactions

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![PowerBI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures_&_KPIs-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-ML_Model-3776AB?style=flat-square&logo=python&logoColor=white)
![PowerPoint](https://img.shields.io/badge/PowerPoint-Presentation-B7472A?style=flat-square&logo=microsoftpowerpoint&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-22c55e?style=flat-square)

> **End-to-end fraud analytics pipeline on 1M+ synthetic mobile money transactions — combining SQL-based pattern identification, Power BI dashboards, and a Random Forest ML model (AUC 0.95) with SHAP explainability to surface fraud drivers and validate rule-based heuristics against an ML baseline.**

---

##  Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Key Insights](#key-insights)
- [ML Model Results](#ml-model-results)
- [Dashboard Preview](#dashboard-preview)
- [Getting Started](#getting-started)
- [Future Work](#future-work)
- [Author](#author)

---

##  Overview

Financial fraud costs institutions billions annually and remains one of the most critical challenges in the fintech space. **FraudLens360** is an end-to-end fraud analytics project built in two layers:

**Layer 1 — SQL & Power BI:** Rule-based fraud identification across 1M+ transactions using SQL pattern logic, DAX-powered KPIs, and interactive Power BI dashboards. This analysis revealed that the existing `isFlaggedFraud` system had a **0% detection rate** — failing to catch a single actual fraud case despite 1,142 confirmed fraud transactions.

**Layer 2 — ML Validation:** To address this gap, a Random Forest classifier was built and validated on 250K transactions, achieving **AUC 0.95 with 100% precision and 91% recall** — proving ML's clear superiority over rule-based flagging. SHAP explainability was applied to identify the top fraud drivers.

The project simulates a real-world fraud analytics workflow — from raw data exploration to ML model validation and executive-level dashboard storytelling.

---

##  Key Features

-  **Fraud Type Breakdown** — Categorized analysis of fraud by transaction type (Transfer, Cash Out, etc.)
-  **Time-Step Anomaly Detection** — Identifies unusual transaction behavior across time steps
-  **Flagging System Failure Analysis** — Quantified 0% detection rate of existing rule-based system
-  **Drillthrough Inspection** — Interactive Power BI drillthrough to inspect individual flagged transactions
-  **High-Risk User Identification** — Logic-based SQL rules to flag suspicious users and accounts
-  **Dynamic KPIs** — Slicer-driven metrics for fraud count, transaction type, and flag status
-  **ML Fraud Scoring** — Random Forest classifier with class-imbalance handling for real-time scoring
-  **SHAP Explainability** — Feature importance analysis identifying top fraud drivers
-  **Presentation Ready** — Final PowerPoint summarizing findings for non-technical stakeholders

---

##  Tech Stack

| Tool | Purpose |
|---|---|
| SQL (MySQL) | Data exploration, fraud rule logic, pattern detection |
| Power BI | Interactive dashboards, drillthrough, storytelling |
| DAX | Dynamic measures, calculated columns, KPIs |
| Python (scikit-learn, SHAP) | ML model development, evaluation & explainability |
| PowerPoint | Final presentation and business summary |

---

##  Project Structure

```
FraudLens360/
│
├── POWERBI_Dashboards/     # Dashboard .pbix files and screenshots
├── SQL_Analysis/           # SQL queries used for EDA and fraud detection
├── ML_Model/               # Random Forest notebook + evaluation plots
│   ├── FraudLens360_ML.ipynb
│   ├── fraud_model_evaluation.png
│   └── shap_feature_importance.png
├── PRESENTATION/           # Final project presentation (.pptx)
├── .gitignore              # Files excluded from Git
└── README.md               # Project documentation (this file)
```

---

##  Key Insights

-  **Fraud Concentration** — Fraudulent transactions were almost exclusively of type **Transfer** and **Cash Out**, with other types showing near-zero fraud rates
-  **High-Risk Time Steps** — Fraud activity spiked at Steps 22 & 66, suggesting coordinated or scripted attack patterns
-  **Flagging System Failure** — The existing `isFlaggedFraud` system had a **0% detection rate** — catching none of the 1,142 confirmed fraud cases, revealing a critical gap in rule-based detection
-  **High-Risk Users** — A small subset of origin accounts were responsible for a disproportionate share of fraudulent transactions
-  **Transaction Amount Patterns** — Fraudulent transactions tended to cluster around specific amount ranges, indicating possible threshold-based behavior by fraudsters

**Dashboard includes:**
- KPI cards for total transactions, fraud count, fraud rate, and flagged transactions
- Fraud breakdown by transaction type
- Time-step trend analysis
- Drillthrough page for flagged transaction details
- Slicer filters for dynamic exploration

---

##  ML Model Results

To address the 0% detection rate identified in the Power BI analysis, a supervised ML model was built as a validation layer.

| Metric | Score |
|---|---|
| AUC-ROC | 0.95 |
| Precision (Fraud) | 100% |
| Recall (Fraud) | 91% |
| F1 Score | 0.95 |

**Top fraud drivers identified via SHAP:**
1. `amount_to_orig_balance` — transaction amount disproportionate to account balance
2. `orig_balance_zeroed` — account completely drained in one transaction
3. `orig_balance_delta` — large sudden balance drop

These features align directly with the SQL patterns identified in Layer 1 — validating the rule-based heuristics with statistical rigor.

---

##  Getting Started

### Exploring the SQL Analysis
1. Import the dataset into **MySQL Workbench** or any MySQL client
2. Run the scripts in `SQL_Analysis/` sequentially
3. Scripts cover: data cleaning, EDA, fraud pattern queries, and high-risk user identification

### Viewing the Dashboard
1. Open **Power BI Desktop**
2. Load the `.pbix` file from `POWERBI_Dashboards/`
3. Use slicers to filter by fraud type, flag status, and transaction type
4. Right-click any flagged transaction to use the **Drillthrough** feature

### Running the ML Model
1. Open `ML_Model/FraudLens360_ML.ipynb` in Google Colab or Jupyter
2. Upload your PaySim CSV when prompted
3. Run all cells sequentially — installs dependencies automatically
4. Outputs: ROC curve, confusion matrix, and SHAP feature importance plot

### Viewing the Presentation
- Open the `.pptx` file in `PRESENTATION/` for a summarized business-friendly overview of findings

---

##  Future Work

- [x] Integrate a machine learning model (Random Forest, AUC 0.95) for predictive fraud scoring
- [x] Apply SHAP explainability to identify top fraud drivers
- [ ] Connect Power BI to a live MySQL database for real-time dashboard refresh
- [ ] Build an alerting system that flags high-risk transactions automatically
- [ ] Expand analysis to include network graph of suspicious user connections
- [ ] Test rule-based SQL logic against real-world financial datasets

---

##  Author

**Ayush Prajapati**

[![GitHub](https://img.shields.io/badge/GitHub-prajapatiayush15-181717?style=flat-square&logo=github)](https://github.com/prajapatiayush15)

---

##  Support

If you found this project useful, consider giving it a **star** ⭐ — it helps others discover it!
