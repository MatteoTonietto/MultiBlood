% h = exp[-a*(t-t0)]*sin[omega*(t-t0)+phi]  
% u = [1(t)-1(t-T)]
% v = exp(-b t)
% y = h * u * v

function y = ComplexPoleDelayConvRectConvExp(par,t)

a  = par(1);
om = par(2);
ph = par(3);
t0 = par(4);
T  = par(5);
b  = par(6);

tp = t0 + T;

tt0     = t - t0;
ttp     = t - tp;
exp_at0 = exp(-a*tt0);
exp_bt0 = exp(-b*tt0);
exp_atp = exp(-a*ttp);
exp_btp = exp(-b*ttp);
sin_t0  = sin(ph + om*tt0);
cos_t0  = cos(ph + om*tt0);
sin_tp  = sin(ph + om*ttp);
cos_tp  = cos(ph + om*ttp);

idx01 = t < t0 | t > tp;
idx02 = t <= tp;


if b==0
    % t < t0 | t > tp
    y1 = om*cos(ph)*((a^2 + om^2)*tt0 - 2*a) + exp_at0.*(2*a*om*cos_t0 + (a^2 - om^2)*sin_t0) + (om^2 + a*(a^2 + om^2)*tt0 - a^2)*sin(ph);
        
    % t <= tp
    y2 = (a^2 + om^2)*T*(om*cos(ph) + a*sin(ph)) + 2*a*om*(cos_t0.*exp_at0 - cos_tp.*exp_atp) + (a^2 - om^2)*(exp_at0.*sin_t0 - exp_atp.*sin_tp);
    
    den = (a^2 + om^2)^2;
    
elseif b==a
    % t < t0 | t > tp
    y1 = om*(om*cos(ph) + a*sin(ph)) - exp_at0.*((a^2 + om^2)*cos(ph) - a^2*cos_t0 + a*om*sin_t0);
    
    % t <= tp   
    y2 = exp_atp.*((a^2 + om^2)*cos(ph) - a^2*cos_tp + a*om*sin_tp) - exp_at0.*((a^2 + om^2)*cos(ph) - a^2*cos_t0 + a*om*sin_t0) ;
    
    den = (a*om*(a^2 + om^2));
    
else
    % t < t0 | t > tp  
    y1 = ((a - b)^2 + om^2)*(om*cos(ph) + a*sin(ph)) + (2*a - b)*b*om*cos_t0.*exp_at0 + b*(a*(a - b) - om^2)*exp_at0.*sin_t0 - (a^2 + om^2)*exp_bt0*(om*cos(ph) + (a - b)*sin(ph));
    
    % t <= tp
    y2 = (2*a - b)*b*om*cos_t0.*exp_at0 - b*(2*a - b)*om*cos_tp.*exp_atp - om*(a^2 + om^2)*cos(ph)*(exp_bt0 - exp_btp) + b*(a*(a - b) - om^2)*(exp_at0.*sin_t0 - exp_atp.*sin_tp) - (a - b)*(a^2 + om^2)*(exp_bt0 - exp_btp)*sin(ph);
    
    den = (b*(a^2 + om^2)*((a - b)^2 + om^2));
    
end

y1(idx01) = 0;
y2(idx02) = 0;

y = (y1 + y2)/den;