function bmech_remove_by_anthro(fld, anthro, value, action)

% BMECH_REMOVE_BY_ANTHRO(fld, anthro, value, action) 
% Batch process removal of unwanted participants (data) based on anthro 

% ARGUMENTS 
% fld       ...  Folder to batch process (string)
% anthro    ...  Anthro(s) to operate on (single string or cell array of strings)
% value     ...  Condition to remove (i.e.18 to remove adult participants)
% action    ...  Action to take on data (string): '>=','<=','<','>','='

% Created 2021

% Set defaults/Error check

if ~iscell(anthro)
    anthro = {anthro};
end

% Batch process

cd(fld)
fl = engine('fld',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});
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

