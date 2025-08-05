function loadDataAndProcess(filename)
open(filename);
obj = get(gca, 'children');
X = obj.XData;
Y = obj.YData;
Z = obj.ZData;
X = X';
Y = Y';
Z = Z';
data = [X, Y, Z];
findNucleosome(filename, data);
end
