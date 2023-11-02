function No=Calc_No(Eb_No_dB,Mod_type)
% assumption : A^2 & Ts/2 = 1
Eb_No_linear = 10.^(Eb_No_dB./10);      % linear scale

if Mod_type == 1     % QPSK
    M=4;
     Eb = 1/(log2(M));     
 elseif Mod_type == 2    % 16QAM  
     M=16;
     Eb = 2*(M-1)/(3*log2(M));
elseif Mod_type == 3    %64QAM
    M=64;
    Eb = 2*(M-1)/(3*log2(M));
end

No = Eb./Eb_No_linear;     % PSD noise (No)

end