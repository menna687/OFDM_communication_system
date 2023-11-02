function demod_data = RXSymbolMapper(N_bits ,n ,m ,mod_symbols ,Mod_type)

% Inputs:
%        N_bits: Total number of bits
%        n: Codeword length (Number of bits in the codeword)
%        m: Messege block length in codeword
%        mod_symbols: Received symbols to be decoded
%        Mod_type: Type of demodulation technique (1: QPSK , 2: 16QAM , 3: 64QAM)
% Outputs:
%        demod_data: Decoded data
% Description:
%        This function (demodulation block) takes as input received symbols , 
%        demodulate them to codewords 

if Mod_type == 1       %QPSK
     r1 = real(mod_symbols);
     r2 = imag(mod_symbols);
     threshold = 0;

     r1_demod = r1>threshold;
     r2_demod = r2>threshold;

     % Multiplexing output odd and even streams
     %demod_data = zeros(1,1024*2);
     demod_data = zeros(1,length(mod_symbols)*2);
     demod_data(1:2:end) = r1_demod;
     demod_data(2:2:end) = r2_demod;
     if length(demod_data)~= ceil(N_bits+N_bits/m*(n-m))
         demod_data = demod_data(1:ceil(N_bits+N_bits/m*(n-m)));
     end
        
elseif Mod_type == 2
    M = 16;               %number of symbols  

elseif Mod_type == 3
    M = 64;               %number of symbols      
end
    
if (Mod_type == 2 || Mod_type == 3)      % 16QAM or 64QAM
        K = log2(M);          %number of bits per symbol
        
        demod_qam = mod_symbols;
        estimated = -(sqrt(M)-1):2:(sqrt(M)-1);
        threshold = estimated(1,2:end)-1;
        threshold = [-Inf threshold Inf];

        demod_data = zeros(1,length(mod_symbols)*K);
        check = 0;
        for c = 1:length(demod_qam)
            first_num_index = (K*(c-1))+1;

            inphase = real(demod_qam(c));
            quad = imag(demod_qam(c));

            for j=1:sqrt(M)
                if(inphase >= threshold(j) && inphase < threshold(j+1))
                    inphase = estimated(j);
                    check = check+1;
                end
                if(quad >= threshold(j) && quad < threshold(j+1))
                    quad = estimated(j);
                    check = check+1;
                end
                if(check == 2)
                    check=0;
                    break;
                end
            end

            horz = ((inphase+sqrt(M)+1)/2)-1;
            vert = ((quad+sqrt(M)+1)/2)-1; 

            horz_gc = dec2gc(horz,K/2);
            vert_gc = dec2gc(vert,K/2);
            for j=1:K/2
                demod_data(first_num_index+j-1) = double(horz_gc(j)-48);
            end
            for j=(K/2)+1:K
                demod_data(first_num_index+j-1) = double(vert_gc(j-(K/2))-48);
            end
        end
        
        if length(demod_data)~= ceil(N_bits+N_bits/m*(n-m))
            demod_data = demod_data(1:ceil(N_bits+N_bits/m*(n-m)));
        end
end
