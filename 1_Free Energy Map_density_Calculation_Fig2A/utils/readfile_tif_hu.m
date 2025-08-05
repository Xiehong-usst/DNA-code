[filenames, pathname] = uigetfile('*.tif', 'SelectTIFF', 'MultiSelect', 'on');
if isequal(filenames, 0)
    disp('User canceled selection');
    return;
end

% Convert single file selection to cell array for consistency
if ischar(filenames)
    filenames = {filenames};
end

% Process each file
for fileIdx = 1:length(filenames)
    filename = filenames{fileIdx};
    filepath = fullfile(pathname, filename);
    info = imfinfo(filepath);
    numPages = numel(info);
    
    % Remove '.tif' extension from filename
    [~, matFilename, ~] = fileparts(filename);
    
    % Preallocate space (using cell array to store each layer's data)
    allData = cell(numPages, 1);
    
    for z = 1:numPages
        tifImage = imread(filepath, z);
        [height, width] = size(tifImage);
        [X, Y] = meshgrid(1:width, 1:height);
        
        % Get all point data for current layer
        currentData = [X(:), Y(:), repmat(z, numel(X), 1), double(tifImage(:))];
        
        % Keep only points with Count ≥ 1
        validIdx = currentData(:,4) >= 1;
        allData{z} = currentData(validIdx, :);
    end
    
    % Combine all data
    data = vertcat(allData{:});
    data(:,2) = max(data(:,2)) + 1 - data(:,2); % Invert Y-axis (to match ImageJ coordinate system)
    
    % Expand data rows based on Count values
    repeat_counts = data(:, 4);
    new_total_rows = sum(repeat_counts);
    expanded_data = zeros(new_total_rows, 3); % Keep only XYZ without Count column
    
    current_index = 1;
    for i = 1:size(data, 1)
        reps = repeat_counts(i);
        expanded_data(current_index:current_index+reps-1, :) = repmat(data(i, 1:3), reps, 1);
        current_index = current_index + reps;
    end
    
    % Rename expanded data to 'data' (overwriting original)
    data = expanded_data; % Final output contains only XYZ coordinates
    % Rename expanded data to matFilename (dynamic variable name)
    eval([matFilename ' = expanded_data;']);
    
    % Save to MAT file (same name as TIFF without extension)
    save(fullfile(pathname, ['3d_cluster_' matFilename '.mat']), 'data');
    disp(['Processed and saved: ' matFilename '.mat']);
end

disp('All files processed successfully!');