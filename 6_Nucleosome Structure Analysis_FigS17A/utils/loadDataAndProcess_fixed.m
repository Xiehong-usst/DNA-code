function loadDataAndProcess_fixed(filename)
% loadDataAndProcess_live is a function used to process fixed cell image data and call fitting function findNucleosome
    % Read data from tif
    data_path = sprintf('./%s',filename);
    data = read3Dtif(data_path);
    X = data(:, 1);
    Y = data(:, 2);
    Z = data(:, 3);
    data = [Y, X, Z]; % Matlab Rule
    data = data * 3;
    findNucleosome_fixed(filename, data);
end
