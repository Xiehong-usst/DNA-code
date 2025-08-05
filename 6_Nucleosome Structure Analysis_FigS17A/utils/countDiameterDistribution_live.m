%{
    This script is used to count diameter distribution

Provided by ENN USST
MATLAB R2019a
%}
clc;
clear;
close all;

% Traverse data
file_list = dir('./dataset/live/*.fig');
all_D = [];
for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    loadDataAndProcess_live(file_name);
end