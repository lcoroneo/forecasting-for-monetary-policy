---------------------------------------------
# Replication Package for  Coroneo, L., "Forecasting for monetary policy", International Journal of Forecasting, 2025

---------------------------------------------

## 1. Package Assembly
- **Date assembled:** April 22, 2025  
- **Author(s):** Laura Coroneo  
- **Contact:** laura.coroneo@york.ac.uk  

## 2. Repository Structure  
All files are located in the root directory of the repository:
```text
├── bank_rate.m                         # MATLAB script for Figure 1
├── comparison_naive.m                  # MATLAB script for Table 1 & Figures 2–4
├── comparison_surveys.m                # MATLAB script for Figure 5
├── dm_fsa_cv.m                         # Auxiliary: Diebold–Mariano tests
├── NeweyWest.m                         # Auxiliary: Newey–West estimator
├── BankRate.xlsx                       # Raw data: Official Bank Rate history
├── Market profiles.xlsx                # Raw data: Market expectations
├── Kanngiesser_Willems_dataset.xlsx    # Raw data: BOE forecasts from Kanngiesser & Willems (2024)
├── Database_of_Average_Forecasts_for_the_UK_Economy.xlsx  # Raw data: Independent UK forecasts
├── LICENSE                             # MIT License
└── README.md                           # This file
```



## 3. Computing Environment
- **Operating System:** Windows 11 Enterprise (Version 23H2, 64‑bit)
- **Processor:** 12th Gen Intel® Core™ i7‑1255U @ 1.70 GHz
- **Installed RAM:** 32 GB
- **MATLAB Version:** R2024b Update 1  
- **Required Toolboxes:**  
  - Signal Processing Toolbox (v9.9)  
  - Statistics and Machine Learning Toolbox (v14.0)  
- **License:** MIT License (see `LICENSE`)  
- **Dependencies:** None beyond MATLAB and listed toolboxes.  
- **Runtime:** ~5 minutes (end‑to‑end execution of all three scripts) on the above machine

## 4. Data Sources & Access  
All data files are included in the root folder as Excel (`.xlsx`) files. They are public and can be downloaded from:

- **BankRate.xlsx**: Official Bank Rate history (Figure 1). Source: https://www.bankofengland.co.uk/boeapps/database/Bank-Rate.asp  
- **Market profiles.xlsx**: Market expectations (Figure 1). Source: https://www.bankofengland.co.uk/-/media/boe/files/monetary-policy-report/2024/november/mpr-november-2024-chart-slides-and-data.zip  
- **Kanngiesser_Willems_dataset.xlsx**: BOE forecasts from Kanngiesser & Willems (2024). Source: https://www.bankofengland.co.uk/-/media/boe/files/working-paper/2024/forecast-accuracy-and-efficiency-at-boe-how-errors-leveraged-to-do-better-data-set.xlsx  
- **Database_of_Average_Forecasts_for_the_UK_Economy.xlsx**: Independent UK forecasts (Figure 5). Source: https://www.gov.uk/government/statistics/database-of-forecasts-for-the-uk-economy  

## 5. Usage Instructions
1. **Ensure** all `.m` scripts and `.xlsx` data files are in the same folder.  
2. **Run** each analysis script in MATLAB:
   ```matlab
   bank_rate;           % Generates Figure 1
   comparison_naive;    % Generates Table 1 & Figures 2–4
   comparison_surveys;  % Generates Figure 5

## 6. Code Overview

- **bank_rate.m**	Reproduce Bank Rate and market expectations (Fig 1)
- **comparison_naive.m**	BOE vs naïve benchmarks (Table 1 & Figs 2–4)
- **comparison_surveys.m**	BOE vs survey forecasts (Fig 5)
- **dm_fsa_cv.m**	Diebold–Mariano tests (Auxiliary)
- **NeweyWest.m**	Newey–West variance estimator (Auxiliary)

## 7. License & Citation
Code license: MIT © 2025 Laura Coroneo

Data: publicly available from BOE and HM Treasury (no license needed).

If you use this code in your work, please cite:

**Coroneo, L. (2025). Forecasting for monetary policy. International Journal of Forecasting.**
