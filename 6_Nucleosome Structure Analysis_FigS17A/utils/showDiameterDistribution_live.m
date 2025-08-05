%{
    This script is used to show diameter distribution
    You can test all steps by Ctrl + Enter

    Step 1 : Traverse data and extract radius
    Step 2 : Visualization

Provided by ENN USST
MATLAB R2019a
%}
clc;
clear;
close all;
addpath(genpath(pwd));  % Call the functions in all folders in the current folder
path = pwd;

file_list = dir('./results/live/try231214/params/*.mat');
file_path = [path '/results/live/try231214/params'];

%% ------------------- Step 1 : Traverse data and extract radius
all_R = [];
for idx = 1:length(file_list)
    cd(file_path)
    file_name = file_list(idx).name;
    fprintf(file_name);
    fprintf('\n');
    cd(path)
    cd(file_path);
    load(file_name);
    cd(path)
    all_R = [all_R bestR_list];
end
% The radius needs to meet the theoretical value
all_R = all_R(find(all_R < 7));
all_R = all_R(find(all_R > 4));

rn = numel(all_R);

xx = 4:0.1182:8;
[me,aa] = normfit(all_R);

%% ------------------- Step 2 : Visualization
figure;
histogram(all_R*2,"BinEdges",xx*2);
hold on;

mu = me;
sigma = aa; 
x = xx;
y = exp(- 0.5 * ((x - mu) / sigma) .^ 2) / (sigma * sqrt(2 * pi));
plot(x*2, y*rn/sum(y));