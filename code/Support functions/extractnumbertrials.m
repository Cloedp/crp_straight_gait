function extractnumbertrials(fld)

% R = extractnumberbygroup(fld) extracts number of subjects for each group
%
% ARGUMENTS
%  fld         ...    Folder to operate on as string
%
% RETURNS
%  r           ...    Number of trials by participant 

cd(fld)

s = filesep;

group = {'CPOFM','Aschau_NORM'};

for g = 1:length(group)  
    groupfld = [fld,s,group{g}];
    subjects = GetSubDirsFirstLevelOnly([groupfld]);
    for j = 1:length(subjects)
    trials = engine('path',groupfld,'folder',subjects{j},'extension','zoo');
    numtrials = length(trials);
    disp([num2str(numtrials), ' is the number of trials for the ', subjects{j}])
    end
end

    