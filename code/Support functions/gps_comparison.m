function gps_comparison(fld,group,gps,ch,type,alpha,thresh,tail,mode,bonf)
        
        disp (' ')
        disp([gps{1} ' difference between CP and NORM :'])
        disp (' ')
        r = extractgpsdata(fld,group,ch,gps);
        omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);
end


