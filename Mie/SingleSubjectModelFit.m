function [est] = SingleSubjectModelFit(est)
% Estimates parameters of a model for a single subject
% FORMAT [est] = SingleSubjectModelFit(est)
%
% Expects
%--------------------------------------------------------------------------
% est.FUN                       % model to invert FUN(par,fixed_par,time)
% est.fixed_par                 % fixed parameters
% est.data                      % data to fit
% est.time                      % time of data
% est.weights                   % weight defined as 1./SD
% est.p0                        % initial values, if a matrix it tests all
%                               % the columns as initial values and return
%                               % the one with the lower WRSS
% est.pup                       % upper bound
% est.pdown                     % lower bound
%
% Options
%--------------------------------------------------------------------------
% est.options.plot              % plot the fit for each iteration
% est.options.global            % use global optimization 
%                               % gs - global search
%                               % sa - simulated annealing
%                               % ps - pattern search
% est.option.Jac                % 'on' or 'off', if 'on' FUN must return 
%                               % the analytical Jacobian 
% est.options.TolFun            % Default 1e-6;
% est.options.TolX              % Default 1e-6;
% est.options.MaxFunEva ls      % Default 10000;
% est.options.Display           % Default 'off'
% est.options.adj_par           % Binary vector. 1 means that the parameter
%                               % in the corresponding position in p0
%                               % varies during fitting; 0 it remains fixed
%
% Evaluates:
%--------------------------------------------------------------------------
% est.par                       % parameter estimates
% est.WRSS                      % Weighted Residuals Sum of Squares
% est.sigmaq                    % variance scale estimated a posteriori
% est.J                         % Jacobian
% est.Cov                       % Covariance matrix
% est.cvpar                     % parameter CVs
% est.AIC                       % Akaike Information criterion
% est.wres                      % weighted residuals
% est.fit                       % fit of the data
% est.attraversamenti           % sign changes in residual (0 crossing) 
% est.Warning                   % true for Cov badly estimated
%
%__________________________________________________________________________
% Copyright (C) 2014-2017 Departement of Information Engineering
% v1.3 - 2017-03-20 Matteo Tonietto

% Unpack
%--------------------------------------------------------------------------
FUN         = est.FUN;
fixed_par   = est.fixed_par;
data        = est.data;
time        = est.time;
weights     = est.weights;
p0          = est.p0;
pup         = est.pup;
pdown       = est.pdown;

% Check options
%--------------------------------------------------------------------------
try options = est.options; catch, options             = struct(); end
try options.Jac;           catch, options.Jac         = 'off';    end
try options.TolFun;        catch, options.TolFun      = 1e-9;     end
try options.TolX;          catch, options.TolX        = 1e-6;     end
try options.MaxFunEvals;   catch, options.MaxFunEvals = 10000;    end
try options.Display;       catch, options.Display     = 'off';    end

try adj_par = options.adj_par; catch, adj_par = true(size(p0,1),1); end 

% Objective function and minimization options
%--------------------------------------------------------------------------

% Construct vector of parameter adjusted vs fixed
k     = 1;
str   = '[';
for i = 1 : length(adj_par)
    if adj_par(i)
        str = strcat(str,'p(',num2str(k),');');
        k   = k + 1;
    else
        str = strcat(str,num2str(p0(i,1)),';');
    end
end
str = strcat(str,']');  

% Objective function
f = @(p)ObjFun(FUN,eval(str),fixed_par,data,time,weights,options);

% lsqnonlin options
opt = optimset('TolFun',options.TolFun,'TolX',options.TolX, ...
        'MaxFunEvals', options.MaxFunEvals,'Display',options.Display, ...
        'Jacobian',options.Jac);

% Global objective function and options    
if isfield(options,'global')
    disp(['Global optimizer: ' options.global])
    f_glo = @(p)sum(f(p).^2);
    
    opt_ps = psoptimset('MaxIter',100000,'MaxFunEvals', 100000, ...
        'CompletePoll','on','Display','off');
    opt_sa = saoptimset('MaxFunEvals',20,'InitialTemperature',1000, ...
            'Display','off');
end
    
