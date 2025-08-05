
file_list = dir('3d*.mat');

for idx = 1:length(file_list)
    file_name = file_list(idx).name;
    data1 = loadDataAndProcess(file_name);
    k = loadDataAndProcess2(file_name);
    file_name2 = '.\saved_variables\3d_cluster_area10Substack54_multi_fit_single.mat';
    %file_name2 = ['.\saved_variables\3d_cluster_area' num2str(k) '_loc_multi_fit_single.mat'];
    load(file_name2);
   
    
    tic;
    cut_set = 30;
    
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
            [Rbest,newA1,newB1] = calculate95PercentileDistance(groupedPoints{r}, Alist{r}, Blist{r});
            cylinder1 = [];
            cylinder1.bestA = newA1;
            cylinder1.bestB = newB1;
            cylinder1.bestRadius = Rbest;
            cylinder1.dataPoints = groupedPoints{r};
            nn1 = nn1 + 1;
            newCylinders{nn1} = cylinder1;
        end
    end
    toc;
    
    
      for k = 1:numel(newCylinders)
    fig = figure;
    % scatter3(data1(:,1), data1(:,2), data1(:,3), 'k', 'filled');
    hold on;
    newCylindersa = [];
    newCylindersa{1} = newCylinders{k};
    plotAllCylinders(newCylindersa);
    lengths = getCylinderLengths(newCylindersa);
    radii = getCylinderRadii(newCylindersa);
    title(num2str(radii));
    end
    save_name_gradient = fullfile('saved_variables', [file_name(1:end-4) '_d_stats.mat']);
    save(save_name_gradient, 'lengths','radii','newCylinders');
end