function MARP_DP_stats(fld,group,evt,type,alpha,thresh,tail,mode,bonf)

cd(fld)

for v = 1:length(evt)

% a) MARP stats
ch = 'L_KH_MARP';
disp (' ')
disp([ch ' difference between ',group{1}, ' and ', group{2}, ' at ' evt{v}, ' :'])
disp (' ')
r = extracteventsdata(fld,group,ch,evt{v});
omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);                                  

ch = 'L_AK_MARP';
disp (' ')
disp([ch ' difference between ',group{1}, ' and ', group{2}, ' at ' evt{v}, ' :'])
disp (' ')
r = extracteventsdata(fld,group,ch,evt{v});
omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);

% b) DP stats
ch = 'L_KH_DP';
disp (' ')
disp([ch ' difference between ',group{1}, ' and ', group{2}, ' at ' evt{v}, ' :'])
disp (' ')
r = extracteventsdata(fld,group,ch,evt{v});
omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);

ch = 'L_AK_DP';
disp (' ')
disp([ch ' difference between ',group{1}, ' and ', group{2}, ' at ' evt{v}, ' :'])
disp (' ')
r = extracteventsdata(fld,group,ch,evt{v});
omni_ttest(r.(group{1}),r.(group{2}),type,alpha,thresh,tail,mode,bonf);

end 

end

