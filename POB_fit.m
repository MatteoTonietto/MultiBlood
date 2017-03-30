function Blood = POB_fit(Blood)

POB_model = Blood.PlasmaOverBlood.fitted.FUN;
POB       = Blood.PlasmaOverBlood.data.POB;
tPOB      = Blood.PlasmaOverBlood.data.tPOB;
wPOB      = Blood.PlasmaOverBlood.data.wPOB;

switch POB_model
    case 'Linear interpolation'
        
        
    case 'Polynomial'
        [P,S] = polyfit(tPOB.*wPOB,POB.*wPOB,Blood.PlasmaOverBlood.fitted.fixed_par);
        
        Blood.PlasmaOverBlood.fitted.par    = P;
        Blood.PlasmaOverBlood.fitted.WRSS   = S.normr^2;
        Blood.PlasmaOverBlood.fitted.sigmaq = S.normr^2/S.df;
        Blood.PlasmaOverBlood.fitted.Cov    = (inv(S.R)*inv(S.R)')*S.normr^2/S.df;
        Blood.PlasmaOverBlood.fitted.cvpar  = sqrt(abs(diag(Blood.PlasmaOverBlood.fitted.Cov)))./abs(P')*100; 
        Blood.PlasmaOverBlood.fitted.AIC    = length(find(wPOB))*log(Blood.PlasmaOverBlood.fitted.WRSS)+2*length(P);
        Blood.PlasmaOverBlood.fitted.wres   = wPOB.*(POB - polyval(P,tPOB))./sqrt(Blood.PlasmaOverBlood.fitted.sigmaq);
        Blood.PlasmaOverBlood.fitted.fit    = polyval(P,tPOB);

    otherwise
        est           = Blood.PlasmaOverBlood.fitted;
        est.fixed_par = [];
        est.data      = POB;
        est.time      = tPOB;
        est.weights   = wPOB;
        
        est.options.plot        = 0;
        est.options.Display     = 'off';
        
        Blood.PlasmaOverBlood.fitted = SingleSubjectModelFit(est);

end