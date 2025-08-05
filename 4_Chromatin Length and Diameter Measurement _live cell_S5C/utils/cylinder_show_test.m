
load('D:\LKY\DNA-matlab code\DNA-matlab code_240827\Chromatin Length and Diameter Measurement\data\20250722-data-lky\saved_variables\3d_cluster_area14_d_stats.mat');


for i = 1:length(newCylinders)
    cylinder = newCylinders{i};
    
    
    bestA = cylinder.bestA;
    bestB = cylinder.bestB;
    bestRadius = cylinder.bestRadius;
    dataPoints = cylinder.dataPoints;
    
  
    cylinderDiameter = 2 * bestRadius;          
    cylinderLength = norm(bestA - bestB);          
    
   
    figure('NumberTitle', 'off', 'Name', sprintf('Cylinder %d', i));
    
 
    color1 = rand(1,3)*0.9;
    
  
    plot_cylinder_with_points(bestA, bestB, bestRadius, dataPoints, color1);
    new_data1 = cylinder.dataPoints;
    scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3), 'k', 'filled');
  
    title(sprintf('Diameter: %.2f nm | Length: %.2f nm', cylinderDiameter, cylinderLength));
    xlabel('X (nm)'); ylabel('Y (nm)'); zlabel('Z (nm)');
    axis equal; 
    grid on;
    
  
    rotate3d on;
end