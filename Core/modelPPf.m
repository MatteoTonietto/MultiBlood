function yPPf = modelPPf(par,info,t)

yCp   = modelCp(par,info,t);
yCmet = modelCmet(par,info,t);

yPPf  = yCp./(yCp + yCmet);

t0 = par(2);

if info.PPf0
    yPPf(t <= t0) = 1./(1 + info.B_good(end));
else
    yPPf(t <= t0) = 1;    
end
