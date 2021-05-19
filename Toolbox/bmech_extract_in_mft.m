function bmech_extract_in_mft(fld,anthro)

% EXTRACT_IN_MFT(fld, anthro)
% Batch process removal of unwanted participants (data) based on anthro

% ARGUMENTS
% fld       ...  Folder to batch process (string)
% anthro    ...  Anthro(s) to extract from the mft sheet

% Created 2021

% Set defaults/Error check

if nargin==0
    fld = uigetfolder;
end

if ~iscell(anthro)
    anthro = {anthro};
end

cd(fld);
fl = engine('fld',fld,'extension','zoo');
for i = 1:length(fl)
    data = zload(fl{i});
    fld_sub = fileparts(fl{i});
    
    % a) Extract Age
    if strcmp(anthro,'Age')
        if ~isfield(data.zoosystem.Anthro,'Age') % Extract if not
        mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
        C = readcell(mft_path);
        [row,col] = find(strcmp(C,'Alter bei Messung'));
        Age = C(row,col+1);
        data.zoosystem.Anthro.Age = Age; % write to zoo
        end
    end 
    %b) Extract Sex
    if strcmp(anthro,'Sex')
        if ~isfield(data.zoosystem.Anthro,'Sex')
        mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
        C = readcell(mft_path);
        [row,col] = find(strcmp(C,'Geschlecht')); 
        Sex = C(row,col+1);
        data.zoosystem.Anthro.Sex = Sex; % write to zoo (1=M, 2=F)
        end 
    end
    %c) Extract GMFCS
    if strcmp(anthro,'GMFCS')
        if ~isfield(data.zoosystem.Anthro,'GMFCS')
        mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
        C = readcell(mft_path);
        [row,col] = find(strcmp(C,'GMFCS'));
            if ismissing(C(row,col+1))
               GMFCS = 0;
            else
            GMFCS = C(row,col+1);
            end
        data.zoosystem.Anthro.GMFCS = GMFCS; % write to zoo
        end
    end    
        zsave(fl{i}, data)
end 