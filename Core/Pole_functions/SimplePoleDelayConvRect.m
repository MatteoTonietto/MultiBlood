% Analytical convolution between a delayed exponential and a translated 
% rectangular function
% h = exp[-a(t-t0)]    delayed exponential 
% u = [1(t)-1(t-T)]    translated rectangular function
% y = h * u

function [y,J] = SimplePoleDelayConvRect(par,t)

a  = par(1);   % exponent
t0 = par(2);   % delay
T  = par(3);   % length of rect

tp = t0 + T;

tt0 = t - t0;
ttp = t - tp;
exp_at0 = exp(-a*tt0);
exp_atp = exp(-a*ttp);

idx01 = t < t0 | t > tp;
idx02 = t <= tp;

if a == 0
    % t > t0 && t <= T + t0
    y1 = tt0;
    
    % t > T + t0
    y2 = T*ones(size(tt0));
    
    den = 1;   
else   
    % t > t0 && t <= T + t0
    y1 = 1 - exp_at0;
    
    % t > T + t0
    y2 = exp_atp - exp_at0;
    
    den = a;
    
end

y1(idx01) = 0;
y2(idx02) = 0;

y = (y1 + y2)/den;

if nargout > 1
  
    % Der a 
    J1(:,1) = ((a*tt0 + 1).*exp_at0 - 1)/a^2;    
    J2(:,1) = ((a*tt0 + 1).*exp_at0 - (a*ttp + 1).*exp_atp)/a^2;
    
    % Der t0
    J1(:,2) = -exp_at0;
    J2(:,2) = -exp_at0 + exp_atp;
    
    % Der T
    J1(:,3) = zeros(size(t));
    J2(:,3) = exp_atp;
    
    J1(idx01,:) = 0;
    J2(idx02,:) = 0;
    
    J = J1 + J2;  
end
    