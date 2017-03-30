function y = HillExtended(par,~,t)

if nargin < 1
    y = 4;
else
    a = par(1);
    b = par(2);
    c = par(3);
    d = par(4);
    
    y =  1 - ((-a + (1-b).*t)./((c./t).^d + 1));
end
