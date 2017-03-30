% h = (t-t0) exp[-a(t-t0)]
% u = [1(t)-1(t-T)]    
% y = h * u

function [y,J] = DoublePoleDelayConvRect(par,t)

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

% t > t0 && t <= T + t0
y1    = 1 - exp_at0 - exp_at0*a.*tt0;

% t > T + t0 && t0 > 0 && t0 < T
y2    = - exp_at0 - exp_at0*a.*tt0 + exp_atp + exp_atp*a.*ttp;

den = a^2;

y1(idx01) = 0;
y2(idx02) = 0;

y = (y1 + y2)/den;

if nargout > 1
  
    J1(:,1) = (-2 + (2 + a*(2+a*tt0).*tt0).*exp_at0)/a^3;    
    J2(:,1) = ((2 + a*(2 + a*tt0).*tt0).*exp_at0 - (2 + 2*a*ttp + a^2*ttp.^2).*exp_atp)/a^3;
    
    J1(:,2) = -tt0.*exp_at0;
    J2(:,2) = -tt0.*exp_at0 + ttp.*exp_atp;
    
    J1(:,3) = zeros(size(t));
    J2(:,3) = ttp.*exp_atp;
    
    J1(idx01,:) = 0;
    J2(idx02,:) = 0;
    
    J = J1 + J2;  
end