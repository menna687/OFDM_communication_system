function [phase]=CartoPolar(var)
a=real(var);
b=imag(var);
%%magnitude=sqrt(a^2+b^2);
if a>0 && b>0
    angle=(atan(abs(b/a)))*180/pi;  
elseif a<0 && b>0
    angle=180-((atan(abs(b/a)))*180/pi);   
elseif a<0 && b<0
    angle=180+((atan(abs(b/a)))*180/pi);
elseif a>0 && b<0
    angle=-((atan(abs(b/a)))*180/pi); 
end
phase=angle;
end 
