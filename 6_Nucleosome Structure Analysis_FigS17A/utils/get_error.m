function [v5] = get_error(data1,xx,yy,zz)
% get_error is a function used to calculate the error between data1 and [xx yy zz]
    md2 = mean(data1);
    v3 = data1 - [xx yy zz];
    v4 = md2 - [xx yy zz];
    v5 = v3*v4';
end