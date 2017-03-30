function info = basesCmet(par,info)

% Unpack
% par_struct = formatPar(par,info);

l0 = par(1);
t0 = par(2);
T  = par(3);
t1 = par(4);

% t0 = par_struct.t0;
% T  = par_struct.T;
% l0 = par_struct.l0;
% t1 = par_struct.t1;
% 
if strcmp(info.CmetModel,'SimpleFeng')
    b0 = par(5);
end

tCmet = info.tCmet;
Cmet  = info.Cmet;
wCmet = info.wCmet;

A_good = info.A_good;
l_good = info.l_good;

t01 = t0 + t1;

% grid Cmet
%--------------------------------------------------------------------------
try
    betagrid = info.betagrid;
    ncompb   = length(betagrid);
catch
    try beta1 = info.beta1;  catch, beta1 = 10^-6; end
    try 
        beta2 = info.beta2;
    catch
        if strcmp(info.CmetModel,'SimpleFeng')
            beta2 = b0*0.99;
        else
            beta2 = 0.2;
        end
    end         
    try ncompb  = info.ncompb; catch, ncompb = 200;   end
    betagrid    = logspace(log10(beta1),log10(beta2),ncompb)';
    betagrid(1) = 0;
end

% Bases
%--------------------------------------------------------------------------
Gmet = zeros(length(tCmet),ncompb);


switch info.CmetModel
    case 'Simple'
        for i = 1 : ncompb
            l0pole = SimplePoleDelayConvRectConvExp([l0,t01,T,betagrid(i)],tCmet);
            for j = 1 : length(l_good)
                Gmet(:,i) = Gmet(:,i) + A_good(j)*(SimplePoleDelayConvRectConvExp([l_good(j),t01,T,betagrid(i)],tCmet) - l0pole);
            end
        end
        
    case 'SimpleFeng'
        b0l0_Pole = SimplePoleDelayConvRectConvExp([l0,t01,T,b0],tCmet);
        b0_Pole   = zeros(length(tCmet),length(l_good));
        
        for i = 1 : length(l_good)
            b0_Pole(:,i) = SimplePoleDelayConvRectConvExp([l_good(i),t01,T,b0],tCmet);
        end
        
        for j = 1 : ncompb
            l0_Pole = SimplePoleDelayConvRectConvExp([l0,t01,T,betagrid(j)],tCmet);
            for i = 1 : length(l_good)
                Gmet(:,j) = Gmet(:,j) + A_good(i)*(SimplePoleDelayConvRectConvExp([l_good(i),t01,T,betagrid(j)],tCmet) - l0_Pole - b0_Pole(:,i) + b0l0_Pole);
            end
        end
end


nextra = 0;

if info.PPf0
    Gmet(:,end + 1) = modelCp(par,info,tCmet);
    nextra = 1;
end
    

% Weights
%--------------------------------------------------------------------------
GWmet = Gmet .* repmat(wCmet,1,size(Gmet,2));

% Fit
%--------------------------------------------------------------------------
switch info.CmetEst
    case 'NNLS'
        B = lsqnonneg(GWmet,Cmet.*wCmet);
        
    case 'SBL'
        if nextra > 0
            OPTIONS = SB2_UserOptions('freebasis',ncompb - nextra + 1 : ncompb);
            PARAMETER = SparseBayes('Gaussian', GWmet, Cmet.*wCmet,OPTIONS); 
        else
            PARAMETER = SparseBayes('Gaussian', GWmet, Cmet.*wCmet);
        end
        B = zeros(ncompb + nextra,1);
        B(PARAMETER.Relevant) = PARAMETER.Value;
end

% Double lines
%--------------------------------------------------------------------------
[B_good, b_good] = DoubleLine(B(1 : end - nextra),betagrid);
B_good = [B_good; B(end - nextra + 1 : end)];
info.B_good = B_good;
info.b_good = b_good;
