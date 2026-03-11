-- ============================================================
-- FAB INTELLIGENCE — SQL ANALYTICS SUITE
-- Semiconductor Yield & Cost Analysis Queries
-- Author: Keerthi RK | Dataset: SECOM (UCI ML Repository)
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- QUERY 1: Overall Yield Summary
-- Business: What is our baseline yield rate and failure count?
-- ─────────────────────────────────────────────────────────────
SELECT
    COUNT(*)                                        AS total_wafers,
    SUM(CASE WHEN label = -1 THEN 1 ELSE 0 END)    AS pass_wafers,
    SUM(CASE WHEN label =  1 THEN 1 ELSE 0 END)    AS fail_wafers,
    ROUND(
        100.0 * SUM(CASE WHEN label = -1 THEN 1 ELSE 0 END) / COUNT(*), 2
    )                                               AS yield_pct,
    ROUND(
        100.0 * SUM(CASE WHEN label =  1 THEN 1 ELSE 0 END) / COUNT(*), 2
    )                                               AS defect_rate_pct
FROM secom_wafers;


-- ─────────────────────────────────────────────────────────────
-- QUERY 2: Rolling Yield Rate — 50-Wafer Windows
-- Business: Are we trending up or down? Where are the yield dips?
-- ─────────────────────────────────────────────────────────────
WITH ranked AS (
    SELECT
        wafer_id,
        label,
        ROW_NUMBER() OVER (ORDER BY wafer_id)               AS seq,
        CAST(wafer_id AS INTEGER) / 50                      AS window_bucket
    FROM secom_wafers
),
window_stats AS (
    SELECT
        window_bucket,
        MIN(seq)                                            AS window_start,
        MAX(seq)                                            AS window_end,
        COUNT(*)                                            AS wafers_in_window,
        SUM(CASE WHEN label = -1 THEN 1 ELSE 0 END)        AS passes,
        SUM(CASE WHEN label =  1 THEN 1 ELSE 0 END)        AS failures,
        ROUND(
            100.0 * SUM(CASE WHEN label=-1 THEN 1 ELSE 0 END) / COUNT(*), 2
        )                                                   AS window_yield_pct
    FROM ranked
    GROUP BY window_bucket
)
SELECT
    window_bucket,
    window_start,
    window_end,
    wafers_in_window,
    passes,
    failures,
    window_yield_pct,
    CASE
        WHEN window_yield_pct >= 95 THEN 'GREEN — On Target'
        WHEN window_yield_pct >= 90 THEN 'YELLOW — Monitor'
        ELSE                              'RED — Yield Excursion'
    END                                                     AS yield_status
FROM window_stats
ORDER BY window_bucket;


-- ─────────────────────────────────────────────────────────────
-- QUERY 3: Revenue at Risk — Cost Impact Model
-- Business: What does the current defect rate cost per month?
-- Source: PatentPC 2025, SiliconAnalysts 2026
-- ─────────────────────────────────────────────────────────────
WITH defect_stats AS (
    SELECT
        COUNT(*)                                             AS total_wafers_analyzed,
        SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END)          AS total_failures,
        ROUND(100.0 * SUM(CASE WHEN label=1 THEN 1 ELSE 0 END) / COUNT(*), 4) AS defect_rate_pct
    FROM secom_wafers
),
cost_model AS (
    SELECT
        defect_rate_pct,
        -- Mature node (28nm-180nm): ~$3,000/wafer
        ROUND(5000 * 0.066 * 3000, 0)                       AS monthly_loss_mature_usd,
        -- Advanced node (7nm-3nm): ~$10,000/wafer
        ROUND(5000 * 0.066 * 10000, 0)                      AS monthly_loss_advanced_usd,
        -- Annual figures
        ROUND(5000 * 0.066 * 3000  * 12, 0)                 AS annual_loss_mature_usd,
        ROUND(5000 * 0.066 * 10000 * 12, 0)                 AS annual_loss_advanced_usd
    FROM defect_stats
)
SELECT
    defect_rate_pct                                         AS current_defect_rate_pct,
    monthly_loss_mature_usd                                 AS monthly_loss_mature_usd,
    monthly_loss_advanced_usd                               AS monthly_loss_advanced_usd,
    annual_loss_mature_usd                                  AS annual_loss_mature_usd,
    annual_loss_advanced_usd                                AS annual_loss_advanced_usd,
    -- Savings from 10% defect reduction
    ROUND(monthly_loss_mature_usd   * 0.10, 0)             AS savings_10pct_mature_monthly,
    ROUND(monthly_loss_advanced_usd * 0.10, 0)             AS savings_10pct_advanced_monthly
