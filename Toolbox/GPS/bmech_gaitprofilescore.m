function bmech_gaitprofilescore(fld,flag)

% BMECH_GAITPROFILESCORE(fld,flag) computes gait variable score (GVS)
% and gait profile score (GPS) based on a reference database
%
% ARGUMENTS
%  fld          ...   folder of subjects to operate on
%  flag         ...   flag in file name for selection of trials. eg. '_g_'
%                     for normal gait
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
[~, subs] = extract_filestruct(fld);

% associate each subject with correct normative data----
for i = 1:length(subs)
    sub = subs{i};
    
    if isempty(flag)
        fl = engine('fld',fld,'search path', sub);
    else
        fl = engine('fld',fld,'search path', sub, 'search file', flag);
    end
    
    if ~isempty(fl)
        
        sidestk = cell(size(fl));
        GPSstk = NaN*ones(size(fl));
        for j = 1:length(fl)
            
            [~, trial, ext] = fileparts(fl{j});
            if strcmp(ext, '.c3d')
                data = c3d2zoo(fl{j});
            elseif strcmp(ext, '.zoo')
                data =  zload(fl{1});  % load the first to check age and sex
            else
                error(['unknown file type: ', ext])
            end
            
            % make sure data are exploded
            if ~isfield(data, 'RKneeAngles_x')
                data = explode_data(data);
            end
            
            % check if data have belfast pelvis
            if ~isfield(data, 'RBelfastPelvisAngles_x')
                warning('belfast pelvis angles,, not available using Pig pelvis')
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
            
            [GPS_r,GPS_l,r] = computegps(data,norm_data, ch_gps);
            if GPS_r == 999
                continue
            else
                data = addgps(data,GPS_r,GPS_l,r);
                zsave(fl{j},data);
            end
            
            % use following line with caution
            % checkconsis(sub,sidestk,GPSstk)
        end
    end
    
end


function checkconsis(sub,sidestk,GPSstk)

% check consistency amongs straight trials
fl = engine('path',sub,'extension','zoo');

sidestk(cellfun(@isempty,sidestk)) = [];   % That's some hot programming
sides1 = unique(sidestk);

if length(sides1)>1 && nanmean(GPSstk)>1.6
    
    disp('Different sides selected for more affected!')
    
    if isin(sub,'TD')
        
        for d = 1:length(fl)
            delfile(fl{d})
        end
        rmdir(sub)
        
    else
        error('remove bad trial')
    end
    
elseif length(sides1)>1 && nanmean(GPSstk)<1.6
    fix = 'yes';
    disp('small disagreement across sides, picking random side')
    side = sidestk{1}; % this is random
elseif isempty(sides1)
    disp('deleting subject with no straight trials')
    rmdir(sub,'s')
else
    fix = 'no';
    side = sides1{1}; % there is only 1 and it is always the same
    
end


fl = engine('path',sub,'extension','zoo');



for j = 1:length(fl)  % cycle through again correcting turning
    
    data = zload(fl{j});
    
    
    if ~isin(data.zoosystem.CompInfo.Condition,'Straight')
        cside = data.zoosystem.CompInfo.GC_MoreAffectedSide;
        
        if cside ~=side
            batchdisplay(fl{j},'correcting MA limb based on straight')
            data.zoosystem.CompInfo.GC_MoreAffectedSide = sidestk{1};
            save(fl{j},'data');
        end
        
    elseif isin( data.zoosystem.CompInfo.Condition,'Straight') && isin(fix,'yes')
        cside = data.zoosystem.CompInfo.GC_MoreAffectedSide;
        
        if cside ~=side
            batchdisplay(fl{j},'making all straight the same ')
            data.zoosystem.CompInfo.GC_MoreAffectedSide = side;
            save(fl{j},'data');
        end
        
    end
    
    
    
    
end


function data = addgps(data,GPS_r,GPS_l,r)

ech = 'SACR_x';
%---simple GPS computations
%
gps = nanmean([GPS_r GPS_l]);
gps_diff = abs(GPS_r-GPS_l);

% Add GPS events
data.(ech).event.GPS_R    = [1 GPS_r 0];  % OGL always comes out as side1-->R, side2-->L
data.(ech).event.GPS_L    = [1 GPS_l 0];
data.(ech).event.GPS_diff = [1 gps_diff 0];
data.(ech).event.GPS      = [1 gps 0];

% Add GVS info from r struct
rch = fieldnames(r);
for i = 1:length(rch)
    
    rchn = rch{i};
    under = strfind(rchn,'_');
    dim = rchn(under:end);
    chn = rchn(1:under-1);
    
    data.(rch{i}).event.gvs =  r.(rch{i}).event.gvs;
    
    
end



function [group, norm_data] = iddataset(data)

group = findgpsgroup(data);
norm_data = GetOGLnormGPS(group);










