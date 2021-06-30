function bmech_gaitprofilescore(fld,flag,RightFS1,RightFS2,LeftFS1,LeftFS2)

% BMECH_GAITPROFILESCORE(fld,flag,RightFS1,RightFS2,LeftFS1,LeftFS2) computes gait variable score (GVS)
% and gait profile score (GPS) based on a reference database
%
% ARGUMENTS
%  fld          ...   folder of subjects to operate on
%  flag         ...   flag in file name for selection of trials. eg. '_g_'
%                     for normal gait
%  RightFS1     ...   Name of the event Right Foot Strike 1
%  RightFS2     ...   Name of the event Right Foot Strike 2
%  LeftFS1      ...   Name of the event Left Foot Strike 1
%  LeftFS2      ...   Name of the event Left Foot Strike 2
%
% NOTES
% - BelfastPelvis_x is int/ext rotation while BelfastPelvis_z is flex/ext


% Created by Philippe C. Dixon April 17th 2014 based on other gaitprofilescore functions

% TODO: fix belfast pelvis

% Set Defaults
%
switch nargin
    case 0
        fld = uigetfolder;
        flag = '_g_';
    case 1
        flag = '';
end

% channels for GPS (from Baker)
ch_gps = {'BelfastPelvisAngles_x', 'BelfastPelvisAngles_y',...
    'BelfastPelvisAngles_z','HipAngles_x','HipAngles_y',...
    'HipAngles_z','KneeAngles_x','AnkleAngles_x',...
    'FootProgressAngles_z'};

cd(fld)

% Extract data by subject (file structure must respect biomechZoo standard)
[~,subs] = extract_filestruct(fld);

% associate each subject with correct normative data----
for i = 1:length(subs)
    sub = subs{i};
    
    if isempty(flag)
        fl = engine('fld',fld,'search path', sub, 'ext', 'zoo');
    else
        fl = engine('fld',fld,'search path', sub, 'search file', flag);
    end
    
    if ~isempty(fl)
        sidestk = cell(size(fl));
        GPSstk = NaN*ones(size(fl));
        %fl = engine('fld',fld,'extension','zoo');
        
        for j = 1:length(fl)
            [~, trial] = fileparts(fl{j});
            data = zload(fl{j});
            if isfield(data,'RPelvisAngles_x')
                sides = {'R', 'L'};
                for k = 1:length(sides)
                    Pel_x = data.([sides{k}, 'PelvisAngles_x']).line;
                    Pel_y = data.([sides{k}, 'PelvisAngles_y']).line;
                    Pel_z = data.([sides{k}, 'PelvisAngles_z']).line;
                    
                    data = addchannel_data(data, [sides{k}, 'BelfastPelvisAngles_x'],Pel_z, 'Video');
                    data = addchannel_data(data, [sides{k}, 'BelfastPelvisAngles_y'],Pel_y, 'Video');
                    data = addchannel_data(data, [sides{k}, 'BelfastPelvisAngles_z'],Pel_x, 'Video');
                end
            end
            
            % TEMP ADDING OF ANTHRO FOR DEMO
            if ~isfield(data.zoosystem.Anthro, 'Age')
                error('missing age info')
            end
            
            if ~isfield(data.zoosystem.Anthro, 'Sex')
                error('missing sex info')
            end
            
            % find appropriate data set for GPS comparison
            [group, norm_data] = iddataset(data);
            disp(' ')
            disp(['computing GPS for subject ',sub, ' trial ', trial, ' for ',group,' age group'])
            
            [GPS_r,GPS_l,r] = computegps(data,norm_data, ch_gps,RightFS1,RightFS2,LeftFS1,LeftFS2);
            if GPS_r == 999
                continue
            else
                data = addgps(data,GPS_r,GPS_l,r);
                zsave(fl{j},data);
            end
        end
    end
end

