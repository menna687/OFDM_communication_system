function decimal = gc2dec(graycode)


prev=graycode(1);
binary = prev;
for i=2:length(graycode)   
    binary = [binary  char(double(xor(prev-48,graycode(i)-48))+48)];
    prev = xor(prev-48,graycode(i)-48);
    if (prev == 1)
        prev = '1';
    else
        prev = '0';
    end
end

decimal = bin2dec(binary);

end