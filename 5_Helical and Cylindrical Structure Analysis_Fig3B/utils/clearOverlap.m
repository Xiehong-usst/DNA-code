function data_new = clearOverlap(data)
% clearOverlap is a function used to delete duplicate elements in the array
%{
    input:
        data: Nx3 matrix, each row represents a point (x, y, z)
    output:
        data_new: Mx3 matrix, each row represents a point (x, y, z)
%}
    data_new = [];    

    for r = 1:size(data,1)
        overlap_tag = 0;
        for k = 1:size(data_new,1)
            if sum((data_new(k,:) - data(r,:)).^2) < 10^(-5)
                overlap_tag = 1;
                break;
            end
        end
        if overlap_tag == 0
            data_new = [data_new; data(r,:)];
        end
    end
end