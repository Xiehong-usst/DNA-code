function lengths = getCylinderLengths(cylinders)
    n = length(cylinders);
    lengths = zeros(n, 1);
    
    for i = 1:n
        cylinder = cylinders{i};
        bestA = cylinder.bestA;
        bestB = cylinder.bestB;

        lengths(i) = norm(bestB - bestA);
    end
end
