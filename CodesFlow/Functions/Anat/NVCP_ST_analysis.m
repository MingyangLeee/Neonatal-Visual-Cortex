function [bin_mean,dis,p] = NVCP_ST_analysis(S_data,T_info,time_bin,method)
%% NVCP spaital-temporal analysis by repeated ANOVA (spatial) acorss time (temporal)
% S_data (subjects * areas matrix) containing subjects' data in different areas
% T_info: temporal information
num_area = size(S_data,2);
num_subj = size(S_data,1);
num_bin_sub = floor(num_subj/time_bin);
[a,b] = sort(T_info,'ascend');
n = 1;
for i = 1 : time_bin
    if i ~= time_bin
        bin_subid{i} = b(n : n + num_bin_sub - 1);
        bin_mean(i) = mean(T_info(bin_subid{i}));
        n = n + num_bin_sub;
    else
        bin_subid{i} = b(n : end);
        bin_mean(i) = mean(T_info(bin_subid{i}));
    end
end
switch method
    case 'ANOVA'
        for ai = 1 : time_bin
            rep_data = S_data(bin_subid{ai},:);
            ANOVA_subj = size(rep_data,1);
            ANOVA_x = rep_data(:);
            n = 1; group = []; subj = [];
            for i = 1 : size(S_data,2)
                group([n:n+ANOVA_subj-1],1) = i; 
                subj([n:n+ANOVA_subj-1],1) = 1:ANOVA_subj; 
                n = n + ANOVA_subj;
            end
            X = [ANOVA_x,group,subj];
            [MFE,dis(ai),p(ai)] = rm_anova1(X);
        end
    case 'STD'
        for ai = 1 : time_bin
            rep_data = S_data(bin_subid{ai},:);
            dis(ai) = mean(std(rep_data,0,1));
        end
        p = [];
    case 'T'
        for ai = 1 : time_bin
            rep_data = S_data(bin_subid{ai},:);
            [h,p(ai),ci,stats] = ttest(rep_data(:,1),rep_data(:,2));
            dis(ai) = stats.tstat;
        end
    case 'R'
        for ai = 1 : time_bin
            rep_data = S_data(bin_subid{ai},:);
            [dis(ai),p(ai)] = corr(rep_data(:,1),rep_data(:,2));
        end        
end
