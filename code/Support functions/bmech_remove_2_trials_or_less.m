function bmech_remove_2_trials_or_less(fld)
%This function delete subjects with less than 2 trials. 

cd(fld)

group = {'CPOFM','Aschau_NORM'};

for g = 1:length(group)
    subjects = GetSubDirsFirstLevelOnly([fld, filesep, group{g}]);
    for s = 1:length(subjects)
        fl = engine('fld',fld,'extension','zoo', 'folder', subjects{s});
            if size(fl) < 2
            disp(['removing subject ', subjects{s},' because of insufficient trials for MARP and DP computation'])
            rmdir(fullfile(fld,group{g},subjects{s}),'s');  
            end
    end
end
