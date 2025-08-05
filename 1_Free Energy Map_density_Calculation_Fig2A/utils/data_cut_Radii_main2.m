load('3d_cluster_area1_loc.mat');
data1 = area1_loc_ori*3;
load('.\saved_variables\3d_cluster_area1_loc_multi_fit_single.mat');
cut_set = 20;
new_data1 = [];
newCylinders = [];
nn1 = 0;
for k = 1:numel(allCylinders)
    A1 = allCylinders{k}.bestA;
    B1 = allCylinders{k}.bestB;
    R1 = allCylinders{k}.bestRadius;
    inside = is_inside_cylinder(data1, A1, B1, R1+2);
    n1 = find(inside == 1);
    new_data1 = [new_data1; data1(n1,:)];

    new_datak = data1(n1,:);
    d1 = norm(B1 - A1);
    nd = floor(d1/cut_set);
    cutd = d1/nd;
    groupedPoints = [];
    Alist = [];
    Blist = [];
    nd = 1;
    if nd > 1
        AB = B1 - A1;
        AB_length = norm(AB);
        AB_unit = AB / AB_length;
        for r = 1:nd
            Alist{r} = A1 + (r - 1)*cutd*AB_unit;
            Blist{r} = A1 + r*cutd*AB_unit;
        end
        groupedPoints = groupPointsByDistance(new_datak, A1, B1, cutd);
    else
        Alist{1} = A1;
        Blist{1} = B1;
        groupedPoints{1} = new_datak;
    end
    for r = 1:numel(Alist)
        Rbest = calculate95PercentileDistance(groupedPoints{r}, Alist{r}, Blist{r});
        cylinder1 = [];
        cylinder1.bestA = Alist{r};
        cylinder1.bestB = Blist{r};
        cylinder1.bestRadius = Rbest;
        cylinder1.dataPoints = groupedPoints{r};
        nn1 = nn1 + 1;
        newCylinders{nn1} = cylinder1;
    end
end
fig_dir = './';
if ~exist(fig_dir, 'dir')
    mkdir(fig_dir);
end
fig= figure;
axes1 = axes(fig);
plotAllCylinders(newCylinders);
fig_children = get(axes1, 'Children');
%set(axes1, 'YDir', 'reverse');
%scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3),'w','LineWidth', 1);

view(axes1, [85.2940884584612, 6.77743249369381]); 
xlabel(axes1, 'Y'); 
ylabel(axes1, 'X');
zlabel(axes1, 'Z');
grid(axes1, 'on');
axis(axes1, 'tight');
hold(axes1, 'off');
set(axes1, 'DataAspectRatio', [1 1 1]);
drawnow;
savefig(fig, fullfile(fig_dir, 'GlobalView.fig'));
fprintf('Saved global view: %s\n', fullfile(fig_dir, 'GlobalView.fig'));

%savefig(gcf, 'GlobalView.fig');
%fprintf('Saved global view: GlobalView.fig\n');


f2 = figure;
ax1 = axes(f2);
copyobj(fig_children, ax1); %


view(ax1, [136.355323535794, 52.283409497301]);
xlim(ax1, [439.262405890469, 500.370141124515]);
ylim(ax1, [105.671652989804, 162.027455440799]);
zlim(ax1, [372.984698719727, 430.969494317947]);


grid(ax1, 'on');
xlabel(ax1, 'Y');
ylabel(ax1, 'X');
zlabel(ax1, 'Z');
set(ax1, 'DataAspectRatio', [1 1 1]);
title(ax1, 'Region a');
drawnow;
savefig(f2, fullfile(fig_dir, 'Regiona.fig'));
fprintf('Saved region a: %s\n', fullfile(fig_dir, 'Regiona.fig'));

%savefig(f2, 'Region1.fig');
%fprintf('Saved region 1: Region1.fig\n');


f3 = figure;
ax2 = axes(f3);
copyobj(fig_children, ax2);

view(ax2, [306.844754597515, 79.4100161691715]); 
xlim(ax2, [368.472939649622, 440.745335527104]);
ylim(ax2, [153.999141203152, 220.65140460535]);
zlim(ax2, [656.476442471669, 725.055323464376]);


grid(ax2, 'on');
xlabel(ax2, 'Y');
ylabel(ax2, 'X');
zlabel(ax2, 'Z');
set(ax2, 'DataAspectRatio', [1 1 1]);
title(ax2, 'Region b');
drawnow;

savefig(f3, fullfile(fig_dir, 'Regionb.fig'));
fprintf('Saved region b: %s\n', fullfile(fig_dir, 'Regionb.fig'));

%savefig(f3, 'Region2.fig');
%fprintf('Saved region 2: Region2.fig\n');


f4 = figure;
ax3 = axes(f4);
copyobj(fig_children, ax3); 


view(ax3, [19.5517586891248, 8.37742884277008]);
xlim(ax3, [458.976730698075, 572.523169361943]);
ylim(ax3, [5.76671303788886, 110.48341775369]);
zlim(ax3, [323.052940063068, 430.796534415131]);


grid(ax3, 'on');
xlabel(ax3, 'Y');
ylabel(ax3, 'X');
zlabel(ax3, 'Z');
set(ax3, 'DataAspectRatio', [1 1 1]);
title(ax3, 'Region c');
drawnow;
savefig(f4, fullfile(fig_dir, 'Regionc.fig'));
fprintf('Saved region c: %s\n', fullfile(fig_dir, 'Regionc.fig'));

%savefig(f4, 'Region3.fig');
%fprintf('Saved region 3: Region3.fig\n');

lengths = getCylinderLengths(newCylinders);
radii = getCylinderRadii(newCylinders);
save exp1_stat newCylinders lengths radii