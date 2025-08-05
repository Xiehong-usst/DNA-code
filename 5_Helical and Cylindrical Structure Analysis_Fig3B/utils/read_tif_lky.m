
pathname = '.\';
filepath = fullfile(pathname, filename);
info = imfinfo(filepath);
numPages = numel(info);


[~, matFilename, ~] = fileparts(filename);


allData = cell(numPages, 1);

for z = 1:numPages
    tifImage = imread(filepath, z);
    [height, width] = size(tifImage);
    [X, Y] = meshgrid(1:width, 1:height);
    
   
    currentData = [X(:), Y(:), repmat(z, numel(X), 1), double(tifImage(:))];
    
    
    validIdx = currentData(:,4) >= 1;
    allData{z} = currentData(validIdx, :);
end


data = vertcat(allData{:});
% data(:,2) = max(data(:,2)) + 1 - data(:,2); 


repeat_counts = data(:, 4);
new_total_rows = sum(repeat_counts);
expanded_data = zeros(new_total_rows, 3); 

current_index = 1;
for i = 1:size(data, 1)
    reps = repeat_counts(i);
    expanded_data(current_index:current_index+reps-1, :) = repmat(data(i, 1:3), reps, 1);
    current_index = current_index + reps;
end


expanded_data = round(expanded_data); 
expanded_data = unique(expanded_data, 'rows'); 


data = expanded_data; 


% save(fullfile(pathname, ['.\data\3d_cluster_' matFilename '.mat']), 'data');
% disp(['SAVE: ' matFilename '.mat']);

disp('Finish！');