function t0 = t0Estimation(t,z)
% Estimates t0 assuming it exists between 0 and t_peak. The method fits a
% piecewise linear model (a zero line from 0 to t0, and a straight line
% from t0 to the peak). 
%
% Based on Muggeo V, Statist. Med. 2003; 22:3055–3071

[~, indp] = max(z);

t_2p = t(1 : indp);
z_2p = z(1 : indp); 

% initial value
t0 = t_2p(1);

Nmax = 20;
Tol  = 1e-6;

iter   = true;
change = true;
i      = 1;

while iter && change
    
    % 1 Calculation of ausiliary variates
    U = (t_2p - t0).*(t_2p > t0);
    V = - double(t_2p > t0);

    % 2 Linear fit
    % par = [t_2p,U,V]\z_2p; for nonzero first line
    par = [U,V]\z_2p;
    
    if par(1)~=0
        % 3 Update t0 estimate
        t0 = par(2)/par(1) + t0;
        
        % 4 Convergence
        iter   = i < Nmax;
        change = abs(par(2)) > Tol;
        
        i = i + 1;
        
    else
        change = false;
    end


    
%     h = figure(1);
%     plot(t,z,'o')
%     hold on
%     plot(t_2p,[U,V]*par,'r','LineWidth',2)
%     plot([t0 t0],[0 max(z)],'--k','LineWidth',2)
%     axis([0 t_2p(end) + 1 0 max(z)])
%     hold off
%     title(['Iteration ',num2str(i-1)])
% %     savefig(h,['fig',num2str(i-1),'.fig'])
%     pause
     
end

