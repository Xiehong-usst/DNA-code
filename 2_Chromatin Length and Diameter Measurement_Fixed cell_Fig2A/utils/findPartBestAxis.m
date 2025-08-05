function [bestA, bestB, bestRadius, minError] = findPartBestAxis(points, X1, Y1, Z1, X2, Y2, Z2)
 

    minError = Inf;  
    [numRows1, numCols1] = size(X1);
    [numRows2, numCols2] = size(X2);

    for i = 1:(numRows1 * numCols1)
        A = [X1(i), Y1(i), Z1(i)];
        for j = 1:(numRows2 * numCols2)
            B = [X2(j), Y2(j), Z2(j)];
            if sum((A-B).^2) > 10^(-4) 
                
                [radius, error] = computeRadiusGivenAxis(points, A, B);

                
                if error < minError
                    bestA = A;
                    bestB = B;
                    bestRadius = radius;
                    minError = error;
                end
            end
        end
    end

   
    normalized_AB = (bestB - bestA) / norm(bestB - bestA); 
    inner_products = zeros(size(points, 1), 1); 

    for k = 1:size(points, 1)
        AC = points(k, :) - bestA;
        inner_products(k) = dot(AC, normalized_AB);
    end
    
    r1 = prctile(inner_products, 2);
    r2 = prctile(inner_products, 98);
    
    newA = bestA + r1 * normalized_AB; 
    newB = bestA + r2 * normalized_AB;  
    bestA = newA;
    bestB = newB;
end
