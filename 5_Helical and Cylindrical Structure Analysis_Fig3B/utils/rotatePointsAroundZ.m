function rotatedPoints = rotatePointsAroundZ(points, angle)
    
    Rz = [cos(angle) -sin(angle) 0;
          sin(angle)  cos(angle) 0;
          0           0          1];
    
   
    rotatedPoints = points * Rz';
end
