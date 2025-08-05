function [R, A1_updated, B1_updated] = calculate95PercentileDistance(P, A, B, cover_weight)
arguments
    P 
    A 
    B 
    cover_weight = 0.95
end

s = zeros(1, size(A, 2));


AB = B - A;
AB_length = norm(AB);
AB_unit = AB / AB_length;


Q_all = zeros(size(P));
for i = 1:size(P, 1)
    AP = P(i, :) - A;
    proj_length = dot(AP, AB_unit);
    Q = A + proj_length * AB_unit;
    Q_all(i, :) = Q;
    s = s + (Q - P(i, :));
end


s = s / size(P, 1);


A1 = A - s;
B1 = B - s;


A1B1 = B1 - A1;
A1B1_length = norm(A1B1);
A1B1_unit = A1B1 / A1B1_length;


distances = zeros(size(P, 1), 1);
projection_params = zeros(size(P, 1), 1); 

for i = 1:size(P, 1)
    A1P = P(i, :) - A1;
    proj_length = dot(A1P, A1B1_unit);
    proj_point = A1 + proj_length * A1B1_unit;

   
    if proj_length < 0
        proj_point = A1;
        projection_params(i) = 0;  
    elseif proj_length > A1B1_length
        proj_point = B1;
        projection_params(i) = 1; 
    else
        projection_params(i) = proj_length / A1B1_length;  
    end

    distances(i) = norm(P(i, :) - proj_point);
end


R = prctile(distances, cover_weight*100);

%%  %%

[~, sorted_idx] = sort(projection_params);
sorted_params = projection_params(sorted_idx);


discard_ratio = (1 - cover_weight) / 2;
keep_start = floor(size(P, 1) * discard_ratio) + 1;
keep_end = size(P, 1) - floor(size(P, 1) * discard_ratio);


min_param = sorted_params(keep_start);
max_param = sorted_params(keep_end);


A1_updated = A1 + min_param * A1B1;
B1_updated = A1 + max_param * A1B1;
end