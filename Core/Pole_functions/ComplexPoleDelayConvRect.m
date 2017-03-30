% h = exp[-a*(t-t0)]*sin[omega*(t-t0)+phi]
% u = [1(t)-1(t-T)]
% y = h * u

function y = ComplexPoleDelayConvRect(par,t)

a  = par(1);
om = par(2);
ph = par(3);
t0 = par(4);
T  = par(5);

tp = t0 + T;

tt0     = t - t0;
ttp     = t - tp;
exp_at0 = exp(-a*tt0);
exp_atp = exp(-a*ttp);
sin_t0  = sin(ph + om*tt0);
cos_t0  = cos(ph + om*tt0);
sin_tp  = sin(ph + om*ttp);
cos_tp  = cos(ph + om*ttp);

idx01 = t < t0 | t > tp;
idx02 = t <= tp;


% t < t0 | t > tp
y1 = om*cos(ph) - om*exp_at0.*cos_t0 + a*sin(ph) - a*exp_at0.*sin_t0;

% t <= tp
y2 = om*exp_atp.*cos_tp - om*exp_at0.*cos_t0 + a*exp_atp.*sin_tp - a*exp_at0.*sin_t0;

den = a^2 + om^2;

y1(idx01) = 0;
y2(idx02) = 0;

y = (y1 + y2)/den;