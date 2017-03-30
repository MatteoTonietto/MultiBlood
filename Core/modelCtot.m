function yCtot = modelCtot(par,info,t)

yCp   = modelCp(par,info,t);
% yCmet = modelCmet(par,info,t);

% yCtot = yCp + yCmet;

yPPf  = modelPPf(par,info,t);
yCtot = yCp./yPPf;