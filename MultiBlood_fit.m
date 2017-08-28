function [par,info,info_Cp] = MultiBlood_fit(Blood)

%% Approximation used for Cmet
%--------------------------------------------------------------------------
% They can be used in conjunction:
%
% Cmet = Ctot*(1-PPf)           % 1
% Cmet = Ctot - yCp             % 2
% Cmet = (1/PPf - 1)*yCp        % 3

appCmet = [0;0;3];

%% Other options
%--------------------------------------------------------------------------
vicTp      = 0;         % Tp is fixed
vincYp     = 1;         % higher weight on Yp (weight * 20)
PPf0       = 0;         % PPf can start from a value different than 1
extraMet   = 0;         % extra regressors for Cmet
vinct1     = 0;         % t1 is fixed to 0
plotpause  = 0;         % no pause if 0

CmetEst   = 'SBL';        % 'NNLS'   or 'SBL'
CmetModel = 'Simple';     % 'Simple' or 'SimpleFeng'

%%
% data
if length(Blood.TotalPlasma.data) == 2
    tCtot1 = Blood.TotalPlasma.data(1).tCtot;
    Ctot1  = Blood.TotalPlasma.data(1).Ctot;
    wCtot1 = Blood.TotalPlasma.data(1).wCtot;
    wCtot1 = wCtot1./sum(wCtot1);
    
    tCtot2 = Blood.TotalPlasma.data(2).tCtot;
    Ctot2  = Blood.TotalPlasma.data(2).Ctot;
    wCtot2 = Blood.TotalPlasma.data(2).wCtot;
    wCtot2 = wCtot2./sum(wCtot2);
    
    tCtot = [tCtot1(:);tCtot2(:)];
    Ctot  = [Ctot1(:);Ctot2(:)];
    wCtot = [wCtot1(:);wCtot2(:)];
    
    [info.tCtot,idxsort] = sort(tCtot);
    info.Ctot  = Ctot(idxsort);
    info.wCtot = wCtot(idxsort);
    
else
    info.tCtot = Blood.TotalPlasma.data(1).tCtot;
    info.Ctot  = Blood.TotalPlasma.data(1).Ctot;
    info.wCtot = Blood.TotalPlasma.data(1).wCtot;
end

info.tPPf  = Blood.ParentFraction.data.tPPf;
info.PPf   = Blood.ParentFraction.data.PPf;
info.wPPf  = Blood.ParentFraction.data.wPPf;

% options
info.appCmet   = appCmet;
info.vicTp     = vicTp;
info.vincYp    = vincYp;
info.PPf0      = PPf0;
info.extraMet  = extraMet;
info.vinct1    = vinct1;

info.CmetEst   = CmetEst;
info.CmetModel = CmetModel;

%% 1 yCpi
disp('1 yCpi')

info = approxCp([],info);

% initial parameters t0, T
[~, indp] = max(info.Cp);
Tp        = info.tCp(indp);
t0        = t0Estimation(info.tCp,info.Cp);
T         = Tp - t0;

% grid search for initial value of l0
l0grid  = fliplr(logspace(log10(50),log10(1),20));

par0_Cp = [l0grid;repmat(t0,1,length(l0grid));repmat(T,1,length(l0grid))];

if info.vincYp
    info.wCp(indp) = 20.*info.wCp(indp);
end

est.FUN       = 'estCp';
est.fixed_par = info;
est.data      = info.Cp;
est.time      = info.tCp;
est.weights   = info.wCp;
est.p0        = par0_Cp;
est.pup       = inf(size(est.p0));
est.pdown     = zeros(size(est.p0));

est.options.plot        = 0;
est.options.Jac         = 'off';
est.options.Display     = 'off';
est.options.MaxFunEvals = 1;

est_Cp = SingleSubjectModelFit(est);

% gradient search for l0,t0,T
if info.vicTp
    est.options.adj_par = logical([1;1;0]);
end

