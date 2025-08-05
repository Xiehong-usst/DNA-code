function [matched_points, matched_ids, transform_info] = find_matching_points(A, B)

tolerance = 1e-6;


centroid_B = mean(B, 1);
dB = sqrt(sum((B - centroid_B).^2, 2));  
[dB_sorted, idx_B] = sort(dB);         
B_sorted = B(idx_B, :);                 


permutations = perms(1:3); 
signs = [1 1 1; 1 1 -1; 1 -1 1; 1 -1 -1; -1 1 1; -1 1 -1; -1 -1 1; -1 -1 -1]; 


combinations = nchoosek(1:size(A,1), 8);


for c = 1:size(combinations, 1)
    ids = combinations(c, :);  
    A8 = A(ids, :);  
    
   
    centroid_A8 = mean(A8, 1);
    dA = sqrt(sum((A8 - centroid_A8).^2, 2)); 
    
    [dA_sorted, idxA] = sort(dA);  
    if ~all(abs(dA_sorted - dB_sorted) < tolerance)
        continue;  
    end
    
  
    unique_dists = uniquetol(dA_sorted, tolerance);
    same_dist_groups = cell(size(unique_dists));
    
   
    for i = 1:numel(unique_dists)
        dist = unique_dists(i);
        mask = abs(dA_sorted - dist) < tolerance;
        same_dist_groups{i} = find(mask);
    end
    
    
    all_idx_permutations = {1:8}; 
    for g = 1:numel(same_dist_groups)
        group = same_dist_groups{g};
        if numel(group) > 1
            
            new_perms = {};
            for p = 1:numel(all_idx_permutations)
                base = all_idx_permutations{p};
                group_perms = perms(group);
                for r = 1:size(group_perms, 1)
                    temp = base;
                    temp(group) = base(group_perms(r, :));
                    new_perms{end+1} = temp;
                end
            end
            all_idx_permutations = new_perms;
        end
    end
    
    
    for order_idx = 1:numel(all_idx_permutations)
        idx_perm = all_idx_permutations{order_idx};
        A8_sorted = A8(idxA(idx_perm), :);  
        
       
        for perm_idx = 1:size(permutations, 1)
            for sign_idx = 1:size(signs, 1)
                perm = permutations(perm_idx, :);
                sign_vals = signs(sign_idx, :);
                
               
                R = zeros(3);
                for dim = 1:3
                    R(dim, perm(dim)) = sign_vals(dim);
                end
                
               
                A_transformed = A8_sorted * R;
                
               
                centroid_trans = mean(A_transformed, 1);
                T = centroid_B - centroid_trans;
                
              
                A_aligned = A_transformed + T;
                
              
                match = true;
                for i = 1:size(B_sorted, 1)
                    dist = norm(A_aligned(i, :) - B_sorted(i, :));
                    if dist > tolerance
                        match = false;
                        break;
                    end
                end
                
               
                if match
                    matched_points = A8;
                    matched_ids = ids;  
                    
                   
                    axis_names = {'X', 'Y', 'Z'};
                    
                    
                    perm_desc = {};
                    for dim = 1:3
                        perm_desc{end+1} = [axis_names{dim} ' → ' axis_names{perm(dim)}];
                    end
                    
                    
                    flip_desc = {};
                    for dim = 1:3
                        if sign_vals(dim) == -1
                            flip_desc{end+1} = [axis_names{perm(dim)} 'axis translate'];
                        end
                    end
                    
                    
                    disp('================================================================');
                    disp('Succseefully：');
                    disp('1. axis translate：');
                    fprintf('    • %s\n', perm_desc{:});
                    
                    if ~isempty(flip_desc)
                        disp('2. axis translate：');
                        fprintf('    • %s\n', flip_desc{:});
                    else
                        disp('2. axis translate：NONE');
                    end
                    
                    disp('3. axis translate：');
                    fprintf('    • X: %.4f\n', T(1));
                    fprintf('    • Y: %.4f\n', T(2));
                    fprintf('    • Z: %.4f\n', T(3));
                    
                    disp('4.axis translate：');
                    fprintf('    ');
                    for i = 1:8
                        fprintf('%d ', ids(i));  
                    end
                    fprintf('\n');
                    
                    disp('================================================================');
                    disp(['all：' ...
                        'new a = [ori' axis_names{perm(1)} ', pri' axis_names{perm(2)} ', ori' axis_names{perm(3)} ']']);
                    if sign_vals(1) == -1
                        fprintf('                × [-1, ');
                    else
                        fprintf('                × [1, ');
                    end
                    if sign_vals(2) == -1
                        fprintf('-1, ');
                    else
                        fprintf('1, ');
                    end
                    if sign_vals(3) == -1
                        fprintf('-1]');
                    else
                        fprintf('1]');
                    end
                    fprintf(' + [%.4f, %.4f, %.4f]\n', T(1), T(2), T(3));
                    disp('================================================================');
                    
                  
                    transform_info = struct();
                    transform_info.permutation = perm;
                    transform_info.signs = sign_vals;
                    transform_info.translation = T;
                    transform_info.rotation_matrix = R;
                    transform_info.matched_ids = ids;  
                    
                    return;
                end
            end
        end
    end
end

error('Finish');
end