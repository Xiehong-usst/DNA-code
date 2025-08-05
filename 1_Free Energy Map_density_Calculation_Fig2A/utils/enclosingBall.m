function [center, radius] = enclosingBall(points)
   
    
   
    center = mean(points, 1);

  
    distances = sqrt(sum(bsxfun(@minus, points, center).^2, 2));
    radius = max(distances);
end
