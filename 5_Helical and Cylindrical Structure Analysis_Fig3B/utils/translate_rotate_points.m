function [A_transformed, B_transformed, newpoints] = translate_rotate_points(points, A, B)
 
    AB = B - A;
    
   
    T = -B;
    
    
    translated_points = points*0;
    for k = 1:size(points,1)
        translated_points(k,:) = points(k,:) + T;
    end
    
    newB = B + T;
    newA = A + T;
    rotateM = rotate_to_Z(newA);
    
    A_transformed = (rotateM*newA')';
    B_transformed = (rotateM*newB')';
    
    newpoints = points*0;
    for k = 1:size(points,1)
        newpoints(k,:) = (rotateM*translated_points(k,:)')';
    end

    
end
function A = rotate_to_Z(p)
    
    A3 = p / norm(p);

    
    A1 = cross(A3, [1, 0, 0]);
    A1 = A1 / norm(A1);
    A2 = cross(A3, A1);
    A2 = A2 / norm(A2);

 
    A = [A1; A2; A3];
end
