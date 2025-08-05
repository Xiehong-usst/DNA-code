function findNucleosome(filename, data1)

    xd1 = min(data1,[],1);
    for k = 1:3
        data1(:,k) = data1(:,k) - xd1(k) + 1;
    end
    xd2 = max(data1,[],1);
    
    back1 = zeros(xd2(1),xd2(2),xd2(3));
    back2 = ones(xd2(1),xd2(2),xd2(3));
    
    R_base = 11/2;
    H_base = 5.5;
    R_sphere = H_base/2;
    
    pointn_min = 6;
    
    maxd_cut = round(12.5);
    mind_cut = 3;
    
    for k = 1:size(data1,1)
        d1k = data1(k,:);
        xx1 = d1k(1)-maxd_cut:d1k(1)+maxd_cut;
        yy1 = d1k(2)-maxd_cut:d1k(2)+maxd_cut;
        zz1 = d1k(3)-maxd_cut:d1k(3)+maxd_cut;
        xx1 = xx1(xx1 > 0);
        xx1 = xx1(xx1 <= xd2(1));
        yy1 = yy1(yy1 > 0);
        yy1 = yy1(yy1 <= xd2(2));
        zz1 = zz1(zz1 > 0);
        zz1 = zz1(zz1 <= xd2(3));
    
        for x = xx1
            for y = yy1
                for z = zz1
                    v1 = [x y z] - d1k;
                    if sum(v1.^2) < maxd_cut^2
                        back1(x,y,z) = back1(x,y,z) + 1;
                    end
                    if sum(v1.^2) < mind_cut^2
                        back2(x,y,z) = 0;
                    end
                end
            end
        end
    end
    
    back3 = back1.*back2;
    back3(back3 < pointn_min) = 0;
    
    %%
    tic;
    n1 = 0;
    n2 = 0;
    e2_all = zeros(xd2(1),xd2(2),xd2(3))+inf;
    ne_all = zeros(xd2(1),xd2(2),xd2(3))+inf;
    for xx = 1:xd2(1)
        fprintf([num2str(xx) '/' num2str(xd2(1))]);
        toc;
        tn1 = xd2(2)*xd2(3);
        e2_all_sub = zeros(1,tn1)+inf;
        ne_all_sub = zeros(1,tn1)+inf;
        back3_sub = back3(xx,:,:);
    
        for tt = 1:tn1
            yy = floor((tt - 1)/xd2(3)) + 1;
            zz = tt - (yy - 1)*xd2(3);
            if back3_sub(1,yy,zz) > 0
                [data2, v5] = get_side(data1,xx,yy,zz);
                if min(v5) < 0
                    n1 = n1 + 1;
                    O = [xx yy zz];
                    theta_res = 10; 
                    phi_res = 10; 
                    [X, Y, Z] = getHalfPointsOnSphere(O, R_sphere, theta_res, phi_res);
                    nx = numel(X);
                    e2_list = zeros(1,nx);
                    for k = 1:nx
                        P1 = [X(k) Y(k) Z(k)];
                        P2 = O*2 - P1;
                        d1 = dist_to_cylinder(data2, P1, P2, R_base);
                        ud1 = sort(d1,'ascend');
                        e2a = [];
                        for r = pointn_min:size(data2,1)
                            e2 = sum(ud1(1:r).^2)/r/(r - 1)^(1/2);
    
                            % rcut = ud1(r) + 10^(-8);
                            % nd1 = d1 < rcut;
                            % data3 = data2(nd1,:);
                            % scatter3(data3(:,1),data3(:,2),data3(:,3),50,'r','filled');
                            % md3 = mean(data3);
                            % d2 = sum((md3 - O).^2);
    
                            e2a = [e2a e2];
                        end
                        e2_list(k) = min(e2a);
                    end
                    ne = find(e2_list == min(e2_list));
                    ne = ne(1);
                    % P1 = [X(ne) Y(ne) Z(ne)];
                    e2_all_sub(tt) = min(e2_list);
                    ne_all_sub(tt) = ne;
                end
            end
        end
        for tt = 1:tn1
            yy = floor((tt - 1)/xd2(3)) + 1;
            zz = tt - (yy - 1)*xd2(3);
            e2_all(xx,yy,zz) = e2_all_sub(tt);
            ne_all(xx,yy,zz) = ne_all_sub(tt);
        end
    end
    
    %%
    % show_n = 2000;
    figure;
    e2_all_re = sort(reshape(e2_all,1,numel(e2_all)),'ascend');
    % ecut = e2_all_re(show_n);
    ecut = 2;
    nz = find(e2_all < 10^(-5) + ecut);
    scatter3(data1(:,1),data1(:,2),data1(:,3),50,'k','filled');
    title(filename);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold on;
    axis equal;
    
    data3_list = [];
    bestR_list = [];
    un1 = 0;
    
    data_new1 = [];
    
    for zu = 1:numel(nz)
        nz1 = nz(zu);
        [x1,y1,z1] = ind2sub(size(e2_all),nz1);
        O = [x1 y1 z1];
        
        theta_res = 10;
        phi_res = 10;
        [X, Y, Z] = getHalfPointsOnSphere(O, R_sphere, theta_res, phi_res);
        k1 = ne_all(x1,y1,z1);
        P1 = [X(k1) Y(k1) Z(k1)];
        P2 = O*2 - P1;
        
    
    
        
        [data2, v5] = get_side(data1,x1,y1,z1);
        d1 = dist_to_cylinder(data2, P1, P2, R_base);
        ud1 = sort(d1,'ascend');
        e1 = inf;
        e2a = [];
        r_list = pointn_min:size(data2,1);
        % r_list = 1:size(data2,1);
        for r = r_list
            e2 = sum(ud1(1:r).^2)/r/(r - 1)^(1/2);
            e2a = [e2a e2];
        end
        [~,rn1] = min(e2a);
        rn = r_list(rn1);
        rcut = ud1(rn) + 10^(-8);
        nd1 = find(d1 < rcut);
        data3 = data2(nd1,:);
    
        bestR = cylinder_fitR(data3, P1, P2);
    
        inside_ID1 = is_inside_cylinder(data2, P1, P2, bestR);
        inside_ID2 = is_inside_cylinder(data3, P1, P2, bestR);
        bad_point_tag = 0;
        if sum(inside_ID1) > sum(inside_ID2) + 1
            bad_point_tag = 1;
        end
        
        overlap_tag = 0;
        for k = 1:size(data_new1,1)
            for r = 1:size(data3,1)
                if sum((data_new1(k,:) - data3(r,:)).^2) < 10^(-5)
                    overlap_tag = 1;
                end
            end
        end
        if overlap_tag == 0 && bad_point_tag == 0
            un1 = un1 + 1;
            data3_list{un1} = data3;
            bestR_list = [bestR_list bestR];
            data_new1 = [data_new1; data3];
    
            
            plot_cylinder_with_points(P1, P2, bestR, rand(1,3)*0.7);
            scatter3(data3(:,1),data3(:,2),data3(:,3),50,'r','filled');
        end
    end
    % save_path = sprintf('./results/live/params/%s.mat', filename);
    % save(save_path, 'data3_list', 'bestR_list', 'data_new1');
    % save_path = sprintf('./results/live/figures/%s.fig', filename);
    % saveas(gcf, save_path);
end
