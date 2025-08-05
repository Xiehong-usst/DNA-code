file_list = dir('*.mat');
idx = 5;
file_name = file_list(idx).name;
data1 = loadDataAndProcess(file_name);

load('D:\LKY\data_HuYi\20231118new\saved_variables\area3_loc_dcr_multi_fit_single.mat');


for k = 1:numel(allCylinders)
    new_data1 = [];
    datak = allCylinders{k}.dataPoints;
    for r = 1:size(datak,1)
        r1 = datak(r,:);
        d1 = (data1(:,1) - r1(1)).^2+(data1(:,2) - r1(2)).^2+(data1(:,3) - r1(3)).^2;
        if min(d1) <= 6.75
            n1 = find(d1 == min(d1));
            new_data1 = [new_data1; data1(n1,:)];
        end
    end
    allCylinders{k}.dataPoints = new_data1;
end

    fig = figure;
    plotAllCylinders(allCylinders);