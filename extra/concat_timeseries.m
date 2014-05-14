function [out_tot] = concat_timeseries(out_1,out_2,manip_flag,varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 02.21.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights


% manip_flag = what type of data manipulation should occur before
%              concatenation. 
%              Specify 0 to do nothing
%              Specify 1 to mean center each timeseries individually before
%              concatenation (to avoid mean signal differences between runs
%              driving association measures)
%              Specify 2 to zscore each timeseries individually before
%              concatenation (to additionally avoid higher variance
%              timeseries having a greater impact on association measures)
% We STRONGLY recommend against specifying 0, as this will likely have a
% strong (and differential by participant) impact on association measures

if ~isempty(varargin)
    num_cens_vols_1 = varargin{1};
    num_cens_vols_2 = varargin{2};
    max_num_cens_vols = varargin{3};
    max_vols = varargin{4};
    
    num_cens_vols_1(isnan(num_cens_vols_1)) = max_vols;
    num_cens_vols_2(isnan(num_cens_vols_2)) = max_vols;
    num_cens_vols_tot = num_cens_vols_1 + num_cens_vols_2;
    
    out_1.ts(logical(num_cens_vols_tot > max_num_cens_vols)) = {NaN};
    out_2.ts(logical(num_cens_vols_tot > max_num_cens_vols)) = {NaN};
end

nsubs = length(out_1.ts);

nROIs = size(out_1.ts{1},1);
count = 1;
while nROIs <= 1
    count = count+1;
    nROIs = size(out_1.ts{count},1);
end

if nsubs ~= length(out_2.ts)
    error('Timeseries must have the same number of participants')
end

for sub = nsubs:-1:1
    curr_ts1 = out_1.ts{sub};
    curr_ts2 = out_2.ts{sub};
    
    switch manip_flag
        case 1
            curr_ts1 = curr_ts1 - nanmean(curr_ts1(:));
            curr_ts2 = curr_ts2 - nanmean(curr_ts2(:));
        case 2
            curr_ts1 = (curr_ts1 - nanmean(curr_ts1(:)))./nanstd(curr_ts1(:));
            curr_ts2 = (curr_ts2 - nanmean(curr_ts2(:)))./nanstd(curr_ts2(:));
    end
    
    if size(curr_ts1,1) == 1 && size(curr_ts2,1) == 1
        out_tot.ts{sub} = NaN;
    elseif size(curr_ts1,1) == 1
        out_tot.ts{sub} = curr_ts2;
    elseif size(curr_ts2,1) == 1
        out_tot.ts{sub} = curr_ts1;
    else
        out_tot.ts{sub} = [curr_ts1,curr_ts2];
    end
end

if isfield(out_1,'subs')
    out_tot.subs = out_1.subs;
end
if isfield(out_1,'ROI_labels')
    out_tot.ROI_labels = out_1.ROI_labels;
end
if isfield(out_1,'nROI')
    out_tot.nROI = out_1.nROI;
end
if isfield(out_1,'num_censored_vols') && isfield(out_2,'num_censored_vols')
    out_tot.num_censored_vols = out_1.num_censored_vols + out_2.num_censored_vols;
end
if isfield(out_1,'num_censored_vols_DVARS') && isfield(out_2,'num_censored_vols_DVARS')
    out_tot.num_censored_vols_DVARS = out_1.num_censored_vols_DVARS + out_2.num_censored_vols_DVARS;
end
if isfield(out_1,'num_censored_vols_FD') && isfield(out_2,'num_censored_vols_FD')
    out_tot.num_censored_vols_FD = out_1.num_censored_vols_FD + out_2.num_censored_vols_FD;
end
if isfield(out_1,'mean_DVARS') && isfield(out_2,'mean_DVARS')
    out_tot.mean_DVARS = out_1.mean_DVARS + out_2.mean_DVARS;
end
if isfield(out_1,'mean_FD') && isfield(out_2,'mean_FD')
    out_tot.mean_FD = out_1.mean_FD + out_2.mean_FD;
end
if isfield(out_1,'GCOR') && isfield(out_2,'GCOR')
    out_tot.GCOR = out_1.GCOR + out_2.GCOR;
end
