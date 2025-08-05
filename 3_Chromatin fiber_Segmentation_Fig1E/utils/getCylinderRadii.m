function radii = getCylinderRadii(cylinders)
    n = length(cylinders);
    radii = zeros(n, 1);
    
    for i = 1:n
        cylinder = cylinders{i};
        radii(i) = cylinder.bestRadius;
    end
end
