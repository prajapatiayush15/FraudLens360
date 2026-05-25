#  FraudLens360: Fraud Detection in Financial Transactions

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![PowerBI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Measures_&_KPIs-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![PowerPoint](https://img.shields.io/badge/PowerPoint-Presentation-B7472A?style=flat-square&logo=microsoftpowerpoint&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-22c55e?style=flat-square)

> **Analyzing synthetic mobile money transaction data to detect fraudulent activities using SQL, Power BI, and DAX — surfacing fraud patterns, high-risk users, and transaction anomalies.**
---

##  Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Key Insights](#key-insights)
- [Dashboard Preview](#dashboard-preview)
- [Getting Started](#getting-started)
- [Future Work](#future-work)
- [Author](#author)

---

##  Overview

Financial fraud costs institutions billions annually and remains one of the most critical challenges in the fintech space. **FraudLens360** is an end-to-end fraud detection and analysis project that combines **SQL-based rule logic**, **interactive Power BI dashboards**, and **DAX-powered KPIs** to identify suspicious transaction patterns in synthetic mobile money data.

The project simulates a real-world fraud analytics workflow — from raw data exploration to executive-level dashboard storytelling.

---

##  Key Features

-  **Fraud Type Breakdown** — Categorized analysis of fraud by transaction type (Transfer, Cash Out, etc.)
-  **Time-Step Anomaly Detection** — Identifies unusual transaction behavior across time steps
-  **Drillthrough Inspection** — Interactive Power BI drillthrough to inspect individual flagged transactions
-  **High-Risk User Identification** — Logic-based SQL rules to flag suspicious users and accounts
-  **Dynamic KPIs** — Slicer-driven metrics for fraud count, transaction type, and flag status
-  **Reproducible SQL Queries** — Clean, documented SQL scripts for all analysis steps
-  **Presentation Ready** — Final PowerPoint summarizing findings for non-technical stakeholders

---

##  Tech Stack

| Tool | Purpose |
|---|---|
| SQL (MySQL) | Data exploration, fraud rule logic, pattern detection |
| Power BI | Interactive dashboards, drillthrough, storytelling |
| DAX | Dynamic measures, calculated columns, KPIs |
| PowerPoint | Final presentation and business summary |

---

##  Project Structure

```
FraudLens360/
│
├── POWERBI_Dashboards/     # Dashboard .pbix files and screenshots
├── SQL_Analysis/           # SQL queries used for EDA and fraud detection
├── PRESENTATION/           # Final project presentation (.pptx)
├── .gitignore              # Files excluded from Git
└── README.md               # Project documentation (this file)
```

---

##  Key Insights

> 

-  **Fraud Concentration** — Fraudulent transactions were almost exclusively of type **Transfer** and **Cash Out**, with other types showing near-zero fraud rates
-  **High-Risk Time Steps** — Fraud activity spiked at specific time steps, suggesting coordinated or scripted attack patterns
-  **Flagged vs Actual Fraud** — A significant gap was found between transactions flagged by the system (`isFlaggedFraud`) and actual fraud (`isFraud`), revealing limitations in the existing rule-based flagging system
-  **High-Risk Users** — A small subset of origin accounts were responsible for a disproportionate share of fraudulent transactions
-  **Transaction Amount Patterns** — Fraudulent transactions tended to cluster around specific amount ranges, indicating possible threshold-based behavior by fraudsters

---

**Dashboard includes:**
- KPI cards for total transactions, fraud count, fraud rate, and flagged transactions
- Fraud breakdown by transaction type
- Time-step trend analysis
- Drillthrough page for flagged transaction details
- Slicer filters for dynamic exploration

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

### Viewing the Presentation
- Open the `.pptx` file in `PRESENTATION/` for a summarized business-friendly overview of findings

---

##  Future Work

- [ ] Integrate a machine learning model (e.g. Random Forest, XGBoost) for predictive fraud scoring
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

If you found this project useful, consider giving it a **star** — it helps others discover it!

---
