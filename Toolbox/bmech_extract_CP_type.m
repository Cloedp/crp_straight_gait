function bmech_extract_CP_type(fld)

% BMECH_EXTRACT_CP_TYPE(fld)
% % Batch process extraction of CP type in the mft sheet
%
% ARGUMENTS
% fld       ...  Folder to batch process (string)
%
% Created 2021
%
% Set defaults/Error check

if nargin==0
    fld = uigetfolder;
end

cd(fld);
fl = engine('fld',fld,'extension','zoo');

for i = 1:length(fl)
    batchdisp(fl{i})
    data = zload(fl{i});
    fld_sub = fileparts(fl{i});
   
    % a) Extract CP type 
    mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
    C = readcell(mft_path);
    [row,col] = find(strcmp(C,'Pathologie'));
            if isempty(C(row,col+1))
                CP_type = 'NA';
            else
                CP_type = strcmp(C(row,col+1),C(row,col+2));
            end
            if CP_type == 1
               CP_type = 'hemiplegia';
            elseif 
               CP_type == 0
               CP_type = 'diplegia';
            end 
    data.zoosystem.Anthro.CP_type = CP_type; % write to zoo
    zsave(fl{i}, data)
end 