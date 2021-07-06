function group_comparison(fld,group,anthro,ch,type,alpha,thresh,tail,mode,bonf)

cd(fld)

for a = 1:length(anthro)

        disp (' ')
        disp([anthro{a} ' difference between CP and NORM :'])
        disp (' ')
        r = extractanthrodata(fld,group,ch,anthro{a});
        omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);
end
end
