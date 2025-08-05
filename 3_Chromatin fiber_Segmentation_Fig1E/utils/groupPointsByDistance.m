function groupedPoints = groupPointsByDistance(P, A, B, d)

groupedPoints = {};


AB = B - A;
AB_length = norm(AB);
AB_unit = AB / AB_length;


for i = 1:size(P, 1)

AP = P(i, :) - A;


proj_length = dot(AP, AB_unit);


distance = proj_length;
groupIndex = ceil(distance / d);


if groupIndex > length(groupedPoints) || isempty(groupedPoints{groupIndex})
groupedPoints{groupIndex} = [];
end


groupedPoints{groupIndex} = [groupedPoints{groupIndex}; P(i, :)];
end
end
