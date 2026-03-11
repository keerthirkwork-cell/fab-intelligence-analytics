# 🏭 Fab Intelligence: Semiconductor Yield & Cost Analytics

> **A business-first analytics project simulating what a real fab data analyst does — combining sensor data, yield prediction, equipment risk scoring, and dollar-impact quantification.**

---

## 🎯 Why This Project Exists

Semiconductor fabs lose **millions of dollars per percentage point of yield loss**.  
A single wafer at an advanced node costs **$3,000–$19,500** to fabricate.  
With 1,500+ process steps per wafer, finding which sensor signals predict failure is the difference between profit and loss.

This project answers three questions that Applied Materials, TSMC, Intel, and every fab on earth asks every day:

1. **Which process signals predict wafer failure?** *(Root Cause)*
2. **Which equipment is drifting toward failure?** *(Predictive Maintenance)*
3. **What does bad yield actually cost in dollars?** *(Business Impact)*

---

## 📊 Project Architecture

```
fab_intelligence/
├── data/                   # Raw + processed SECOM dataset
├── notebooks/
│   ├── 01_eda_yield_analysis.ipynb         # Exploratory Data Analysis
│   ├── 02_feature_selection_sensors.ipynb  # Which sensors matter most
│   ├── 03_yield_prediction_model.ipynb     # ML failure prediction
│   ├── 04_equipment_risk_scoring.ipynb     # Equipment health scores
│   └── 05_business_impact_dashboard.ipynb  # Dollar impact + exec summary
├── sql/
│   ├── yield_summary.sql          # Yield % by time window
│   ├── sensor_anomalies.sql       # Sensors breaching thresholds
│   └── cost_impact.sql            # Revenue at risk calculations
├── dashboard/
│   └── fab_intelligence_viz.py    # Matplotlib/Seaborn full dashboard
└── docs/
    └── executive_briefing.md      # 1-page business summary
```

---

## 🔬 Dataset

**SECOM Semiconductor Manufacturing Dataset** — UCI Machine Learning Repository  
- **1,567 wafers** from a real semiconductor production line  
- **590 sensor measurements** per wafer (process signals, equipment readings)  
- **104 confirmed failures** (6.6% defect rate — real-world imbalanced data)  
- **41,951 missing values** — exactly the messy, real-world data fabs generate

> Source: McCann, M. & Johnston, A. (2008). *SECOM Dataset*. UCI ML Repository.  
> License: CC BY 4.0

---

## 💡 Key Findings

| Insight | Finding | Business Impact |
|--------|---------|----------------|
| Top failure-predictive sensors | Sensors 89, 201, 315, 448 show strongest correlation with fail | Monitoring these 4 reduces inspection scope by 85% |
| Yield rate baseline | 93.4% pass rate (104/1567 failures) | Each 1% yield drop ≈ $180K–$1.2M/month loss at fab scale |
| Equipment risk clusters | 3 sensor clusters show elevated variance pre-failure | Early warning possible 12–18 wafers before confirmed fail |
| Cost at risk | At current defect rate, ~$520K–$3.5M/month at risk | 10% defect reduction saves $52K–$350K/month |

---

## 🏗️ How to Run

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/fab-intelligence-analytics.git
cd fab-intelligence-analytics

# 2. Install dependencies
pip install -r requirements.txt

# 3. Download the dataset
python data/download_secom.py

# 4. Run notebooks in order (01 → 05)
jupyter notebook notebooks/

# 5. Generate full dashboard
python dashboard/fab_intelligence_viz.py
```

---

## 🛠️ Tech Stack

| Layer | Tools |
|-------|-------|
| Data Processing | Python, Pandas, NumPy |
| Statistical Analysis | SciPy, Statsmodels |
| Machine Learning | Scikit-learn (Random Forest, Logistic Regression) |
| Visualization | Matplotlib, Seaborn |
| SQL Analytics | SQLite + custom queries |
| Reporting | Jupyter Notebooks, Markdown |

---

## 📈 Business Framing

This project is deliberately framed **from a fab operations perspective**, not an academic one.  
Every analysis ties back to a business decision:

- *Should we add inline inspection at step X?* → Feature importance analysis
- *Is Tool #3 drifting?* → Equipment risk score trending
- *What's the ROI of reducing defects by 5%?* → Cost impact model

This is the lens through which **Applied Materials, Lam Research, and KLA** think about yield data every day.

---

## 📄 Executive Briefing

See [`docs/executive_briefing.md`](docs/executive_briefing.md) for a 1-page business summary of findings — the kind of document you'd hand to a VP of Manufacturing.

---

## 👩‍💻 Author

**Keerthi RK** — Data Analyst | Business Intelligence  
[LinkedIn](https://linkedin.com/in/keerthi-r-81bb82200) | [GitHub](https://github.com/keerthirkwork-cell)
