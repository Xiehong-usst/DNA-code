load('3d_cluster_area1_loc.mat');  
%load (3d_cluster_area1_loc.mat)
data=area1_loc_ori;
R=8;  % 
normalized_Free_Energy_map=[];
for idx=1:length(data(:,1))
Distances = sqrt( sum( (data-data(idx,:)).^2 ,2) );
Ninside   = length( find(Distances<=R) );
normalized_Free_Energy_map(idx) = Ninside/(4*pi*R.^3/3);
end
figure
scatter3(data(:,1)*3,data(:,2)*3,data(:,3)*3,10,normalized_Free_Energy_map','filled');
axis equal
set(gcf,'color','white');
colordef white;
colormap jet
clim([0 0.08])
view([85.2940884584612, 6.77743249369381]);
c = colorbar;
c.Label.String = 'Density';
c.Label.FontSize = 12;
xlabel('Y(nm)');
ylabel('X(nm)');
zlabel('Z(nm)');
zlim([100 800]);