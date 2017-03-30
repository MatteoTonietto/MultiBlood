function info = approxCp(par,info)

try    
    yPPf = modelPPf(par,info,info.tCtot);    
catch
    yPPf = interp1([0;info.tPPf],[1;info.PPf],info.tCtot,'linear','extrap');
    if any(yPPf<0)
        yPPf = interp1([0;info.tPPf],[1;info.PPf],info.tCtot,'linear',info.PPf(end));
    end
end

info.tCp = info.tCtot;
info.Cp  = info.Ctot.*yPPf;
info.wCp = info.wCtot./yPPf;

if isfield(info,'QCtot')
    for i = 1 : length(info.QCtot)
        info.QCp(i) = {sparse(diag(diag(info.QCtot{i})./(yPPf.^2)))};
    end
end