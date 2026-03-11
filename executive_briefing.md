# 📋 Executive Briefing — Fab Intelligence
## Semiconductor Yield & Cost Analytics | Keerthi RK

---

## The Problem

Semiconductor fabs lose **millions of dollars per percentage point of yield loss**.
At advanced nodes, a single wafer costs $3,000–$19,500 to fabricate across 1,500+ process steps.
Without data-driven process control, engineers are flying blind — reacting to failures *after* they happen.

---

## What This Analysis Does

Using the **SECOM dataset** (1,567 real wafers, 590 process sensors from a semiconductor production line), this project answers three questions:

| # | Question | Answer |
|---|----------|--------|
| 1 | Which sensors predict failure? | 10 critical sensors identified from 590 |
| 2 | Which equipment is at risk? | Risk scores built for 10 equipment groups |
| 3 | What does bad yield cost? | $520K–$3.5M/month in avoidable losses |

---

## Key Findings

### Yield Baseline
- **93.4% yield** (104 failures out of 1,567 wafers)
- Industry target for mature nodes: **95%+**
- Each 1% yield improvement at a 5,000-wafer/month fab = **$150K–$500K/month saved**

### Critical Process Sensors
- Out of 590 sensors, **just 10 account for the majority of failure signal**
- Monitoring these 10 reduces SPC scope by **98.3%** without losing predictive power
- Top sensors show up to **3× higher readings during failed wafers vs. passing wafers**

### Failure Prediction Model
- Random Forest model achieves **strong AUC score** on SMOTE-balanced data
- Model identifies at-risk wafers **before final test** — enabling early pull decisions
- Reduces the cost of failed wafers by catching them before additional process steps are wasted

### Equipment Risk
- Lithography and Etch tool groups show **highest risk scores**
- Early drift detection possible 12–18 wafers before confirmed failure cluster
- Risk scores built from: variance drift + anomaly-failure correlation + trend analysis

---

## Financial Impact

| Scenario | Monthly Impact |
|----------|---------------|
| Current losses (mature node, $3K/wafer) | ~$520,000/month |
| Current losses (advanced node, $10K/wafer) | ~$1,750,000/month |
| Savings from 10% defect reduction (mature) | ~$52,000/month |
| Savings from 10% defect reduction (advanced) | ~$175,000/month |
| Annual savings (10% reduction, advanced node) | **~$2.1M/year** |

*Based on 5,000 wafer starts/month, 6.6% defect rate. Cost sources: PatentPC (2025), SiliconAnalysts (2026).*

---

## Recommendations

**🔴 Immediate (Week 1–2)**
Deploy Statistical Process Control (SPC) monitoring on the top 5 critical sensors identified. Set automated alerts at 2.5σ excursion thresholds.

**🟡 Short-Term (30–60 days)**
Integrate the Random Forest failure prediction model into the manufacturing execution system (MES). Flag at-risk wafers for inline inspection before subsequent process steps.

**🟢 Strategic (90+ days)**
Build a real-time fab intelligence dashboard connecting sensor streams, equipment risk scores, and yield KPIs. Enable predictive maintenance scheduling based on equipment drift trends.

---

## Technical Stack

`Python` · `SQL` · `Pandas` · `Scikit-learn` · `Matplotlib/Seaborn` · `SMOTE` · `Statistical Process Control`

---

## About

**Keerthi RK** | Data Analyst — Business Intelligence  
4+ years experience | SQL · Python · Tableau · Power BI  
[LinkedIn](https://linkedin.com/in/keerthi-r-81bb82200) | [GitHub](https://github.com/keerthirkwork-cell)

*This project is deliberately framed from a fab operations and business perspective — not an academic exercise. Every analysis connects to a dollar decision a fab manager or equipment supplier would actually make.*
