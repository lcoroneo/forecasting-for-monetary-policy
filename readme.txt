--------------------------------------------------------------------------

This folder contains data and Matlab code to replicate the results in 

Coroneo, L., "Forecasting for monetary policy", International Journal of Forecasting, 2025

--------------------------------------------------------------------------

The codes have been written Matlab R2024b Update 1 and require the following toolboxes

•   Signal Processing Toolbox

•   Statistics and Machine Learning Toolbox

--------------------------------------------------------------------------

CODES

•   bank_rate.m reproduces the Bank Rate and Market Expectations in Figure 1

•   comparison_naive.m reproduces the Bank of England forecast comparison with the two naïve benchmarks reported in Table 1 and Figures 2, 3 and 4

•   comparison_surveys.m reproduces the Bank of England forecast comparison with the survey forecasts reported in Figures 5


--------------------------------------------------------------------------

DATA:

•  BankRate.xlsx Official Bank Rate history in Figure 1. Source: https://www.bankofengland.co.uk/boeapps/database/Bank-Rate.asp

•  Market profiles.xlsx Market expectations in Figure 1. Source: https://www.bankofengland.co.uk/-/media/boe/files/monetary-policy-report/2024/november/mpr-november-2024-chart-slides-and-data.zip

•  Kanngiesser_Willems_dataset.xlsx Bank of England forecasts from Kanngiesser and Willems (2024). Source: https://www.bankofengland.co.uk/-/media/boe/files/working-paper/2024/forecast-accuracy-and-efficiency-at-boe-how-errors-leveraged-to-do-better-data-set.xlsx

•  Database_of_Average_Forecasts_for_the_UK_Economy.xlsx independent forecasts for the UK economy collected by HM Treasury in Figure 5. Source https://www.gov.uk/government/statistics/database-of-forecasts-for-the-uk-economy

--------------------------------------------------------------------------

AUXILIARY FUNCTIONS:

•   dm_fsa_cv: performs the tests for equal predictive accuracy as in Coroneoy and Iacone (2020)

•   NeweyWest.m: returns the Newey-West estimator of the long run variance matrix

--------------------------------------------------------------------------

LICENSE & CITATION

- Code license: MIT © 2025 Laura Coroneo
- Data: publicly available from BOE and HM Treasury (no additional license).  
- If you use this code in your work, please cite:**

  Coroneo, L. (2025). *Forecasting for monetary policy*. International Journal of Forecasting.
