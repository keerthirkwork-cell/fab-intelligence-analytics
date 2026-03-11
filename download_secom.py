"""
download_secom.py
-----------------
Downloads the SECOM semiconductor dataset from UCI ML Repository
and saves it locally for analysis.
"""

import os
import pandas as pd
from ucimlrepo import fetch_ucirepo

def download_secom():
    print("Downloading SECOM dataset from UCI ML Repository...")
    print("Dataset: Semiconductor Manufacturing Process Data")
    print("Source: McCann & Johnston (2008), UCI ML Repository #179")
    print("-" * 55)

    secom = fetch_ucirepo(id=179)

    X = secom.data.features   # 1567 x 590 sensor readings
    y = secom.data.targets     # pass (-1) / fail (1) labels

    # Rename label column for clarity
    y = y.copy()
    y.columns = ["label"]
    y["label_text"] = y["label"].map({-1: "PASS", 1: "FAIL"})

    # Save raw files
    os.makedirs("data", exist_ok=True)
    X.to_csv("data/secom_features.csv", index=False)
    y.to_csv("data/secom_labels.csv", index=False)

    # Save combined file
    df = pd.concat([X, y], axis=1)
    df.to_csv("data/secom_combined.csv", index=False)

    print(f"✅ Features shape : {X.shape}  (wafers x sensors)")
    print(f"✅ Labels shape   : {y.shape}")
    print(f"✅ PASS wafers    : {(y['label'] == -1).sum()} ({(y['label'] == -1).mean()*100:.1f}%)")
    print(f"✅ FAIL wafers    : {(y['label'] ==  1).sum()} ({(y['label'] ==  1).mean()*100:.1f}%)")
    print(f"✅ Missing values : {X.isna().sum().sum():,}")
    print()
    print("Files saved to /data:")
    print("  secom_features.csv  — 590 sensor columns")
    print("  secom_labels.csv    — pass/fail labels")
    print("  secom_combined.csv  — merged, ready for analysis")

if __name__ == "__main__":
    download_secom()
