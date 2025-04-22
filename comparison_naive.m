% This code replicates Table 1 and Figures 2, 3 and 4 of Coroneo, L., 
% "Forecasting for monetary policy", International Journal of Forecasting, 2025
 
clear, clc, close all

%% Load Data
TT = readtable('Kanngiesser_Willems_dataset.xlsx', 'Sheet', 'data');
hh = [0 1 2 4 8 12];

date_st = datetime([2014 1 1]);
date_mid = datetime([2018 12 31]);
date_end = datetime([2023 12 31]);

%% Construct RW and AR(p) benchmarks

% Initialize RW forecast columns in TT
for h = 1:length(hh)
    TT.(['RW_f', num2str(hh(h))]) = NaN(size(TT, 1), 1);
end

% Initialize AR forecast columns in TT
for h = 1:length(hh)
    TT.(['AR_f', num2str(hh(h))]) = NaN(size(TT, 1), 1);
end

% Rolling window AR(p) estimation
window_size = 60;  
for t = window_size : size(TT, 1) - max(hh)- 1
    % Rolling window data
    window_data = TT.cpi_data(t - window_size + 1:t);

    % Find the best lag order based on AIC
    best_aic = inf;
    best_p = 0;
    for p = 1:4 % Max AR lag

        model = arima('ARLags', 1:p, 'Distribution', 'Gaussian');
        try
            [~,~,logL] = estimate(model, window_data, 'Display', 'off');
            aic = aicbic(logL, p + 2);
        catch ME
            warning('AR model with p = %d could not be estimated: %s', p, ME.message);
            aic = inf;
        end
        if aic < best_aic
            best_aic = aic;
            best_p = p;
        end
    end

    best_model = arima('ARLags', 1:best_p, 'Distribution', 'Gaussian');
    est_model = estimate(best_model, window_data, 'Display', 'off');

    % Generate forecasts for the specified horizons and store in TT
    for h = 1:length(hh)
        [prediction, ~] = forecast(est_model, hh(h) + 1, 'Y0', window_data);
        TT.(['AR_f', num2str(hh(h))])(t + hh(h) + 1) = prediction(end);
        TT.(['RW_f', num2str(hh(h))])(t + hh(h) + 1) = window_data(end);
    end
end

method = {'BoE', 'RW', 'AR'};
markerlist = {'o';'d';'+';'_'};

%% Select sample

