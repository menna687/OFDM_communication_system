function coded_bits = ChannelCoding(bit_seq ,n ,m)

%{
Inputs:
       bit_seq: Data bits
       n: Codeword length (Number of bits in the codeword)
       m: Messege block length in codeword
Outputs:
       coded_bits: Encoded data
Description:
       This function (channel coding block) takes as input the raw data bits ,performs
       a linear block coding operation which takes an input of 4-bit block and map it into a 7-bit codeword
       by multiplying by a 7 × 4 generator matrix to produce a set of coded bits. 
%}


% Generator matrix
I = eye(m);   % Identity matrix
A = [1 1 0; 0 1 1; 1 1 1; 1 0 1];   % Parity matrix   
G = [I A];

% Split data bits into blocks of lenght m 
% (pad with zeros if length(bit_seq) is not divisible by 4)
data_blocks = reshape([bit_seq(:); zeros(mod(-numel(bit_seq),m),1)], m, [])';

% Generate codewords
coded_bits = rem(data_blocks * G, 2); 
coded_bits = reshape(transpose(coded_bits), 1, []);     % convert matrix to row vector