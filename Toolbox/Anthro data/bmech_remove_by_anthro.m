function bmech_remove_by_anthro(fld, anthro, value, action)

% BMECH_REMOVE_BY_ANTHRO(fld, anthro, value, action)
% Batch process removal of unwanted participants (data) based on anthro
%
% ARGUMENTS
% fld       ...  Folder to batch process (string)
% anthro    ...  Anthro to operate on. Single string. ex. 'Age'
% value     ...  Condition to remove (i.e.18 to remove adult participants)
% action    ...  Action to take on data (string): '>=','<=','<','>','='
%
% Created 2021
%
% Set defaults/Error check

if nargin==0
    fld = uigetfolder;
    anthro = 'Age';
end

if iscell(anthro)
    anthro = anthro{1};
end

% Batch process

cd(fld)

subjects = extract_filestruct(fld);
for i = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{i});
    data = zload(fl{1});
    
    r = data.zoosystem.Anthro.(anthro);
    if strcmp(action,'>=')
        strcmp(action,'remove')
        if r >= value
            delfile(fl)
        end
    end
    
    if strcmp(action,'<=')
        strcmp(action,'remove')
        if r <= value
            delfile(fl)
        end
    end
    if strcmp(action,'<')
        strcmp(action,'remove')
        if r < value
            delfile(fl)
        end
    end
    if strcmp(action,'>')
        strcmp(action,'remove')
        if r > value
            delfile(fl)
        end
    end
    if strcmp(action,'=')
        strcmp(action,'remove')
        if r == value
            delfile(fl)
        end
    end
end

