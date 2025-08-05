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
data(:, [1, 2]) = data(:, [2, 1]);
%data(:,2) = max(data(:,2)) + 1 - data(:,2); 
count=data(:,4);
data(:,4) = [];
shortName = matFilename(end-4:end); 

outputFilename = ['3d_cluster_',shortName, '_loc.mat'];
newVarName = [shortName, '_loc_ori']; 
eval([newVarName ' = data;']); 

save(fullfile(pathname, outputFilename), newVarName, 'count');

disp('All files processed successfully!');