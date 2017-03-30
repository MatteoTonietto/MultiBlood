% Double Pole a with Delay t0 convoluted with a Rectangular function of 
% lenght T, convoluted with an Exponential b.
% It handles the special cases of b=0 and a=b
%
% h = (t-t0) exp[-a(t-t0)]  Double Pole with Delay
% u = [1(t)-1(t-T)]         Rectangular function
% v = exp(-b t)             Exponential
% y = h * u * v

function [y,J] = DoublePoleDelayConvRectConvExp(par,t)

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

if b==0
    % t > t0 && t <= T + t0
    y1 = a*tt0 + exp_at0.*(2 + a*tt0) - 2;
    
    % t > T + t0 && t0 > 0 && t0 < T    
    y2 = exp_at0.*(2 + a*tt0) - exp_atp.*(2 + a*ttp) + T*a;
    
    den = a^3;
    
    if nargout > 1
        J1(:,1) = (6 - 2*a*tt0 - (6+a*(4+a*tt0).*tt0).*exp_at0)/a^4;
        J1(:,2) = (-1 + (1 + a*tt0).*exp_at0)/a^2;
        J1(:,3) = zeros(size(t));
        J1(:,4) = -((6 + a*(-4 + a*tt0).*tt0 - 2*(3 + a*tt0).*exp_at0)/(2*a^4));
        
        J2(:,1) = (-2*a*T - (6 + a*(4 + a*tt0).*tt0).*exp_at0 + (6 + a*(4 + a*ttp).*ttp).*exp_atp)/a^4;
        J2(:,2) = ((1 + a*tt0).*exp_at0 - (1 + a*ttp).*exp_atp)/a^2;
        J2(:,3) = (1 - (1 + a*ttp).*exp_atp)/a^2;
        J2(:,4) = (a*T*(4 + a*(T - 2*tt0)) + 2*(3 + a*tt0).*exp_at0 - 2*(3 + a*ttp).*exp_atp)/(2*a^4);
        
        J1(idx01,:) = 0;
        J2(idx02,:) = 0;
        
        J = J1 + J2;
    end
    
elseif b==a
    % t > t0 && t <= T + t0
    y1 = 2  - (2 + 2*a*tt0 + a^2*tt0.^2).*exp_at0;
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = y1 - 2 + (2 + 2*a*ttp + a^2*ttp.^2).*exp_atp;
    
    den = 2*a^3;
    
    if nargout > 1
        J1(:,1) = (-6 + (6 + a*(6 + a*(3 + a*tt0).*tt0).*tt0).*exp_at0)/(3*a^4);
        J1(:,2) = -0.5*tt0.^2.*exp_at0;
        J1(:,3) = zeros(size(t));
        J1(:,4) = J1(:,1)/2;
        
        J2(:,1) = ((6 + a*(6 + a*(3 + a*tt0).*tt0).*tt0).*exp_at0 + (-6 -a*ttp.*(6 + 3*a*ttp + a^2*ttp.^2)).*exp_atp)/(3*a^4);
        J2(:,2) = 0.5*(ttp.^2.*exp_atp - tt0.^2.*exp_at0);
        J2(:,3) = 0.5*ttp.^2.*exp_atp;
        J2(:,4) = J2(:,1)/2;
        
        J1(idx01,:) = 0;
        J2(idx02,:) = 0;
        
        J = J1 + J2;
    end
else
    % t > t0 && t <= T + t0   
    y1 = (a-b)^2 - b*(b + a*(-2-(a-b)*tt0)).*exp_at0 - a^2*exp_bt0;
    
    % t > T + t0 && t0 > 0 && t0 < T
    y2 = y1 - (a-b)^2 + b*(b + a*(-2-(a-b)*ttp)).*exp_atp + a^2*exp_btp;
    
    den = a^2*(a-b)^2*b; 
    
    if nargout > 1
        J1(:,1) = (-2*(a-b)^3 - b*(2*b^2 + a^4*tt0.^2 + 2*a*b*(-3 + b*tt0) - 2*a^3*tt0.*(-2 + b*tt0) +a^2*(6 + b*tt0.*(-6 + b*tt0))).*exp_at0 + 2*a^3*exp_bt0)/(a^3*(a-b)^3*b);
        J1(:,2) = ((1 + (a-b)*tt0).*exp_at0 - exp_bt0)/(a-b)^2;
        J1(:,3) = zeros(size(t));
        J1(:,4) = -(((a-b)^3 + b^2*(b - a*(3 + (a-b)*tt0)).*exp_at0 - a^2*(a*(1 + b*tt0) - b*(3 + b*tt0)).*exp_bt0)/(a^2*(a-b)^3*b^2));
        
        J2(:,1) = (-b*(2*b^2 + a^4*tt0.^2 + 2*a*b*(-3 + b.*tt0) - 2*a^3*tt0.*(b*tt0 - 2) + a^2*(6 + b*tt0.*(b*tt0 - 6))).*exp_at0 + b*(2*b^2 + 2*a*b*(b*ttp - 3) - 2*a^3*(b*ttp - 2).*ttp + a^4*ttp.^2 + a^2*(6 - 6*b*ttp + b^2*ttp.^2)).*exp_atp + 2*a^3*(exp_bt0 - exp_btp))/(a^3*(a-b)^3*b);
        J2(:,2) = ((1 + (a-b)*tt0).*exp_at0 - (1  + (a-b)*ttp).*exp_atp - exp_bt0 + exp_btp)/(a-b)^2;
        J2(:,3) = (( - 1 - (a-b)*ttp).*exp_atp + exp_btp)/(a-b)^2;
        J2(:,4) = (-b^2*(b + a*(-3 - (a-b)*tt0)).*exp_at0 + b^2*(b + a*(-3-(a-b)*ttp)).*exp_atp + a^2*((a*(1 + b*tt0) - b*(3 + b*tt0)).*exp_bt0 - (a*(1 + b*ttp) - b*(3 + b*ttp)).*exp_btp))/(a^2*(a-b)^3*b^2);
        
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