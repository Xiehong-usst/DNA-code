function plotAllCylinders(cylinders)
   
    for i = 1:length(cylinders)
        cylinder = cylinders{i};

        bestA = cylinder.bestA;
        bestB = cylinder.bestB;
        bestRadius = cylinder.bestRadius;
        dataPoints = cylinder.dataPoints;
        color1 = rand(1,3)*0.9; 


        plot_cylinder_with_points(bestA, bestB, bestRadius, dataPoints, color1);
    end
end