% Variable initialization, initial values and boundaries formatting
%--------------------------------------------------------------------------
p0_adj = p0(adj_par,:);
pup    = pup(adj_par,:);
pdown  = pdown(adj_par,:);

n_adj  = size(p0_adj,1);
n_stp  = size(p0_adj,2);
n_dat  = length(find(weights));

pari = zeros(n_adj,n_stp); WRSSi = zeros(n_stp,1); exitflagi = WRSSi; 
Ji   = zeros(length(time),n_adj,n_stp);

if size(pup,2) == 1
    pup     = repmat(pup,1,n_stp);
    pdown   = repmat(pdown,1,n_stp);
end

if size(pup,2) ~= n_stp
    error('Inconsistent initial values and boundaries');
end

% Estimation
%--------------------------------------------------------------------------
for i = 1 : n_stp
    
    disp(['Estimating model ',num2str(i),' of ',num2str(n_stp)])

    if isfield(options,'global')
        switch options.global
            case 'gs'
                % Global search
                % ---------------------------------------------------------
                probl = createOptimProblem('fmincon','x0',p0_adj(:,i), ...
                    'objective',f_glo,'lb',pdown(:,i),'ub',pup(:,i));
                gs = GlobalSearch('NumTrialPoints',2000,'Display','off');
                [p0_adj(:,i),~,~,~] = run(gs,probl);
            case 'ps'
                % Pattern search
                % ---------------------------------------------------------
                [p0_adj(:,i), ~] = patternsearch(f_glo,p0_adj(:,i),[], ...
                    [],[],[],pdown(:,i),pup(:,i),[],opt_ps);
            case 'sa'
                % Simulated annealing
                % ---------------------------------------------------------
                [p0_adj(:,i), ~] = simulannealbnd(f_glo,p0_adj(:,i), ... 
                    pdown(:,i), pup(:,i),opt_sa);
        end
    end  
    
    [pari(:,i),WRSSi(i),~,exitflagi(i),~,~,Ji(:,:,i)] = ...
        lsqnonlin(f,p0_adj(:,i),pdown(:,i),pup(:,i),opt);
end

[WRSS,ind_best] = min(WRSSi);
par             = pari(:,ind_best);
exitflag        = exitflagi(ind_best);
J               = Ji(:,:,ind_best);

par_all               = zeros(size(p0,1),1);
par_all(adj_par)      = par;
par_all(not(adj_par)) = p0(not(adj_par),:);

% Output
%--------------------------------------------------------------------------
est.par             = par_all;
est.WRSS            = WRSS;
est.sigmaq          = WRSS/(n_dat - n_adj);
est.J               = J;  
est.Cov             = full(est.sigmaq*inv(J'*J));
est.cvpar           = full(sqrt(abs(diag(est.Cov)))./abs(par)*100);
est.AIC             = n_dat*log(WRSS)+2*n_adj;
est.wres            = ObjFun(FUN,par_all,fixed_par,data,time,weights, ...
                        options)/sqrt(est.sigmaq);
est.fit             = feval(FUN,par_all,fixed_par,time);
est.attraversamenti = sum(floor(abs(diff(sign(est.wres)./2))));
est.exitflag        = exitflag;
est.Warning         = false;

% Check if the covariance matrix was estimated correctly
%--------------------------------------------------------------------------
s1 = warning('error','MATLAB:nearlySingularMatrix');
s2 = warning('error','MATLAB:singularMatrix');
try
    inv(J'*J);
catch 
    est.Warning = true;
end
warning(s1);
warning(s2);


% Objective function
%--------------------------------------------------------------------------
function [r,J] = ObjFun(FUN,par,fixed_par,data,time,weights,options)

if nargout > 1
    [y,J]         = feval(FUN,par,fixed_par,time);
    J             = -J.*repmat(weights,1,size(J,2));
    r             = weights.*(data-y);   
    J(isnan(r),:) = 0;
    r(isnan(r))   = 0;
else
    y           = feval(FUN,par,fixed_par,time);
    r           = weights.*(data-y);
    r(isnan(r)) = 0;
end

if isfield(options,'plot') && options.plot
    plot(time,data,'o')
    hold on
    plot(time,feval(FUN,par,fixed_par,time));
    hold off
    pause(0.001)
end


