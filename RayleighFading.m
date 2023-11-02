function [noise,channelresponse, phase1, phase2]=RayleighFading(DT,OFDMSymbol_CP,N0,MT)
h1=1/sqrt(2*50)*(randn(1,50)+1i*randn(1,50));
h2=1/sqrt(2*50)*(randn(1,50)+1i*randn(1,50));
h_simo=[h1; h2];

if DT==1

    noise_symbol=conv(OFDMSymbol_CP,h1);
    noise=noise_symbol;
    noise=AWGNwithN0(N0,length(noise_symbol),MT,noise_symbol,DT);
    channelresponse=h1;
    phase1=zeros(1,length(noise_symbol));
    for i=1:length(noise_symbol)
        phase1(1,i)=CartoPolar(noise_symbol(1,i));
    end
    phase2=0;
elseif DT==2
    noise_symbol1=conv(h1,OFDMSymbol_CP);
    noise_symbol2=conv(h2,OFDMSymbol_CP);
    
    noise_symbol1=AWGNwithN0(N0,length(noise_symbol1),MT,noise_symbol1,1);
    noise_symbol2=AWGNwithN0(N0,length(noise_symbol2),MT,noise_symbol2,1);
    noise=[noise_symbol1;noise_symbol2];
    channelresponse=h_simo;
    phase1=zeros(1,length(noise_symbol1));
    for i=1:length(noise_symbol1)
        phase1(1,i)=CartoPolar(noise_symbol1(1,i));
    end
    phase2=zeros(1,length(noise_symbol2));
    for i=1:length(noise_symbol2)
        phase1(1,i)=CartoPolar(noise_symbol2(1,i));
    end
end
end 
