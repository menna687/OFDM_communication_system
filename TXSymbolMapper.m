function mod_symbols = TXSymbolMapper(coded_bits ,Mod_type)

% Inputs:
%        N_bits: Total number of bits
%        coded_bits: encoded bits to be symbols
%        Mod_type: Type of modulation technique (1: QPSK , 2: 16QAM , 3: 64QAM)
% Outputs:
%        mod_symbols: Modulated symbols
% Description:
%        This function (symbol mapper block) takes the coded bits and produces a corresponding 
%        set of modulation symbols according to the modulation technique used (QPSK ,16QAM ,64QAM)
 

if Mod_type == 1     %QPSK
    %extend if not even
    if mod(length(coded_bits),2) == 1
        coded_bits=[coded_bits 0];
    end
     % polar NRZ
     m_polar = 2*coded_bits - 1;

     % Demultiplexing input into even and odd streams
     even_bit_stream = m_polar(1:2:end);  % even indeces
     odd_bit_stream = m_polar(2:2:end);   % odd indeces

     mod_symbols = (1/sqrt(2))*(even_bit_stream + i*odd_bit_stream); 
        
elseif Mod_type == 2
    M = 16;               %number of symbols  

elseif Mod_type == 3
    M = 64;               %number of symbols      
end
    
if (Mod_type == 2 || Mod_type == 3)      % 16QAM or 64QAM
        K = log2(M);          %number of bits per symbol
        
        %extend coded bits if the number of coded bits is not multiple of K
        if(mod(length(coded_bits),K) ~= 0)
            new_coded_bits = [coded_bits zeros(1,K-mod(length(coded_bits),K))];
        else
            new_coded_bits = coded_bits;
        end

        
        mod_symbols = zeros(1,length(new_coded_bits)/K);
        
        for c = 1:length(mod_symbols)
            %index of the start of each symbol
            first_num_index = (K*(c-1))+1;
            
            %get the first K/2 bits for the inphase carrier
            gray = reshape(char(new_coded_bits(first_num_index:first_num_index+(K/2)-1)+48),[1,K/2]);
            % convert gray symbol to decimal
            horz = gc2dec(gray);
            
            %get the last K/2 bits for the quadrature carrier
            gray = reshape(char(new_coded_bits(first_num_index+K/2:first_num_index+K-1)+48),[1,K/2]);
            % convert gray symbol to decimal
            vert = gc2dec(gray);
           
            % Getting inphase component (Branch 1) & quadrature component (Branch 2)
            inphase = 2*(horz+1)-1-sqrt(M);
            quad = 2*(vert+1)-1-sqrt(M);
            
            mod_symbols(c) = inphase + i*quad;
        end

end
