
file_list = dir('3d*.mat');


if ~exist('saved_figures', 'dir')
   mkdir('saved_figures');
end

if ~exist('saved_variables', 'dir')
   mkdir('saved_variables');
end



for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    data1 = loadDataAndProcess2(file_name);
    idx640 = loadDataAndProcess3(file_name);

    fprintf('Processing file: %s\n', file_name);
    
    num_clusters = max(idx640);
    
    allCylinders = {};
    for k = 1:num_clusters
        n1 = find(idx640 == k);
        data2 = data1(n1,:);
        fprintf(['\n']);
        fprintf(['Cluster' num2str(k) '\n']);
        cylinders = recursiveCylinderFitting(data2);
        allCylinders = [allCylinders, cylinders];
    end
    
  
    save_name_cylinders = fullfile('saved_variables', [file_name(1:end-4) '_multi_fit_all.mat']);
    save(save_name_cylinders, 'allCylinders');

    new_data1 = data1;

   
    fig = figure;
    plotAllCylinders(allCylinders);
    lengths = getCylinderLengths(allCylinders);
    radii = getCylinderRadii(allCylinders);
%     scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3), 'k', 'filled');
    
    
    fprintf('lengths:\n');
    disp(lengths);
    fprintf('radii\n');
    disp(radii);
    
    
    variables_filename = fullfile('saved_variables', [file_name(1:end-4) '_multi_fit_single.mat']);
    fig_filename = fullfile('saved_figures', [file_name(1:end-4) '_cylinders_visualization.fig']);
    
  
    savefig(fig, fig_filename);
    
   
    save(variables_filename, 'allCylinders', 'lengths', 'radii');
end
