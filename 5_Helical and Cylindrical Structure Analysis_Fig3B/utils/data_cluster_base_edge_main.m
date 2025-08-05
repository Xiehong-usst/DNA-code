clc;
clear;
close all;

file_list = dir('./dataset/live/*.fig');



all_D = [];
for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    loadDataAndProcess(file_name);
end