function [yCmet,info] = estCmet(par,info,t)

info = basesCmet(par,info);
 
yCmet = modelCmet(par,info,t);
