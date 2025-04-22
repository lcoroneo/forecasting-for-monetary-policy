% This code replicates Figure 1 of Coroneo, L., "Forecasting for monetary policy", 
% International Journal of Forecasting, 2025

clear, clc, close all

%% bank rate 
% source https://www.bankofengland.co.uk/boeapps/database/Bank-Rate.asp

filename = 'BankRate.xlsx';
dataTable = readtable(filename, 'VariableNamingRule', 'preserve', 'Range', 'A2');
dataTable.DateChanged = datetime(dataTable.DateChanged, 'InputFormat', 'dd MMM yy');
dataTable = sortrows(dataTable, 'DateChanged');
startDate = datetime(2004, 11, 1); % Start from November 2004
endDate = max(dataTable.DateChanged); % Last date in the dataset
endDate = max(dataTable.DateChanged);   % Last date in the dataset
rowDates = startDate:calquarters(1):endDate; % Quarterly end dates
quarterlyRates = interp1(dataTable.DateChanged, dataTable.Rate, rowDates, 'previous');

figure('Name','Bank Rate and Market Expectations');
subplot(2,1,1)
plot(rowDates, quarterlyRates, 'b-','LineWidth', 2);

%% market expectations
% source https://www.bankofengland.co.uk/monetary-policy-report/2024/november-2024
% https://www.bankofengland.co.uk/-/media/boe/files/monetary-policy-report/2024/november/mpr-november-2024-chart-slides-and-data.zip

filename = 'Market profiles.xlsx';
warning off;
data = readtable(filename, 'Sheet', 'data', 'VariableNamesRange', 'A1', 'RowNamesRange', 'A1');
data(:,1) =[];

% column dates
headers = data.Properties.VariableNames; % Extract column headers
headersCleaned = erase(headers, 'x01_'); % Remove the prefix 'x01_'
columnDates = datetime(headersCleaned, 'InputFormat', 'MMM_uuuu'); % Convert cleaned headers to datetime

% row dates
quarters = data.Properties.RowNames; % Extract row names (quarters, e.g., '2004Q4')
rowDates = datetime(quarters, 'InputFormat','uuuu''Q''Q'); % Convert to datetime
rowDates = dateshift(rowDates, 'end', 'quarter');

hold on;
for col = 1:size(data, 2)
    yData = data{:, col};
    plot(rowDates(2:end), yData(2:end), 'Color', [0.5, 0.5, 0.5, 0.3],'LineWidth', 1.5, 'DisplayName', string(columnDates(col))); 
end
hold off;

grid on;
xlabel('Date');
ylabel('Bank Rate (%)');

print('-bestfit','bank_rate','-dpdf');