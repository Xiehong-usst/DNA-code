function data_3D = read3Dtif(tif_file_path)
% read3Dtif is a function used to read tif files
% This function returns the coordinates of non zero points in three-dimensional space
%{
    Method:
    'imfinfo' get size
    'imread' get maps frame by frame
    'find' get non zero points in all maps
    'ind2sub' coordinate non zero points in three-dimensional space
%}
    info = imfinfo(tif_file_path);
    num_frame = length(info);
    w = info.Width;
    h = info.Height;
    temp = zeros(h, w, num_frame);
    for frame = 1:num_frame
        temp(:, :, frame) = imread(tif_file_path, 'Index', frame);
    end
    nonzero_point_index = find(temp>0); % store the index of non zero points
    nonzero_point_num = length(nonzero_point_index);
    data_3D = zeros(nonzero_point_num, 3);
    x = h;
    y = w;
    z = num_frame;
    [data_3D(:,1), data_3D(:,2), data_3D(:,3)] = ind2sub([x, y, z], nonzero_point_index);
end

