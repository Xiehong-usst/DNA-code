function [a, b, c, d] = computeGradientLSQ(coords, values)

    n = size(coords, 1);


    A = [coords, ones(n, 1)]; % [x y z 1]


    params = A \ values;

  
    a = params(1);
    b = params(2);
    c = params(3);
    d = params(4);
end
