function metrics_comparison_gmfcs(fld,group,metrics,evt,type,alpha,thresh,tail,mode,bonf)

cd(fld)

for m = 1:length(metrics)
    for v = 1:length(evt)
        disp (' ')
        disp([metrics{m} ' at ' evt{v} ' difference between GMFCS ' group{1} ' and ' group{2} ':'])
        disp (' ')
        r = extractmetricsdata_CP(fld,group,metrics{m},evt{v});
        omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);
        
        disp (' ')
        disp([metrics{m} ' at ' evt{v} ' difference between GMFCS ' group{2} ' and ' group{3} ':'])
        disp (' ')
        r = extractmetricsdata_CP(fld,group,metrics{m},evt{v});
        omni_ttest(r.(group{2}),r.(group{3}),type,alpha,thresh,tail,mode,bonf);
        
        
        disp (' ')
        disp([metrics{m} ' at ' evt{v} ' difference between GMFCS ' group{1} ' and ' group{3} ':'])
        disp (' ')
        r = extractmetricsdata_CP(fld,group,metrics{m},evt{v});
        omni_ttest(r.(group{1}),r.(group{3}),type,alpha,thresh,tail,mode,bonf);
    end 
end
end

