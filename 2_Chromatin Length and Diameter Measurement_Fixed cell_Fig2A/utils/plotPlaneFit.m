function plotPlaneFit(coords, values, a, b, c, d)


    footCoords = zeros(size(coords));
    for i = 1:size(coords,1)
       
        t = (a*coords(i,1) + b*coords(i,2) + c*coords(i,3) + d) / (a^2 + b^2 + c^2);
        footCoords(i,:) = coords(i,:) - t * [a, b, c];
    end
    footValues = a*footCoords(:,1) + b*footCoords(:,2) + c*footCoords(:,3) + d;

    figure;

  
    subplot(1,3,1);
    hold on;
    for i = 1:size(coords,1)
        plot3([coords(i,1), footCoords(i,1)], [coords(i,2), footCoords(i,2)], [values(i), footValues(i)], 'k-');
    end
    xlabel('X');
    ylabel('Y');
    zlabel('Value');
    title('Projection in X-Y-Value space');
    view(2);
    hold off;

 
    subplot(1,3,2);
    hold on;
    for i = 1:size(coords,1)
        plot3([coords(i,2), footCoords(i,2)], [coords(i,3), footCoords(i,3)], [values(i), footValues(i)], 'k-');
    end
    xlabel('Y');
    ylabel('Z');
    zlabel('Value');
    title('Projection in Y-Z-Value space');
    view(2);
    hold off;

 
    subplot(1,3,3);
    hold on;
    for i = 1:size(coords,1)
        plot3([coords(i,1), footCoords(i,1)], [coords(i,3), footCoords(i,3)], [values(i), footValues(i)], 'k-');
    end
    xlabel('X');
    ylabel('Z');
    zlabel('Value');
    title('Projection in X-Z-Value space');
    view(2);
    hold off;
end