est.p0                  = est_Cp.par;
est.pup                 = inf(size(est.p0));
est.pup(1)              = est.p0(1)*1.2;
est.pdown               = zeros(size(est.p0));
est.options.MaxFunEvals = 10000;
est.options.Display     = 'iter';

est_Cp = SingleSubjectModelFit(est);

par_Cp = est_Cp.par;
info   = basesCp(par_Cp,info);

if plotpause
    figure(1)
    tv = [0 : 0.01 : est.time(end)]';
    plotEst(est_Cp,tv);
    pause
end

%% 2 yCmet
disp('2 yCmet')
% info.beta2 = 5;
t1 = 0;

info = approxCmet(par_Cp,info);

% gradient search for initial value of t1, (b0)
if info.vinct1
    par_Ctot  = [par_Cp;t1];
else
    clear est
    est.p0        = [par_Cp;t1];
    est.options.adj_par = logical([0;0;0;1]);
     
    est.FUN       = 'estCmet';
    est.fixed_par = info;
    est.data      = info.Cmet;
    est.time      = info.tCmet;
    est.weights   = info.wCmet;
    est.pup       = inf(size(est.p0));
    est.pdown     = zeros(size(est.p0));
    
    est.options.plot    = 0;
    est.options.Jac     = 'off';
    est.options.Display = 'iter';
    
    est_Cmet = SingleSubjectModelFit(est);
    par_Ctot = est_Cmet.par;
end

[~,info] = estCmet(par_Ctot,info,info.tPPf);

% disp(info.b_good')
% disp(info.B_good')

if plotpause
    figure(2)
    tv = [0:0.01:est_Cp.time(end)]';
    if info.vinct1
        %             plot(info.tCmet,info.Cmet,'o')
        hold on
        plot(tv, modelCmet(par_Ctot,info,tv), 'm')
        title(num2str(par_Ctot'))
        hold off
    else
        plotEst(est_Cmet,tv);
    end
    pause
    
    %         figure(1)
    %         subplot(211)
    %             plot(info.tCtot,info.Ctot,'o')
    %             hold on
    %             plot(tv, modelCtot(par_Ctot,info,tv), 'r')
    %             plot(tv, modelCp(par_Ctot,info,tv),   'g')
    %             plot(tv, modelCmet(par_Ctot,info,tv), 'm')
    %             title(num2str(par_Ctot'))
    %             hold off
    %
    %         subplot(212)
    %             plot(info.tPPf, info.PPf,'o')
    %             hold on
    %             plot(tv, modelPPf(par_Ctot,info,tv),'r')
    %             yPPf = interp1([0;info.tPPf],[1;info.PPf],info.tCtot,'linear','extrap');
    %             plot(info.tCtot,yPPf,'g')
    %             hold off
    %         pause
end


%% 3 yCp
disp('3 yCp')

par  = par_Ctot;

info_Cp = approxCp(par,info);
if info_Cp.vincYp
    info_Cp.wCp(indp) = 20.*info_Cp.wCp(indp);
end

info_Cp = basesCp(par,info_Cp);

if plotpause
    tv = [0:0.01:est_Cp.time(end)]';
    
    figure(1)
    subplot(211)
    plot(info.tCtot,info.Ctot,'o')
    hold on
    %             plot(tv, modelCtot(par_Ctot,info,tv), 'r')
    plot(tv, modelCp(par_Ctot,info,tv)./modelPPf(par_Ctot,info,tv), 'r')
    plot(tv, modelCp(par_Ctot,info,tv),   'g')
    plot(tv, modelCmet(par_Ctot,info,tv), 'm')
    title(num2str(par_Ctot'))
    hold off
    
    subplot(212)
    plot(info.tPPf, info.PPf,'o')
    hold on
    plot(tv, modelPPf(par_Ctot,info,tv),'r')
    yPPf = interp1([0;info.tPPf],[1;info.PPf],info.tCtot,'linear','extrap');
    plot(info.tCtot,yPPf,'g')
    hold off
    pause
end
