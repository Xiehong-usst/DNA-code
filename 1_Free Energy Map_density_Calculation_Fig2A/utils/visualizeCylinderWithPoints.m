function visualizeCylinderWithPoints(points, R, A, B)
  
    scatter3(points(:,1), points(:,2), points(:,3), 'filled');
    hold on;


    direction = B - A;
    length_cylinder = norm(direction);
    direction = direction / length_cylinder;


    [Xcyl, Ycyl, Zcyl] = cylinder(R);
    Zcyl(1, :) = 0; 
    Zcyl(2, :) = length_cylinder;

 
    h = surf(Xcyl, Ycyl, Zcyl);
    rotate(h, [0 0 1], rad2deg(acos(dot([0 0 1], direction))));
    center = A + 0.5*(B - A);
    h.XData = h.XData + center(1);
    h.YData = h.YData + center(2);
    h.ZData = h.ZData + center(3);

    
    h.FaceAlpha = 0.5;
    h.EdgeColor = 'none';  


    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
    title('Data Points and Fitted Cylinder');
    view(3);  
    axis equal;  
    hold off;
end
