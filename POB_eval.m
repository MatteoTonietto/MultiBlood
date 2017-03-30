function yPOB = POB_eval(Blood,t)

POB_model = Blood.PlasmaOverBlood.fitted.FUN;

switch POB_model
    case 'Linear interpolation'
        yPOB = interp1(Blood.PlasmaOverBlood.data.tPOB,Blood.PlasmaOverBlood.data.POB,t,'linear','extrap');
        
    case 'Polynomial'
        yPOB = polyval(Blood.PlasmaOverBlood.fitted.par,t);
        
    otherwise
        est  = Blood.PlasmaOverBlood.fitted;
        yPOB = feval(est.FUN,est.par,est.fixed_par,t);

end