function points = generate_sphere_points(center, radius, num_points)
    
    x0 = center(1);
    y0 = center(2);
    z0 = center(3);
    
    points = zeros(num_points, 3);
    
    for i = 1:num_points
        
        phi = 2 * pi * rand(); 
        theta = acos(2 * rand() - 1); 
        
       
        x = radius * sin(theta) * cos(phi);
        y = radius * sin(theta) * sin(phi);
        z = radius * cos(theta);
        
       
        points(i, :) = [x + x0, y + y0, z + z0];
    end
end


