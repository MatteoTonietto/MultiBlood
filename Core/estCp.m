function [yCp,info] = estCp(par,info,t)

info = basesCp(par,info);

yCp = modelCp(par,info,t);