FROM cost_model;


-- ─────────────────────────────────────────────────────────────
-- QUERY 4: Failure Clustering — Are Failures Random or Batchy?
-- Business: Do failures come in bursts (equipment excursion) or
--           are they random (random defects)? Different root causes.
-- ─────────────────────────────────────────────────────────────
WITH sequences AS (
    SELECT
        wafer_id,
        label,
        ROW_NUMBER() OVER (ORDER BY wafer_id)                   AS seq,
        LAG(label)  OVER (ORDER BY wafer_id)                    AS prev_label,
        LEAD(label) OVER (ORDER BY wafer_id)                    AS next_label
    FROM secom_wafers
),
consecutive AS (
    SELECT
        wafer_id,
        label,
        seq,
        CASE WHEN label = 1 AND prev_label = 1 THEN 1 ELSE 0 END AS consecutive_fail
    FROM sequences
)
SELECT
    SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END)              AS total_failures,
    SUM(consecutive_fail)                                    AS consecutive_failures,
    ROUND(100.0 * SUM(consecutive_fail) /
          NULLIF(SUM(CASE WHEN label=1 THEN 1 ELSE 0 END),0),2) AS pct_failures_in_clusters,
    CASE
        WHEN 100.0 * SUM(consecutive_fail) /
             NULLIF(SUM(CASE WHEN label=1 THEN 1 ELSE 0 END),0) > 30
        THEN 'CLUSTERED — Likely equipment/process excursion'
        ELSE 'RANDOM — Likely random defect mechanisms'
    END                                                      AS failure_pattern
FROM consecutive;


-- ─────────────────────────────────────────────────────────────
-- QUERY 5: SPC Threshold Violation Report
-- Business: Which sensors have readings outside 3-sigma control limits?
--           These are candidates for immediate engineering review.
-- ─────────────────────────────────────────────────────────────
WITH sensor_stats AS (
    SELECT
        sensor_id,
        AVG(reading)                                         AS mean_reading,
        STDEV(reading)                                       AS std_reading,
        AVG(reading) - 3 * STDEV(reading)                   AS lcl,   -- Lower Control Limit
        AVG(reading) + 3 * STDEV(reading)                   AS ucl    -- Upper Control Limit
    FROM sensor_readings
    GROUP BY sensor_id
),
violations AS (
    SELECT
        sr.wafer_id,
        sr.sensor_id,
        sr.reading,
        ss.mean_reading,
        ss.lcl,
        ss.ucl,
        CASE
            WHEN sr.reading < ss.lcl THEN 'BELOW LCL'
            WHEN sr.reading > ss.ucl THEN 'ABOVE UCL'
            ELSE 'IN CONTROL'
        END                                                  AS spc_status,
        ROUND(ABS(sr.reading - ss.mean_reading) / NULLIF(ss.std_reading, 0), 2) AS sigma_distance
    FROM sensor_readings sr
    JOIN sensor_stats ss ON sr.sensor_id = ss.sensor_id
)
SELECT
    sensor_id,
    COUNT(*)                                                 AS total_readings,
    SUM(CASE WHEN spc_status != 'IN CONTROL' THEN 1 ELSE 0 END) AS violations,
    ROUND(100.0 * SUM(CASE WHEN spc_status != 'IN CONTROL' THEN 1 ELSE 0 END) / COUNT(*), 2) AS violation_rate_pct,
    ROUND(MAX(sigma_distance), 2)                            AS max_sigma_excursion
FROM violations
GROUP BY sensor_id
HAVING violation_rate_pct > 5   -- Flag sensors with >5% violation rate
ORDER BY violation_rate_pct DESC
LIMIT 20;
