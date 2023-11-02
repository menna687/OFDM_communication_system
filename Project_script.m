%%
clc 
clear all
close all
%% 
% Electrical and Electronic Engineering Department
% 
% Final Project : Building semi-complete communication system based on OFDM
%% Parameters
m = 4;      % Messege block length
n = 7;      % Codeword length

%Mod_type = 2;    % Options --> (1: QPSK , 2: 16QAM , 3: 64QAM)


Eb_No_dB = -20:3:20;       % (Eb/No) dB range 

Num_frame_per_EbNo=5;
% BER = zeros(1,14);
BER = [];
Case = 0;
Mod_type = 1;
if Mod_type == 1
N_bits = 1168;       % Total number of bits for QPSK
elseif Mod_type == 2
    N_bits = 2340;       % Total number of bits for 16QAM
elseif Mod_type == 3
    N_bits = 3508;       % Total number of bits fo 64QAM
end
DT=2;
CM=2;
%% 

for Mod_type=1:3
    if Mod_type == 1
    N_bits = 1168;       % Total number of bits for QPSK
    elseif Mod_type == 2
        N_bits = 2340;       % Total number of bits for 16QAM
    elseif Mod_type == 3
        N_bits = 3508;       % Total number of bits fo 64QAM
    end
    Mod_type
     %for DT=1:2      %1 -> siso ,, 2 -> simo
        DT
         %for CM=1:2 %1 -> AWGN ,, 2->Multi-path fading channel 
            CM
            Case=Case+1;
            for Eb_No=Eb_No_dB
                % Generating a sequence of bits equal to the total number of bits
                % Initializing sum of probability of error over frames to zero
                sum_prob_error=0;
                sum_prob_error2=0;
                Eb_No
                
            for frame=1:Num_frame_per_EbNo
                    
                        frame
                    

                    bit_seq = randi([0 1],100,N_bits);

                    No = Calc_No(Eb_No,Mod_type);
                    % Pass the bit sequence through the channel coding block
                    %coded_bits = ChannelCoding(bit_seq ,n ,m);

                    % Pass the coded bits through channel coding and symbol mapper blocks
                    coded_bits=[];
                    mod_symbols=[];
                    for k=1:100
                        code = ChannelCoding(bit_seq(k,:) ,n ,m);
                        if Mod_type==1
                            code=[code zeros(1,2048-length(code))];
                        end
                        coded_bits=[coded_bits ; code];
                        mod_symbols=[mod_symbols; TXSymbolMapper(code ,Mod_type)];
                    end

                    %%
                    % Generating OFDM symbols
                    OFDMsymbols=[];
                    mod_symbols = mod_symbols.*sqrt(1024);
                    for k=1:100
                        OFDMsymbols=[OFDMsymbols ; ifft(mod_symbols(k,:))];
                    end


                    %% Adding cyclic-prefix
                    symbolSize=1024;
                    meo=50;
                    TRANSvector=addCP(OFDMsymbols,meo);

                    %% channel
                    if CM==1
                        y=AWGNwithN0(No,length(TRANSvector),Mod_type,TRANSvector,DT);
                    else
                        [y,channelresponse,ph1 , ph2]=RayleighFading(DT,TRANSvector,No,Mod_type);
                    end
                    %
                    
                    %% SISO system
                    
                    if CM == 2 && DT==1 %siso fading 
                        h1=[channelresponse zeros(1,length(y)-50)];
                        
                        y=ifft(fft(y)./(fft(h1)));
                        y=y(1:length(y)-49);
                    end
                    %% SIMO system
                    if CM == 2 && DT==2 %simo fading
                        h1=[channelresponse(1,:) zeros(1,length(y)-50)];
                        h2=[channelresponse(2,:) zeros(1,length(y)-50)];
                        y(1,:)=ifft(fft(y(1,:))./(fft(h1)));
                        y(2,:)=ifft(fft(y(2,:))./(fft(h2)));
                        y=y(:,1:length(y)-49);
                        channelresponse=[channelresponse(1,:) channelresponse(2,:)];

                    end
                

                    %% removing cyclic-prefix

                    %RECvector = removeCP(noise,symbolSize,meo);
                    if DT==1 %siso
                        RECvector = removeCP(y(1,:),symbolSize,meo);
                    elseif DT==2
                        if CM==1
                        RECvector = removeCP(y(1,:),symbolSize,meo);
                        RECvector2= removeCP(y(2,:),symbolSize,meo);
                        RECvector=[RECvector;RECvector2];
                        end
                    end
                    if DT==2
                        if CM==2
                            RECvector = removeCP(y(1,:),symbolSize,meo);
                            RECvector2= removeCP(y(2,:),symbolSize,meo);
                            RECvector =[RECvector;RECvector2];
                        end
                    end
                    %RECvectorAWGNChannel =[RECvectorAWGNChannel; removeCP(y(2,:),symbolSize,meo)];



                    %% SIMO system at reciever
                   %if CM==2
                        %if DT==2
                             % REC = SimoSystem(RECvector,channelresponse);
                        %end
                   %end
                  

                    %% fft
                    %dem_symbols_Fading =[];
                    dem_symbols =  [];
                    dem_symbols2 =  [];
                    RECvector = RECvector./sqrt(1024);
                        for k=1:100
                           % dem_symbols_Fading=[dem_symbols_Fading;fft(REC(k,:))];
                            dem_symbols=[    dem_symbols  ;    fft(  RECvector(k,:)  )  ];
                        end
                        if(DT == 2 )
                            for k=101:200
                               % dem_symbols_Fading=[dem_symbols_Fading;fft(REC(k,:))];
                                dem_symbols2=[    dem_symbols2  ;    fft(  RECvector(k,:)  )  ];
                            end
                        end

                    %dem_symbols_AWGN =  reshape(dem_symbols_AWGN(:), [], 2).';  

                    %%
                    %Demodulate codewords from received symbols
                    demod_data=[];
                    demod_data2=[];
                    for k=1:100
                        %demod_data=[demod_data;RXSymbolMapper(N_bits ,n ,m ,dem_symbols_Fading(k,:) ,Mod_type)];
                        demod_data=[demod_data;RXSymbolMapper(N_bits ,n ,m ,dem_symbols(k,:),Mod_type)];
                    end
                    if(DT == 2) 
                        for k=1:100
                            %demod_data=[demod_data;RXSymbolMapper(N_bits ,n ,m ,dem_symbols_Fading(k,:) ,Mod_type)];
                            demod_data2=[demod_data2;RXSymbolMapper(N_bits ,n ,m ,dem_symbols2(k,:),Mod_type)];
                        end
                    end
                     %demod_data = RXSymbolMapper(N_bits ,n ,m ,mod_symbols ,Mod_type);

                    %%
                    %Decode bits from demodulated codeword
                    decoded_bits=[];
                    decoded_bits2=[];
                    for k=1:100
                        decoded_bits=[decoded_bits;ChannelDecoding(n ,m ,demod_data(k,:))];
                    end
                
                    if(DT == 2)
                        for k=1:100
                            decoded_bits2=[decoded_bits2;ChannelDecoding(n ,m ,demod_data2(k,:))];
                        end
                    end
                    %decoded_bits = ChannelDecoding(n ,m ,demod_data);
                    %BER calculation
                    prob_error_frame = sum(sum(xor(bit_seq,decoded_bits)))/(N_bits*100);
                    sum_prob_error = sum_prob_error + prob_error_frame;
                    if(DT == 2 )
                        prob_error_frame2 = sum(sum(xor(bit_seq,decoded_bits2)))/(N_bits*100);

                        sum_prob_error2 = sum_prob_error2 + prob_error_frame2;
                    end
                    
                end
                %BER(1,Eb_No/3+1) = sum_prob_error/Num_frame_per_EbNo;
                %if sum(sum_prob_error)==0
                    %break
                %end
               if DT==1
               BER = [BER sum_prob_error/Num_frame_per_EbNo];
               end
                if DT == 2
        
                    if sum_prob_error>sum_prob_error2
                        BER = [BER sum_prob_error/Num_frame_per_EbNo];
                    elseif sum_prob_error<sum_prob_error2
                        BER = [BER sum_prob_error2/Num_frame_per_EbNo];
                    else
                        BER = [BER sum_prob_error/Num_frame_per_EbNo];
                    end
                end 
            %end
        end
     end
%end
%%
BER=[BER(1:14);BER(15:28);BER(29:42)];
string=["QPSK-SISO-AWGN","QPSK-SISO-fading","QPSK-SIMO-AWGN","QPSK-SIMO-fading","16QAM-SISO-AWGN","16QAM-SISO-fading","16QAM-SIMO-AWGN","16QAM-SIMO-fading","64QAM-SISO-AWGN","64QAM-SISO-fading","64QAM-SIMO-AWGN","64QAM-SIMO-fading"];
%for k=1:3
figure
semilogy(Eb_No_dB,BER,'linewidth',2,'marker','o');
xlabel('Eb/No (dB)')
ylabel('BER')
ylim([0 0.6])
%title(string((k-1)*3+1));
grid on
%end
 legend(string(4),string(8),string(12));