function [k] = loadDataAndProcess2(filename)
  
    parts = split(filename, '_');
    
  
    areaPart = [];
    for i = 1:length(parts)
        if startsWith(parts{i}, 'area')
            areaPart = parts{i};
            break;
        end
    end
    
    if isempty(areaPart)
        error('No areaXX found in the filename!');
    end

  
    k = regexp(areaPart, '\d+', 'match');
    if isempty(k)
        error('No number found in the areaXX part!');
    end
    k = k{1};
end
