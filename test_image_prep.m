% prepares a simple test case for the code

a = ones(100, 10, 'uint8') * 95;
b = ones(100, 10, 'uint8') * 240;
c = [a, b];

I = repmat(c, 1, 5);
M = ones(100, 100);
M(30:40, 15:25)=0;

clear a b c