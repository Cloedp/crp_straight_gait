function bmech_extract_in_mft(fld,anthro)

% EXTRACT_IN_MFT(fld, anthro)
% Batch process extraction of anthro data in the mft sheet
%
% ARGUMENTS
% fld       ...  Folder to batch process (string)
% anthro    ...  Anthro(s) to extract from the mft sheet
%
% Created 2021
%
% Set defaults/Error check

if nargin==0
    fld = uigetfolder;
    anthro = 'Age';
end

if ~iscell(anthro)
    anthro = {anthro};
end

cd(fld);
fl = engine('fld',fld,'extension','zoo');
for i = 1:length(fl)
    batchdisp(fl{i}, 'extracting mft')
    data = zload(fl{i});
    fld_sub = fileparts(fl{i});
    
    % a) Extract Age
    if strcmp(anthro,'Age')
        if ~isfield(data.zoosystem.Anthro,'Age') % Extract if not
            mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
            C = readcell(mft_path);
            [row,col] = find(strcmp(C,'Alter bei Messung'));
            Age = C(row,col+1);
            data.zoosystem.Anthro.Age = Age{1}; % write to zoo
        end
    end
    %b) Extract Sex
    if strcmp(anthro,'Sex')
        if ~isfield(data.zoosystem.Anthro,'Sex')
            mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
            C = readcell(mft_path);
            [row,col] = find(strcmp(C,'Geschlecht'));
            Sex = C(row,col+1);
            data.zoosystem.Anthro.Sex = Sex{1}; % write to zoo (1=M, 2=F)
        end
    end
    %c) Extract GMFCS
    if strcmp(anthro,'GMFCS')
        if ~isfield(data.zoosystem.Anthro,'GMFCS')
            mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
            C = readcell(mft_path);
            [row,col] = find(strcmp(C,'GMFCS - RUN'));
            if isempty(row)
                [row,col] = find(strcmp(C,'GMFCS'));
            end
            a = C(row,col+1);
            if isempty(a)
                GMFCS = 0;
            elseif strcmp(a,'-')
                GMFCS = 0;
            elseif strcmp(a,'I')
                GMFCS = 1;
            elseif strcmp(a,'II')
                GMFCS = 2;
            elseif strcmp(a,'III')
                GMFCS = 3;
            elseif ismissing(a{1})
                GMFCS = 0;
            else
                GMFCS = a{1};
            end
            data.zoosystem.Anthro.GMFCS = GMFCS; % write to zoo
        end
    end
            % extract Bodymass if there is not already
            
    if strcmp(anthro,'Bodymass')
        if ~isfield(data.zoosystem.Anthro,'Bodymass')
            mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
            C = readcell(mft_path);
            [row,col] = find(strcmp(C,'Körpergewicht'));
            Bodymass = C(row,col+1);
            data.zoosystem.Anthro.Bodymass = Bodymass{1}; 
        end
    end
            
            % extract Height if there is not already
    if strcmp(anthro,'Height')
        if ~isfield(data.zoosystem.Anthro,'Height')
            mft_path = [fld_sub, filesep, 'Muskelfunktionstest.csv']; % Set path mft.csv
            C = readcell(mft_path);
            [row,col] = find(strcmp(C,'Körpergröße'));
            Height = C(row,col+1);
            data.zoosystem.Anthro.Height = Height{1}; 
        end
    end
         
    zsave(fl{i}, data)
end