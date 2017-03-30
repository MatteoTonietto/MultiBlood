function yCmet = modelCmet(par,info,t)

% Unpack
l0 = par(1);
t0 = par(2);
T  = par(3);
t1 = par(4);

if strcmp(info.CmetModel,'SimpleFeng')
    b0 = par(5);
end

% Linear parameters
A_good = info.A_good;
l_good = info.l_good;
B_good = info.B_good;
b_good = info.b_good;

t01 = t0 + t1;

% Memory allocation
Gmet_good = zeros(length(t),length(b_good));

% Model construction
%--------------------------------------------------------------------------


switch info.CmetModel
    case 'Simple'
        for i = 1 : length(b_good)
            l0Pole = SimplePoleDelayConvRectConvExp([l0,t01,T,b_good(i)],t);
            for j = 1 : length(l_good)
                Gmet_good(:,i) = Gmet_good(:,i) + A_good(j)*(SimplePoleDelayConvRectConvExp([l_good(j),t01,T,b_good(i)],t) - l0Pole);
            end
            
        end
        
    case 'SimpleFeng'
        b0l0_Pole = SimplePoleDelayConvRectConvExp([l0,t01,T,b0],t);
        b0_Pole   = zeros(length(t),length(l_good));
        
        for i = 1 : length(l_good)
            b0_Pole(:,i) = SimplePoleDelayConvRectConvExp([l_good(i),t01,T,b0],t);
        end
        
        for j = 1 : length(b_good)
            l0_Pole = SimplePoleDelayConvRectConvExp([l0,t01,T,b_good(j)],t);
            for i = 1 : length(l_good)
                Gmet_good(:,j) = Gmet_good(:,j) + A_good(i)*(SimplePoleDelayConvRectConvExp([l_good(i),t01,T,b_good(j)],t) - l0_Pole - b0_Pole(:,i) + b0l0_Pole);
            end
        end
end



if info.PPf0
    Gmet_good(:,end + 1) = modelCp(par,info,t); 
end

% Output
%--------------------------------------------------------------------------
yCmet  = Gmet_good * B_good;

