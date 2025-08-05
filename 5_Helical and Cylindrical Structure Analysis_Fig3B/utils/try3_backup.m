load('cylindern1.mat');
xd1 = min(data1,[],1);
for k = 1:3
    data1(:,k) = data1(:,k) - xd1(k) + 1;
end
data1 = data1*2;%%%%%%%%%%%%%%%%%%%%%%%%%%%%notice
xd2 = max(data1,[],1);

back1 = zeros(xd2(1),xd2(2),xd2(3));
back2 = ones(xd2(1),xd2(2),xd2(3));

R_base = 11;

for k = 1:size(data1,1)
    d1k = data1(k,:);
    xx1 = d1k(1)-25:d1k(1)+25;
    yy1 = d1k(2)-25:d1k(2)+25;
    zz1 = d1k(3)-25:d1k(3)+25;
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
                if sum(v1.^2) < 25^2
                    back1(x,y,z) = back1(x,y,z) + 1;
                end
                if sum(v1.^2) < 4^2
                    back2(x,y,z) = 0;
                end
            end
        end
    end
end

back3 = back1.*back2;
back3(back3 < 6) = 0;

%%
n1 = 0;
% tic;
e2_all = zeros(xd2(1),xd2(2),xd2(3))+inf;
ne_all = zeros(xd2(1),xd2(2),xd2(3))+inf;
for xx = 1:xd2(1)
    for yy = 1:xd2(2)
        % if n1 == 0 && yy == 2
        %     toc;
        % end
        % fprintf('-');
        for zz = 1:xd2(3)
            if back3(xx,yy,zz) > 0
                [data2, v5] = get_side(data1,xx,yy,zz);
                if min(v5) < 0
                    n1 = n1 + 1;
                    O = [xx yy zz];
                    R_sphere = 6;
                    theta_res = 10; 
                    phi_res = 10; 
                    [X, Y, Z, theta_list, phi_list] = generatePointsOnSphere(O, R_sphere, theta_res, phi_res);
                    nx = numel(X);
                    X = reshape(X,[1,nx]);
                    Y = reshape(Y,[1,nx]);
                    Z = reshape(Z,[1,nx]);
                    nz = find(Z >= zz);
                    X = X(nz);
                    Y = Y(nz);
                    Z = Z(nz);
                    nx = numel(X);
                    e2_list = zeros(1,nx);
                    parfor k = 1:nx
                        P1 = [X(k) Y(k) Z(k)];
                        P2 = O*2 - P1;
                        d1 = dist_to_cylinder(data2, P1, P2, R_base);
                        ud1 = sort(d1,'descend');
                        e1 = inf;
                        e2a = [];
                        for r = 6:size(data2,1)
                            e2 = sum(ud1(1:r).^2)/r;
                            e2a = [e2a e2];
                        end
                        e2_list(k) = min(e2a);
                    end
                    ne = find(e2_list == min(e2_list));
                    ne = ne(1);
                    P1 = [X(ne) Y(ne) Z(ne)];
                    e2_all(xx,yy,zz) = min(e2_list);
                    ne_all(xx,yy,zz) = ne;
                end
            end
        end
    end
end



% figure;
