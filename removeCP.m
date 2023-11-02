function [ recoveredVector] = removeCP(Vector,symbolSize,meo)
    unit = symbolSize + meo;
    recoveredVector = [];
     recoveredVector2 = [];
    vectorSize= length(Vector);
    numberOfIterations = vectorSize / unit;
    
 
    for k = 0 : numberOfIterations-1
       recoveredVector = [recoveredVector; Vector(k*unit+meo+1 : (k+1)*unit)]; 
    end
%     for i = 0 : numberOfIterations-1
%        recoveredVector2 = [recoveredVector2 Vector(2,i*unit+meo+1 : (i+1)*unit)]; 
%     end
%     recoveredVector = [recoveredVector1;recoveredVector2];
%     if DT==1
%         recoveredVector = [reshape(recoveredVector1',[], 100)];
%     else
%         recoveredVector = [reshape(recoveredVector1',[], 100)  reshape(recoveredVector2',[] , 100) ];
%     end
    %recoveredVector2 = reshape(recoveredVector2,[],symbolSize);
end
