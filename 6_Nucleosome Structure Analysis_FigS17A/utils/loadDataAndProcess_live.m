function loadDataAndProcess_live(filename)
% loadDataAndProcess_live is a function used to process live cell image data and call fitting function findNucleosome
    open(filename);
    obj = get(gca, 'children');
    X = obj.XData;
    Y = obj.YData;
    Z = obj.ZData;
    X = X';
    Y = Y';
    Z = Z';
    data = [X, Y, Z];
    findNucleosome_live(filename, data);
end
