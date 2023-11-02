function graycode = dec2gc(decimal,K)

binary = dec2bin(decimal);
prev = binary(1);
graycode = prev;
for i=2:length(binary)
    graycode = [graycode  char(double(xor(prev-48,binary(i)-48))+48)];
    prev = binary(i);
end

while(length(graycode)<K)
    graycode = ['0' graycode];
end
end