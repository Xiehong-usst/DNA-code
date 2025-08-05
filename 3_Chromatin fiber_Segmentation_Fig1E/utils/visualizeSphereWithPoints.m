function visualizeSphereWithPoints(points, O, R_sphere)

    scatter3(points(:,1), points(:,2), points(:,3), 'filled');
    hold on;

   
    [Xs, Ys, Zs] = sphere(50); 

   
    h = surf(R_sphere*Xs + O(1), R_sphere*Ys + O(2), R_sphere*Zs + O(3));

   
    h.FaceAlpha = 0.5;
    h.EdgeColor = 'none';  

 
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on;
    title('Data Points and Fitted Bounding Sphere');
    view(3);  
    axis equal;  
    hold off;
end
