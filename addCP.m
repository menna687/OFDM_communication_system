
function [resultVector] = addCP(Vector,meo)
    [numberOfIterations symbolSize] =size(Vector);
    %SeriesVector = reshape(Vector,1,[]);
    SeriesVector = reshape(Vector.',1,[]);
    resultVector = [];
    vectorSize= length(SeriesVector);
    for k = 0 : numberOfIterations-1
        resultVector = [resultVector SeriesVector(k*symbolSize+symbolSize-meo+1 : (k+1)*symbolSize)];
        resultVector = [resultVector SeriesVector(k*symbolSize+1 : (k+1)*symbolSize)];
    end
    
end