Sample = {'Full ', 'First sub-', 'Second sub-'};
for ss = 1:length(Sample)
    sample = Sample{ss};
    tit = [];

    % Select the appropriate sample period
    if strcmp(sample, 'Full ')
        T = TT(TT.date > date_st & TT.date <= date_end, :);
    elseif strcmp(sample, 'First sub-')
        T = TT(TT.date > date_st & TT.date <= date_mid, :);
    elseif strcmp(sample, 'Second sub-')
        T = TT(TT.date > date_mid & TT.date <= date_end, :);
    end

    if ss>1
        disp('-----------------------------------------------------------');
        disp(['TABLE 1: ', Sample{ss},'sample (', datestr(T.date(1)), ' - ', ...
            datestr(T.date(end)), '), N=', num2str(size(T, 1))]);
        disp('-----------------------------------------------------------');
    end

    data = T.cpi_data;
    boe_forecasts = T{:, contains(T.Properties.VariableNames, 'inf')};
    rw_forecasts = T{:, contains(T.Properties.VariableNames, 'RW')};
    ar_forecasts = T{:, contains(T.Properties.VariableNames, 'AR')};

    forecasts = [boe_forecasts, rw_forecasts, ar_forecasts];

    %% Compute Forecast Errors
    e = data - forecasts;  % Errors: first hh columns are BOE, next are RW, last are AR

    %% Plotting Forecasts and Forecast Errors
    if ss == 1
        selected_hh = [1, 4, 8, 12];

        % Plotting Forecasts
        figure('Name','UK CPI inflation forecasts');
        for i = 1:length(selected_hh)
            h_idx = find(hh == selected_hh(i));

            subplot(2, 2, i);
            plot(T.date, data, 'k', 'LineWidth', 2.5); hold on;
            plot(T.date, boe_forecasts(:, h_idx), '-b', 'LineWidth', 1,'Marker','x'); hold on;
            plot(T.date, rw_forecasts(:, h_idx),'--r' , 'LineWidth', 1.5);
            plot(T.date, ar_forecasts(:, h_idx), '-.k', 'LineWidth', 1.5);
            xline(date_mid, 'k', 'LineWidth', 2);
            hold off;
            if selected_hh(i)==1
                title(['Horizon: ', num2str(selected_hh(i)), ' quarter']);
            else
                title(['Horizon: ', num2str(selected_hh(i)), ' quarters']);
            end
            xlabel('Date');
            ylabel('Forecast / Realised');
            datetick('x', 'yyyy');
            xlim([T.date(1) T.date(end)]);
            ylim([-0.2 13.5]);
            grid on;
            if i==1
                legend1 = legend('Data', 'BoE', 'RW', 'AR', 'AutoUpdate','off','Orientation','horizontal');
                set(legend1, 'Position',[0.40319664626177 0.0142700329308452 0.230657520404897 0.0412827485155648]);
            end
        end
        print('-bestfit','forecasts','-dpdf');

        % Plotting Forecast Errors
        figure('Name','Forecast errors');
        for i = 1:length(selected_hh)
            h_idx = find(hh == selected_hh(i));

            subplot(2, 2, i);
            plot(T.date, e(:, h_idx), '-b', 'LineWidth', 1,'Marker','x'); hold on;
            plot(T.date, e(:, h_idx + length(hh)),'--r' , 'LineWidth', 1.5);
            plot(T.date, e(:, h_idx + 2 * length(hh)), '-.k', 'LineWidth', 1.5);

            xline(date_mid, 'k', 'LineWidth', 2);
            yline(0, 'k-', 'LineWidth', 1.5);
            hold off;
            if selected_hh(i)==1
                title(['Horizon: ', num2str(selected_hh(i)), ' quarter']);
            else
                title(['Horizon: ', num2str(selected_hh(i)), ' quarters']);
            end
            ylabel('Forecast Error');
            xlabel('Date');
            datetick('x', 'yyyy');
            xlim([T.date(1) T.date(end)]);
            ylim([-6 10.5]);
            grid on;
            if i==1
                legend1 =      legend('BoE', 'RW', 'AR', 'AutoUpdate','off','Orientation','horizontal');

                set(legend1, 'Position',[0.379753567319073 0.0148553599940293 0.254296872171108 0.031967212357482]);
            end
        end
        print('-bestfit','errors','-dpdf');
    end


    %% Table 1: Summary Statistics for Forecast Errors
    tab = [mean(e); median(e); mean(abs(e)); median(abs(e));std(e); max(e); min(e); skewness(e);...
        diag(corr(e(2:end,:),e(1:end-1,:)))'; diag(corr(e(5:end,:),e(1:end-4,:)))'];

    if ss>1
        for s= 1:3
            printmat(tab(:,(s-1)*length(hh)+1:s*length(hh) )', method{s},num2str(hh) ,...
                'Mean Median MAE MdAE Std Max Min Skew AC1 AC4');
        end
    end

    Bench = {'RW', 'AR'};

    aa = 0.5; bb = 1;    % Linex function coefficients

    for b =1:2
        bench = method{b+1};

        %% Compute Loss
        Loss = {'MSE', 'MAE', 'LINEXp', 'LINEXm'};

        for ll = 1:length(Loss)
            loss = Loss{ll};
            LL = [];

            if strcmp(loss, 'MSE')
                L = e.^2;
            elseif strcmp(loss, 'MAE')
                L = abs(e);
            elseif strcmp(loss, 'LINEXp')
                L = bb * (exp(aa .* e) - aa .* e - 1);
            elseif strcmp(loss, 'LINEXm')
                L = bb * (exp(-aa .* e) + aa .* e - 1);
            end

            if strcmp(loss, 'MSE')
                LL = [LL sqrt(mean(L', 2))];
            else
                LL = [LL mean(L', 2)];
            end

            for h=1:size(hh,2)
                loss_table(ll,:,h) = LL(h:size(hh,2):end)';
            end

            %% Loss Differential and DM Test
            for h = 1:length(hh)
                d(:, h) = L(:, h) - L(:, length(hh)*b + h);
                [test((ll - 1) * 2 + 1:(ll - 1) * 2 + 2, h), cv(:, :, h), reject((ll - 1) * 2 + 1:(ll - 1) * 2 + 2, h)] = dm_fsa_cv(d(:, h));
            end
        end

        d =[];

        %% Figure 4: Forecast Evaluation
        if b==1 && ss==1
            figure('Name','Forecast evaluation');
        end

        subplot(2,3,(b-1)*3+ss)

        toplot = test(1:2:end,:);
        for i=1:size(toplot,1)
            plot([1:length(hh)]',toplot(i,:), markerlist{i},'MarkerSize',6,'LineWidth',2); hold on
        end
        if (ss-1)*2+b==4
            legend1 = legend('MSE','MAE ', 'LINEXp ','LINEXm ','AutoUpdate','off','Orientation','horizontal');
            set(legend1, 'Position',[0.366666666666667 0.0021953896816685-0.015 0.297905159466181 0.0581778265642153]);
        end
        plot(0:length(hh)+1,zeros(length(hh)+2,1),'k');
        plot(0:length(hh)+1, kron([-cv(1,2,1) cv(1,2,1)],ones(length(hh)+2,1)),':r');
        hold on
        plot(0:length(hh)+1, kron([-cv(1,3,1) cv(1,3,1)],ones(length(hh)+2,1)),'--r');
        xlim([0 length(hh)+1]);
        ylim([-6 4]);
        title([sample,'sample, vs. ',bench]);
        xticks(1:length(hh));
        xticklabels(hh);
        xlabel('Horizon');
        ylabel('DM Test');
    end

end

print('-bestfit','test','-dpdf');