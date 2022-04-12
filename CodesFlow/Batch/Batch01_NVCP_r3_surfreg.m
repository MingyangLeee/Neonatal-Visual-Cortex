%% apply reg to surface metrix
clear;
load('~/SubInfo.mat');
parfor subi = 1 : length(subinfo)
    NVCP_MSMALL_applyreg_r3_dhcp(subi);
end