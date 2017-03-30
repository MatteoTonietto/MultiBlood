function plotEst(est,t)

if nargin<2
    t = est.time;
end

try
    funname = func2str(est.FUN);
catch
    funname = est.FUN;
end


subplot(211)
    plot(est.time,est.data,'o')
    hold on
    plot(t,feval(est.FUN,est.par,est.fixed_par,t),'r')
    legend('data','fit')
    title(funname)
    hold off

subplot(212)
    plot(est.time,est.wres,'-o')
    hold on
    plot([0 t(end)],[1 1],'--m')
    plot([0 t(end)],[0 0],'--m')
    plot([0 t(end)],-[1 1],'--m')
    hold off