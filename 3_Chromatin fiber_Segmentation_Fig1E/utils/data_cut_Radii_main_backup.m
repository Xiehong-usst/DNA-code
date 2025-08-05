load('3d_cluster_area2_loc.mat');
data1 = area2_loc_ori*3;

load('D:\LKY\data_HuYi\20230915_exp_fig\result_12_10_-4\saved_variables\3d_cluster_area2_loc_multi_fit_single.mat');


tic;
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
toc;


fig = figure;
% scatter3(data1(:,1), data1(:,2), data1(:,3), 'k', 'filled');
hold on;
plotAllCylinders(newCylinders);
lengths = getCylinderLengths(newCylinders);
radii = getCylinderRadii(newCylinders);
% scatter3(new_data1(:,1), new_data1(:,2), new_data1(:,3), 'k', 'filled');

save exp1_stat newCylinders lengths radii