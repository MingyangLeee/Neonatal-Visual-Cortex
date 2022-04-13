function [range,min_hm_std] = NVCP_Func_HMLVs(headmotion,numofvolume)
%% crop "numofvolume" volumes with lowest headmotion in the dataset
%%
plotid = 0;
time_window = 50;
%%
hm_est = [];
for i = 1 : size(headmotion,1)
% data range in the time window
    if i <= time_window/2
        range = 1 : time_window;
    elseif i > time_window/2 && i <= size(headmotion,1) - time_window/2
        range = i - time_window/2 + 1 : i + time_window/2;
    elseif i > size(headmotion,1) - time_window/2
        range = size(headmotion,1) - time_window + 1 : size(headmotion,1);
    end
% estimate the headmotion variation
    data = headmotion(range,:);
    hm_std = std(data,0,1);
    hm_est(i) = sum(hm_std);
end
%% crop 
for i = 1 : size(headmotion,1)
% data range in the time window
    if i <= numofvolume/2
        range = 1 : numofvolume;
    elseif i > numofvolume/2 && i <= size(headmotion,1) - numofvolume/2
        range = i - numofvolume/2 + 1 : i + numofvolume/2;
    elseif i > size(headmotion,1) - numofvolume/2
        range = size(headmotion,1) - numofvolume + 1 : size(headmotion,1);
    end
% estimate the headmotion variation
    data = hm_est(:,range);
    hm_crop(i) = sum(data)/numofvolume;
end
%%
[min_hm_std,i] = min(hm_crop);
if i <= numofvolume/2
    range = 1 : numofvolume;
elseif i > numofvolume/2 && i <= size(headmotion,1) - numofvolume/2
    range = i - numofvolume/2 + 1 : i + numofvolume/2;
elseif i > size(headmotion,1) - numofvolume/2
    range = size(headmotion,1) - numofvolume + 1 : size(headmotion,1);
end
if plotid == 1
    %% orignal plot
    subplot(3,1,1);
    x = 1 : size(headmotion,1);
    plot(x,headmotion);
    xlim([0 2300]);
    %% plot headmotion estimation
    subplot(3,1,2);
    plot(x,hm_est);
    xlim([0 2300]);
    %%
    subplot(3,1,3);
    plot(x,hm_crop);
    xlim([0 2300]);
    hold on
    plot(i,min_hm_std,'r*');
    hold on
    plot(range(1),hm_crop(range(1)),'ro');
    hold on
    plot(range(end),hm_crop(range(end)),'ro');
    xlim([0 2300]);
end