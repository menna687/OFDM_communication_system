
function r= SimoSystem(y,h)
   
    
    %h1=1/sqrt(2*50)*(randn(1,50)+1i*randn(1,50));
    %h2=1/sqrt(2*50)*(randn(1,50)+1i*randn(1,50));
    %h = [h1 h2];
    w = h./norm(h);
    r= w'.*y;

    norm(w);
end
