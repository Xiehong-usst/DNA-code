function plotAllCylinders(cylinders)
   
    for i = 1:length(cylinders)
        cylinder = cylinders{i};

        bestA = cylinder.bestA;
        bestB = cylinder.bestB;
        bestRadius = cylinder.bestRadius;
        dataPoints = cylinder.dataPoints;
        color1 = rand(1,3)*0.9; 
        plot_cylinder_with_points(bestA, bestB, bestRadius, dataPoints, color1);

      
        % centroid = mean(dataPoints, 1);
        % 
      
        % text(centroid(1), centroid(2), centroid(3), num2str(i), ...
        %     'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k', ...
        %     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
        
    end 
end
