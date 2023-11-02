function decoded_bits = ChannelDecoding(n ,m ,demod_data)

% Inputs:
%        n: Codeword length (Number of bits in the codeword)
%        m: Messege block length in codeword
%        coded_bits: Received bits to be decoded
% Outputs:
%        decoded_bits: Decoded data
% Description:
%        This function (channel decoding block) takes as input received codewords decode them to 
%        4-bit blocks and compute syndrom on the data to correct errors.


% Parity check matrix
r = demod_data;   % received data
r = reshape([r'; zeros(mod(-numel(demod_data),n),1)], n, [])';     % convert row vector to matrix

% Parity check matrix
I = eye(n-m);
A = [1 1 0; 0 1 1; 1 1 1; 1 0 1];
A_T = transpose(A);
H = [A_T I];

% Syndrome
S = rem(H*transpose(r), 2);

% Correct errors (in case of 1 error)
for i = 1:size(S, 2)
    for j = 1:size(H, 2)
        if S(:, i) == H(:, j)
            r(i, j) = ~r(i, j);
        end
    end
end

rec_data_blocks = r(:, 1:4);
decoded_bits = reshape(transpose(rec_data_blocks), 1, []);   % convert matrix to row vector