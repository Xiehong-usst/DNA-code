close all;
clear;
addpath(fullfile(pwd, 'utils'));
filename = 'Fig2A20230903area1.tif';
Step1_readfile_tif_hu;
Step3_cluster_test;
data_cluster_base_edge_main;
data_cut_Radii_main2;