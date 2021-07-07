function gps_comparison_gmfcs(fld,group,gps,ch,type,alpha,thresh,tail,mode,bonf)
        
        disp (' ')
        disp([gps{1} ' difference between GMFCS level ' group{1} ' and ' group{2} ':'])
        disp (' ')
        r = extractgpsdata_CP(fld,group,ch,gps);
        omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);
        
        
        disp (' ')
        disp([gps{1} ' difference between GMFCS level ' group{2} ' and ' group{3} ':'])
        disp (' ')
        r = extractgpsdata_CP(fld,group,ch,gps);
        omni_ttest(r.(group{2}),r.(group{3}),type,alpha,thresh,tail,mode,bonf);
        
        
        disp (' ')
        disp([gps{1} ' difference between GMFCS level ' group{1} ' and ' group{3} ':'])
        disp (' ')
        r = extractgpsdata_CP(fld,group,ch,gps);
        omni_ttest(r.(group{1}),r.(group{3}),type,alpha,thresh,tail,mode,bonf);
end
