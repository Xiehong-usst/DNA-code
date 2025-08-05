function data1 = loadDataAndProcess(filename)
    
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

   
    load(filename);

    
    variable_name = strcat('area', k, '_loc_ori');
    if ~exist(variable_name, 'var')
        error('Variable %s not found in the file!', variable_name);
    end
    data = eval(variable_name);

    data1 = data * 3;  
end
