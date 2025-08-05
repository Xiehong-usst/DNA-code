function [X,Y,Z,gradient_magnitude] = compute_gradient_magnitude(data, d, h, q)
    tic;
    [X_density, Y_density, Z_density, x1_range, y1_range, z1_range, value] = compute_density(data, d, h);
    toc;

    x_min = min(data(:,1))-h;
    x_max = max(data(:,1))+h;
    y_min = min(data(:,2))-h;
    y_max = max(data(:,2))+h;
    z_min = min(data(:,3))-h;
    z_max = max(data(:,3))+h;

    x_range = x_min:d:x_max;
    y_range = y_min:d:y_max;
    z_range = z_min:d:z_max;

    [X, Y, Z] = meshgrid(x_range, y_range, z_range);

    gradient_magnitude = zeros(size(X));
    N = numel(X);
    disp(N);
    tic;
    show_button = 0;
    batch_size = 10000;
    for u = 1:ceil(N/batch_size)
        if mod(u,round(ceil(N/batch_size)/100)) == 0
            fprintf('-');
            if show_button == 0
                toc;
                tic;
                show_button = 1;
            end
        end
        un1 = (u - 1)*batch_size;
        topi = min(N - un1,batch_size);
        sub_gradient_magnitude = zeros(1,topi);
        for i = 1:topi
          
            point = [X(i+un1), Y(i+un1), Z(i+un1)];
            
         
            x_idx = find(x1_range >= point(1) - q & x1_range <= point(1) + q);
            y_idx = find(y1_range >= point(2) - q & y1_range <= point(2) + q);
            z_idx = find(z1_range >= point(3) - q & z1_range <= point(3) + q);


            X_sub = X_density(y_idx,x_idx,z_idx);
            Y_sub = Y_density(y_idx,x_idx,z_idx);
            Z_sub = Z_density(y_idx,x_idx,z_idx);
            value_sub = value(y_idx,x_idx,z_idx);
            
           
            distances = sqrt((X_sub - point(1)).^2 + (Y_sub - point(2)).^2 + (Z_sub - point(3)).^2);
            
          
            mask = distances < q;
            local_coords = [X_sub(mask), Y_sub(mask), Z_sub(mask)];
            local_values = value_sub(mask);

    
        
            [a, b, c, ~] = computeGradientLSQ(local_coords, local_values);
    
        
            sub_gradient_magnitude(i) = sqrt(a^2 + b^2 + c^2);
        end
        gradient_magnitude(un1+1:un1+topi) = sub_gradient_magnitude(1:topi);
    end
    toc;
end
