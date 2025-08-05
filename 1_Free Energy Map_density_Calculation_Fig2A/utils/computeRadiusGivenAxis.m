function [bestRadius, error] = computeRadiusGivenAxis(points, A, B)
  
    distances = zeros(size(points, 1), 1);


    dPA = bsxfun(@minus, points, A);
    
  
    vecBA = B - A;
    normBA = norm(vecBA);
    
  
    crossProduct = cross(dPA, repmat(vecBA, size(points, 1), 1), 2);
    distances = sqrt(sum(crossProduct.^2, 2)) / normBA;
   
    error = sum(distances.^2);

  
    sortedDistances = sort(distances, 'ascend');

    numPoints = round(0.9 * size(points, 1));
    
    bestRadius = sortedDistances(numPoints);
end
