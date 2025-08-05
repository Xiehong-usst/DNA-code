function [data2, v5] = get_side(data1,xx,yy,zz)
% get_side is a function used to select subset data2 from data1 that satisfies certain conditions and calculate the error between it and the given point [xx yy zz]
    v1 = data1 - [xx yy zz];
    v2 = sum(v1'.^2);
    n2 = v2 < 25^2;
    data2 = data1(n2,:);
    md2 = mean(data2);
    v3 = data2 - [xx yy zz];
    v4 = md2 - [xx yy zz];
    v5 = v3*v4';
end