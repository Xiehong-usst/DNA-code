function density_values = computeDensity2(data_points, radius)


    volume = (4/3) * pi * radius^3;
    
    n = size(data_points, 1);
    

    density_values = zeros(n, 1);

    for i = 1:n
       
        distances = sqrt(sum((data_points - data_points(i,:)).^2, 2));
        
        
        count = sum(distances <= radius) - 1;
        
       
        density_values(i) = count / volume;
    end
end
