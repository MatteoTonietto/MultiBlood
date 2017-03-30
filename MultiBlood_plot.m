function MultiBlood_plot(handles,Blood)

cla(handles.axes_Ctot,'reset')
cla(handles.axes_PPf,'reset')

legend_Ctot = {};
legend_PPf  = {};

if isfield(Blood,'TotalPlasma')
    axes(handles.axes_Ctot)    
    hold('on')
    plot(Blood.TotalPlasma.data(1).tCtot,Blood.TotalPlasma.data(1).Ctot,'ob')
    legend_Ctot{length(legend_Ctot)+1} = 'Ctot';
    xlabel('Time')
    ylabel('Activity')
    
    if length(Blood.TotalPlasma.data) == 2
        plot(Blood.TotalPlasma.data(2).tCtot,Blood.TotalPlasma.data(2).Ctot,'*b')
        legend_Ctot{length(legend_Ctot)+1} = 'Ctot from POB';
        xlabel('Time')
        ylabel('Activity')
    end
    hold('off')
end

if isfield(Blood,'ParentFraction')
    axes(handles.axes_PPf)  
    hold('on')
    plot(Blood.ParentFraction.data.tPPf,Blood.ParentFraction.data.PPf,'ob')
    ylim([0 1])
    legend_PPf{length(legend_PPf)+1} = 'PPf';
    xlabel('Time')
    ylabel('Fraction')
    hold('off')
end

if isfield(Blood,'WholeBlood')
    axes(handles.axes_Ctot)  
    hold('on')    
    if ~isempty(Blood.WholeBlood.data(1).tCb)
        plot(Blood.WholeBlood.data(1).tCb,Blood.WholeBlood.data(1).Cb,'ok')
        legend_Ctot{length(legend_Ctot)+1} = 'Cb manu';
        xlabel('Time')
        ylabel('Activity')
    end
    
    if length(Blood.WholeBlood.data) == 2
        plot(Blood.WholeBlood.data(2).tCb,Blood.WholeBlood.data(2).Cb,'*k')
        legend_Ctot{length(legend_Ctot)+1} = 'Cb auto';
        xlabel('Time')
        ylabel('Activity')
    end
    hold('off')
end 

if isfield(Blood,'UnifiedFit')
    axes(handles.axes_Ctot)  
    hold('on')
    tv = [0:0.01:Blood.TotalPlasma.data(1).tCtot(end)]';
    plot(tv, modelCtot(Blood.UnifiedFit.par,Blood.UnifiedFit.info,tv), 'r')
    plot(tv, modelCp(Blood.UnifiedFit.par,Blood.UnifiedFit.info_Cp,tv),   'g')
    plot(tv, modelCmet(Blood.UnifiedFit.par,Blood.UnifiedFit.info,tv), 'm')
    legend_Ctot{length(legend_Ctot)+1} = 'yCtot';
    legend_Ctot{length(legend_Ctot)+1} = 'yCp';
    legend_Ctot{length(legend_Ctot)+1} = 'yCmet';
    xlabel('Time')
    ylabel('Activity')
    hold('off')
    
    axes(handles.axes_PPf)  
    hold('on')
    plot(tv, modelPPf(Blood.UnifiedFit.par,Blood.UnifiedFit.info,tv),'r')
    ylim([0 1])
    legend_PPf{length(legend_PPf)+1} = 'yPPf';
    xlabel('Time')
    ylabel('Fraction')
    hold('off')  
            
    handles.uipanel7.Visible = 'on';
else
    handles.uipanel7.Visible = 'off';
end

 
if ~isempty(legend_Ctot)
    legend(handles.axes_Ctot,legend_Ctot)
end

if ~isempty(legend_PPf)
    legend(handles.axes_PPf,legend_PPf)
end

    
    