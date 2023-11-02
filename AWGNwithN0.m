function noise =AWGNwithN0(N0,L,MT,OFDMSymbol_CP,DT)

if DT==1
    if MT==1
        noise=sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))+OFDMSymbol_CP;
    elseif MT==2
        noise=sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))+OFDMSymbol_CP; 
    elseif MT==3
        noise=sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))+OFDMSymbol_CP;
    end
elseif DT==2
    if MT==1
        noise=[sqrt(N0/2)*(randn(1,L)+1i*randn(1,L));sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))]+[OFDMSymbol_CP;OFDMSymbol_CP];
    elseif MT==2
        noise=[sqrt(N0/2)*(randn(1,L)+1i*randn(1,L));sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))]+[OFDMSymbol_CP;OFDMSymbol_CP]; 
    elseif MT==3
        noise=[sqrt(N0/2)*(randn(1,L)+1i*randn(1,L));sqrt(N0/2)*(randn(1,L)+1i*randn(1,L))]+[OFDMSymbol_CP;OFDMSymbol_CP];
    end
end
end 