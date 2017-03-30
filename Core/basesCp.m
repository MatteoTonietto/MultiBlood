function info = basesCp(par,info)

% Unpack
% par_struct = formatPar(par,info);
% t0 = par_struct.t0;
% T  = par_struct.T;
% 
% l0 = par_struct.l0;

l0 = par(1);
t0 = par(2);
T  = par(3);

tCp = info.tCp;
Cp  = info.Cp;
wCp = info.wCp;

% Grid Cp
%--------------------------------------------------------------------------
try 
    lambdagrid = info.lambdagrid;
    ncompl     = length(lambdagrid);   
catch
    try lambda1 = info.lambda1; catch, lambda1 = 0.0001;  end
    try lambda2 = info.lambda2; catch, lambda2 = l0*0.99; end               
    try ncompl  = info.ncompl;  catch, ncompl  = 500;    end
    
    lambdagrid  = logspace(log10(lambda1),log10(lambda2),ncompl)';  
    lambdagrid(1) = 0;
end

% Bases
%--------------------------------------------------------------------------
Gp = zeros(length(tCp),ncompl);
aPole = SimplePoleDelayConvRect([l0,t0,T],tCp);
for i = 1 : ncompl
    Gp(:,i) = SimplePoleDelayConvRect([lambdagrid(i),t0,T],tCp) - aPole;
end

% Weights
%--------------------------------------------------------------------------
GWp = Gp .* repmat(wCp,1,size(Gp,2));

% Fit
%--------------------------------------------------------------------------
A = lsqnonneg(GWp,Cp.*wCp);

% Double lines
%--------------------------------------------------------------------------
[A_good, l_good] = DoubleLine(A,lambdagrid);
info.A_good = A_good;
info.l_good = l_good;