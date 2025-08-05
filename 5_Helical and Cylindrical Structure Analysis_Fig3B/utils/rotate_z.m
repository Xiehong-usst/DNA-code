function rotated_points = rotate_z(points, a)
    
    a_rad = deg2rad(a);
    
    
    Rz = [cos(a_rad) -sin(a_rad) 0;
          sin(a_rad)  cos(a_rad) 0;
          0           0          1];
    
    
    rotated_points = points * Rz';
end
