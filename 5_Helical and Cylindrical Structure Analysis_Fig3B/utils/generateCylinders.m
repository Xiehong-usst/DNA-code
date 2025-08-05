function [inside_pointsA, inside_pointsB] = generateCylinders(A, B, R, cutn)
    
   
    AB = B - A;
    d = norm(AB);

    
    RT = R/2;

    
    if all(AB == 0)
        error('A and B is SAME');
    end
    v1 = null(AB(:)');


    EF = v1(:,1);
    GH = v1(:,2);

   
    divisions = linspace(-RT, RT, cutn+2);
    
  
    pointsEF = zeros(cutn, 3);
    pointsGH = zeros(cutn, 3);
    for i = 2:length(divisions)-1
        pointsEF(i-1, :) = EF' * divisions(i);
        pointsGH(i-1, :) = GH' * divisions(i);
    end

   
    inside_pointsA = [];
    inside_pointsB = [];

    
    for i = 1:size(pointsEF, 1)
        for j = 1:size(pointsGH, 1)
           
            P = A + pointsEF(i,:) + pointsGH(j,:);
            
           
            if norm(P - A) <= RT
                inside_pointsA = [inside_pointsA; P]; 
                inside_pointsB = [inside_pointsB; P-A+B]; 
            end
        end
    end
end
