function bmech_remove_2_trials_or_less(fld)
%This function delete subjects with less than 2 trials. 

cd(fld)

[~,subjects] = extract_filestruct(fld);

for s = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{s});
        if size(fl) < 2
        disp(['removing subject ', subjects{s},' because of insufficient trials for MARP and DP computation'])
        bmech_removefolder(fld,subjects{s});
        end
end

