path1 = pwd;
cd('saved_variables\');
file_list = dir('*.mat');

radii_list = [];
for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    if numel(file_name) > 10
        if strcmp(file_name(end-10:end-4),'d_stats')
            fprintf(file_name);
            fprintf('\n');
            load(file_name);
            radii_list = [radii_list; radii];
        end
    end
end
save('radii_stats_all.mat', 'radii_list');

cd(path1);