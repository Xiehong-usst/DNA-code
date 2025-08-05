
load('area2023071601_loc_time.mat', 'area2023071601_loc');


coords = area2023071601_loc(:, 1:3);


[unique_coords, ~, ic] = unique(coords, 'rows', 'stable'); 
counts = accumarray(ic, 1); 

area1_loc_with_counts = [unique_coords, counts];


save('area1_loc_with_counts.mat', 'area1_loc_with_counts'); 
disp('finish');