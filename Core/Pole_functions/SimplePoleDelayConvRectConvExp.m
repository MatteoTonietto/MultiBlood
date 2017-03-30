% Simple Pole a with Delay t0 convoluted with a Rectangular function of 
% lenght T, convoluted with an Exponential b.
% It handles the special cases of b=0 and a=b
%
% h = exp[-a(t-t0)]    Simple Pole with delay
% u = [1(t)-1(t-T)]    translated rectangular function
% v = exp(-b t)        exponential
%
% y = h * u * v

function [y,J] = SimplePoleDelayConvRectConvExp(par,t)

a  = par(1);   % exponent
t0 = par(2);   % delay
T  = par(3);   % length of rect
b  = par(4);   % second exponent

tp = t0 + T;

tt0 = t - t0;
ttp = t - tp;
exp_at0 = exp(-a*tt0);
exp_bt0 = exp(-b*tt0);
exp_atp = exp(-a*ttp);
exp_btp = exp(-b*ttp);

idx01 = t < t0 | t > tp;
idx02 = t <= tp;

if a==0 && b==0
    % t > t0 && t <= T + t0
    y1 = tt0.^2;
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = tt0.^2 - ttp.^2;
    
    den = 2;   

elseif b==0
    % t > t0 && t <= T + t0
    y1 = exp_at0 + a*tt0 - 1;
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = exp_at0 - exp_atp + a*T;
    
    den = a^2;
    
    if nargout > 1
        
        J1(:,1) = (2 - a*tt0 - (2 + a*tt0).*exp_at0)/a^3;
        J1(:,2) = (exp_at0 - 1)/a;
        J1(:,3) = zeros(size(t));
        J1(:,4) = (a*(2 - a*tt0).*tt0 + 2*exp_at0 - 2)/(2*a^3);
         
        J2(:,1) = ((2 + a*ttp).*exp_atp -a*T - (2 + a*tt0).*exp_at0)/a^3; 
        J2(:,2) = (exp_at0 - exp_atp)/a;
        J2(:,3) = (1 - exp_atp)/a;
        J2(:,4) = (a*T*(2 + a*(T - 2*tt0)) + 2*exp_at0 - 2*exp_atp)/(2*a^3);
        
        J1(idx01,:) = 0;
        J2(idx02,:) = 0;
        
        J = J1 + J2;
    end
elseif a==0
    % t > t0 && t <= T + t0
    y1 = exp_bt0 + b*tt0 - 1;
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = exp_bt0 - exp_btp + b*T;
    
    den = b^2;
     
elseif b==a
    % t > t0 && t <= T + t0
    y1 = 1 - exp_at0.*(1 + a*tt0);
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = exp_atp.*(1 + a*ttp) - exp_at0.*(1 + a*tt0);
    
    den = a^2;

    if nargout > 1
        J1(:,1) = (-2 + (2 + a*(2 + a*tt0).*tt0).*exp_at0)/(2*a^3);
        J1(:,2) = -tt0.*exp_at0;
        J1(:,3) = zeros(size(t));
        J1(:,4) = J1(:,1);
        
        J2(:,1) = ((2 + a*(2 + a*tt0).*tt0).*exp_at0 - (2 + 2*a*ttp + a^2*ttp.^2).*exp_atp)/(2*a^3);        
        J2(:,2) = ttp.*exp_atp - tt0.*exp_at0;
        J2(:,3) = ttp.*exp_atp;
        J2(:,4) = J2(:,1);
        
        J1(idx01,:) = 0;
        J2(idx02,:) = 0;
        
        J = J1 + J2;
    end
    
else
    % t > t0 && t <= T + t0
    y1 = a*(1 - exp_bt0) - b*(1 - exp_at0);
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = a*(exp_btp - exp_bt0) - b*(exp_atp - exp_at0);
    
    den = a*b*(a - b);
    
    if nargout > 1
        J1(:,1) = (b*(b - a*(2 + (a-b)*tt0)).*exp_at0 + a^2*exp_bt0 -(a-b)^2)/(a^2*(a-b)^2*b);
        J1(:,2) = (exp_at0 - exp_bt0)/(a-b);
        J1(:,3) = zeros(size(t));
        J1(:,4) = (-(a-b)^2 + a^2*exp_bt0 + b*(b*exp_at0 + a*( -2 + (a-b)*tt0).*exp_bt0)) /(a*(a-b)^2*b^2);
        
        J2(:,1) = (b*(b+a*(-2-(a-b)*tt0)).*exp_at0-b*(b+a*(-2-(a-b)*ttp)).*exp_atp+a^2*(exp_bt0-exp_btp))/(a^2*(a-b)^2*b);
        J2(:,2) = (exp_at0 - exp_atp - exp_bt0+exp_btp)/(a - b);
        J2(:,3) = (exp_btp - exp_atp)/(a - b);
        J2(:,4) = (a^2*exp_bt0 + b*(b*exp_at0 - b*exp_atp + a*(-2+(a-b)*tt0).*exp_bt0) - a*(a*(1+b*ttp) - b*(2+b*ttp)).*exp_btp)/(a*(a-b)^2*b^2);
        
        J1(idx01,:) = 0;
        J2(idx02,:) = 0;
        
        J = J1 + J2;
    end
end

y1 = y1/den;
y2 = y2/den;
y1(idx01) = 0;
y2(idx02) = 0;

y = (y1 + y2);