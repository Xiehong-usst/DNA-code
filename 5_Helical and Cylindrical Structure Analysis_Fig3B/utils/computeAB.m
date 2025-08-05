function [A, B] = computeAB(u, point, tangentVector)
   
    unitVector = tangentVector / norm(tangentVector);
    
 
    A = point - u * unitVector;
    B = point + u * unitVector;
end
