% This code replicates Figure 5 of Coroneo, L., "Forecasting for monetary policy", 
% International Journal of Forecasting, 2025


clear, clc, close all

%% Load Data
TT = readtable('Kanngiesser_Willems_dataset.xlsx', 'Sheet', 'Data');
hh = [0 1 2 4 8 12];

%% Load external forecasts

T = readtable('Database_of_Average_Forecasts_for_the_UK_Economy.xlsx', 'Sheet','CPI', 'VariableNamingRule', 'preserve');
T.CPI = datetime(T.CPI, 'InputFormat', 'MMM-yy');

augRows = T(month(T.CPI) == 8, :);
mayRows = T(month(T.CPI) == 5, :);
novRows = T(month(T.CPI) == 11, :);

EF_f1 = diag(table2array(augRows(:, vartype('numeric'))));
dates_EF_f1 = augRows.CPI+ calmonths(4);
table_EF_f1 = table(dates_EF_f1, EF_f1, 'VariableNames', {'Time', 'EF_f1'});

EF_f2 = diag(table2array(mayRows(:, vartype('numeric'))));
dates_EF_f2 = mayRows.CPI+ calmonths(7);
table_EF_f2 = table(dates_EF_f2, EF_f2, 'VariableNames', {'Time', 'EF_f2'});

EF_f4 = diag(table2array(novRows(:, vartype('numeric'))),1);
dates_EF_f4 = novRows.CPI+  calmonths(13);
table_EF_f4 = table(dates_EF_f4, EF_f4, 'VariableNames', {'Time', 'EF_f4'});

EF1_Table = outerjoin(table_EF_f1,table_EF_f2, 'Keys', 'Time', 'MergeKeys', true);
EF_Table = outerjoin(EF1_Table, table_EF_f4, 'Keys', 'Time', 'MergeKeys', true);
selected_hh = [1 2 4];

%% merge and common sample
date_st = datetime([2004 1 1]);
date_end = datetime([2023 12 31]);

TT.Time = TT.date; TT.date = []; TT = movevars(TT, 'Time', 'Before', 3);
mergedTT = outerjoin(TT, EF_Table, 'Keys', 'Time', 'MergeKeys', true);

T1 = mergedTT(mergedTT.Time > date_st & mergedTT.Time <= date_end, :);

T1 = T1(~any(ismissing(T1), 2), :);

%% Data, Forecasts and Forecast Errors

data = T1.cpi_data;

patterns = strcat("inf_f", string(selected_hh));
matching_vars = false(size(T1.Properties.VariableNames));
for pattern = patterns
    matching_vars = matching_vars | strcmp(T1.Properties.VariableNames, pattern);
end
boe_forecasts = T1{:, matching_vars};

ef_forecasts = T1{:, contains(T1.Properties.VariableNames, 'EF')};

forecasts = [boe_forecasts, ef_forecasts];

e = data - forecasts;  % e < 0 underprediction


%% Plotting Forecasts and Forecast Errors

% Plotting Forecasts
figure('Name', 'Comparison with Survey Forecasts');
for i = 1:length(selected_hh)
    subplot(2, 2, i);

    plot(T1.Time, data, 'k', 'LineWidth', 2.5); hold on;
    plot(T1.Time, boe_forecasts(:, i), '-b', 'LineWidth', 1,'Marker','x');
    plot(T1.Time, ef_forecasts(:, i),'--r' , 'LineWidth', 1.5);
    hold off;
    if selected_hh(i)==1
        title(['Horizon: ', num2str(selected_hh(i)), ' quarter']);
    else
        title(['Horizon: ', num2str(selected_hh(i)), ' quarters']);
    end

    xlabel('Date');
    ylabel('Forecast / Realised');

    legend('Data', 'BoE Forecast', 'Survey Forecast', 'Location', 'northwest');

    datetick('x', 'yyyy');
    ylim([-0.2 13.5]);
    xlim([T1.Time(1) T1.Time(end)]);
    grid on;
end

%% Compute Loss
Loss = {'MSE', 'MAE', 'LINEXp', 'LINEXm'};
a = 0.5; b = 1;    % Linex function coefficients

for ll = 1:length(Loss)
    loss = Loss{ll};
    LL = [];

    if strcmp(loss, 'MSE')
        L = e.^2;
    elseif strcmp(loss, 'MAE')
        L = abs(e);
    elseif strcmp(loss, 'LINEXp')
        L = b * (exp(a .* e) - a .* e - 1);
    elseif strcmp(loss, 'LINEXm')
        L = b * (exp(-a .* e) + a .* e - 1);
    end

    if strcmp(loss, 'MSE')
        LL = [LL sqrt(mean(L', 2))];
    else
        LL = [LL mean(L', 2)];
    end

    %% Loss Differential and Test
    for h = 1:length(selected_hh)
        d(:, h) = L(:, h) - L(:, h+length(selected_hh));
        [test((ll - 1) * 2 + 1:(ll - 1) * 2 + 2, h), cv(:, :, h), reject((ll - 1) * 2 + 1:(ll - 1) * 2 + 2, h)] = dm_fsa_cv(d(:, h));
    end
end


markerlist = {'o';'d';'+';'_'};
subplot(2,2,4)

toplot = test(1:2:end,:);
for i=1:size(toplot,1)
    plot([1:length(selected_hh)]',toplot(i,:), markerlist{i},'MarkerSize',6,'LineWidth',2); hold on
end

legend1 = legend('MSE','MAE ', 'LINEXp ','LINEXm ','AutoUpdate','off','Orientation','vertical','Location','northeast');

plot(0:length(selected_hh)+1,zeros(length(selected_hh)+2,1),'k');
plot(0:length(selected_hh)+1, kron([-cv(1,2,1) cv(1,2,1)],ones(length(selected_hh)+2,1)),':r');
hold on
plot(0:length(selected_hh)+1, kron([-cv(1,3,1) cv(1,3,1)],ones(length(selected_hh)+2,1)),'--r');
xlim([0 length(selected_hh)+1]);
title('BoE vs. Surveys');
xticks(1:length(selected_hh));
xticklabels(selected_hh);
ylim([-3 3]);
xlabel('Horizon');
ylabel('DM Test');
print('-bestfit','forecast_ef','-dpdf');