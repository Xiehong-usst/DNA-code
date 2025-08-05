function [bestA, bestB, bestRadius, besti, bestj, globalMinError] = findBestAxis(points, X, Y, Z)

    [numRows, numCols] = size(X);
    numIterations = numRows * numCols;

    allErrors = Inf(numIterations, 1);
    allRadii = zeros(numIterations, 1);
    allAs = zeros(numIterations, 3);
    allBs = zeros(numIterations, 3);
    allJs = zeros(numIterations, 1);

    for i = 1:numIterations
        A = [X(i), Y(i), Z(i)];
        localBestB = [0, 0, 0];
        localBestRadius = 0;
        localMinError = Inf;
        localBestj = 0;

        for j = 1:numIterations
            if i ~= j  
                B = [X(j), Y(j), Z(j)];
                [radius, error] = computeRadiusGivenAxis(points, A, B);

                if error < localMinError
                    localBestj = j;
                    localBestB = B;
                    localBestRadius = radius;
                    localMinError = error;
                end
            end
        end

        allErrors(i) = localMinError;
        allRadii(i) = localBestRadius;
        allAs(i, :) = A;
        allBs(i, :) = localBestB;
        allJs(i) = localBestj;
    end

   
    [~, idx] = min(allErrors);
    bestA = allAs(idx, :);
    bestB = allBs(idx, :);
    bestRadius = allRadii(idx);
    globalMinError = allErrors(idx);
    besti = idx;
    bestj = allJs(idx);
end
