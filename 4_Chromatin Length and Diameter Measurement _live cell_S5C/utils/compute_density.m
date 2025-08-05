function [X_density, Y_density, Z_density, x1_range, y1_range, z1_range, value] = compute_density(data, d, h)
%%

    x_min = min(data(:,1)) - h;
    x_max = max(data(:,1)) + h;
    y_min = min(data(:,2)) - h;
    y_max = max(data(:,2)) + h;
    z_min = min(data(:,3)) - h;
    z_max = max(data(:,3)) + h;

    x1_range = x_min:d:x_max;
    y1_range = y_min:d:y_max;
    z1_range = z_min:d:z_max;

    [X_density, Y_density, Z_density] = meshgrid(x1_range, y1_range, z1_range);

   
    value = zeros(size(X_density));

    
    V = (4/3) * pi * h^3;

   
    for i = 1:size(data, 1)
        
        point = data(i, :);

        x_idx = find(x1_range >= point(1) - h & x1_range <= point(1) + h);
        y_idx = find(y1_range >= point(2) - h & y1_range <= point(2) + h);
        z_idx = find(z1_range >= point(3) - h & z1_range <= point(3) + h);

        
        for xx = x_idx
            for yy = y_idx
                for zz = z_idx
                    if norm([X_density(yy, xx, zz), Y_density(yy, xx, zz), Z_density(yy, xx, zz)] - point) <= h
                        value(yy, xx, zz) = value(yy, xx, zz) + 1;
                    end
                end
            end
        end
    end

   
    value = value / V;
end
