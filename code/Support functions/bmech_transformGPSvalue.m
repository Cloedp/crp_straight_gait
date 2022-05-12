function bmech_transformGPSvalue(fld,gpsval)
% gpsval = gps value that you want to transform in double

cd(fld)

groups = GetSubDirsFirstLevelOnly(fld);

for g = 1:length(groups)
   sub = GetSubDirsFirstLevelOnly([fld, filesep, groups{g}]);
    
    for s = 1:length(sub)
        fl = engine('fld',fld,'folder', sub{s},'extension','zoo');
        
        for f = 1:length(fl)
            data = zload(fl{f});
            
            if isfield(data.SACR_x.event,gpsval)
            disp(sub{s})
            gps = findfield(data.SACR_x.event,gpsval);
            if length(gps) == 3
            data.SACR_x.event.(gpsval) = gps(2);
            end
            end
            zsave(fl{f}, data)
        end
        
    end
end


