function info = approxCmet(par,info)

tCtot = info.tCtot;
Ctot  = info.Ctot;
wCtot = info.wCtot;

tPPf  = info.tPPf;
PPf   = info.PPf;
wPPf  = info.wPPf;

%% Cmet = Ctot (1-PPf)
% -------------------------------------------------------------------------
if any(info.appCmet==1)
    
    doub_t = find(diff(tCtot)==0);
    tCtot(doub_t) = tCtot(doub_t) + 1e-6; 
    
    Ctot1  = interp1(tCtot,Ctot,tPPf,'nearest','extrap');
    wCtot1 = interp1(tCtot,wCtot,tPPf,'nearest','extrap');
    
    tCmet1 = tPPf;
    Cmet1  = (1 - PPf).*Ctot1;
    wCmet1 = wCtot1.*wPPf./sqrt((1-PPf).^2.*wPPf.^2 + Ctot1.^2.*wCtot1.^2);
    
else
    Cmet1  = [];
    tCmet1 = [];
    wCmet1 = [];    
end

%% Cmet = Ctot - yCp
% -------------------------------------------------------------------------
if any(info.appCmet==2)
    yCp2 = modelCp(par,info,tCtot);
    
    tCmet2 = tCtot;
    Cmet2  = Ctot - yCp2;
    wCmet2 = wCtot;
    
    if info.vincYp
        [~, indp]    = max(Ctot);
        wCmet2(indp) = wCmet2(indp)/20;
    end
else
    Cmet2  = [];
    tCmet2 = [];
    wCmet2 = [];
end

%% Cmet = (1/PPf - 1)*yCp
% -------------------------------------------------------------------------
if any(info.appCmet==3)
    yCp3 = modelCp(par,info,tPPf);
    
    tCmet3 = tPPf;
    Cmet3  = (1./PPf - 1).*yCp3;
    wCmet3 = (PPf.^2.*wPPf)./yCp3;
else
    Cmet3  = [];
    tCmet3 = [];
    wCmet3 = [];
end

%% Union
% -------------------------------------------------------------------------
tCmet_unsrt         = [tCmet1; tCmet2; tCmet3];
Cmet_unsrt          = [Cmet1;  Cmet2;  Cmet3 ];
wCmet_unsrt         = [wCmet1; wCmet2; wCmet3];

[info.tCmet,indsrt] = sort(tCmet_unsrt);
info.Cmet           = Cmet_unsrt(indsrt);
info.wCmet          = wCmet_unsrt(indsrt);

%% Weight correction
% -------------------------------------------------------------------------
info.wCmet(info.Cmet<0) = 0; 
info.wCmet(isinf(info.wCmet)) = 0;
info.wCmet(isnan(info.wCmet)) = 0;

