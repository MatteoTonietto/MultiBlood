function yCp = modelCp(par,info,t)

% Unpack
l0 = par(1);
t0 = par(2);
T  = par(3);

% Linear parameters
A_good = info.A_good;
l_good = info.l_good;

% Memory allocation
Gp_good = zeros(length(t),length(A_good));

% Model construction
%--------------------------------------------------------------------------
aPole = SimplePoleDelayConvRect([l0,t0,T],t);
for i = 1 : length(l_good)
    Gp_good(:,i) = SimplePoleDelayConvRect([l_good(i),t0,T],t) - aPole;
end

% Output
%--------------------------------------------------------------------------
yCp = Gp_good * A_good;