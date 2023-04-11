%% PREPARATION: ClEANING DATA

fld = uigetfolder;              % Select crp_straight_gait
fld_c3d = [fld,filesep, 'data', filesep, 'c3d_data'];
fld0 = [fld,filesep, 'data', filesep, '0-c3d_clean'];

% a) Copy c3d files
copyfile(fld_c3d,fld0);

% b) Delete trials that are not self-selected speed 
fldel_gl = engine('fld',fld0,'search file','_gl_'); 
fldel_gs = engine('fld',fld0,'search file','_gs_'); 
fldel_st = engine('fld',fld0,'search file','_st_'); 
delfile(fldel_gl);
delfile(fldel_gs);
delfile(fldel_st);

% c) Delete abnormal folders (empty)

group = {'CPOFM','Aschau_NORM'};

for g = 1:length(group)
    subjects = GetSubDirsFirstLevelOnly([fld0, filesep, group{g}]);
    for i = 1:length(subjects)
        fl = engine('fld',fld0, 'folder', subjects{i}, 'extension','c3d');      % chek for only c3d files
        if isempty(fl)     
        disp(['removing subject ', subjects{i},' because he has no files'])
        rmdir(fullfile(fld0,group{g},subjects{i}));  
        end
    end
end

% d) Delete folder with no mft sheet
for g = 1:length(group)
    subjects = GetSubDirsFirstLevelOnly([fld0, filesep, group{g}]);
    for i = 1:length(subjects)
        fl = engine('fld',fld0, 'folder', subjects{i},'extension','csv');       % chek for only csv files
        if isempty(fl)                                                          % if no csv file = no mft file
        disp(['removing subject ', subjects{i},' because he has no mft sheet'])
        rmdir(fullfile(fld0,group{g},subjects{i}));                                                   % remove subject because not enough info
        end
    end
end
%% STEP 1: CONVERT C3D TO ZOO FILE

fld1 = [fld,filesep, 'data', filesep, '1-c3d2zoo'];

% a) Copy c3d clean files
if exist(fld1, 'dir')
    disp('removing old data folder...')
    rmdir(fld1)
end
copyfile(fld0,fld1);

% b) Convert c3d to zoo
c3d2zoo(fld1,'yes');
      
%% STEP 2: REMOVE ADULTS (-18 YEARS OLD)

fld2 = [fld,filesep, 'data', filesep,'2-remove_adults'];

% a) Copy step 1 files
if exist(fld2, 'dir')
    disp('removing old data folder...')
    rmdir(fld2)
end
copyfile(fld1,fld2)

% b) Extract age of participants 
bmech_extract_in_mft(fld2,'Age');

% c) Batch remove adults 
bmech_remove_by_anthro(fld2,'Age',18,'>=');

%% STEP 3: EXTRACT MUSCLE FUNCTION DATA FROM CSV SHEET

fld3 = [fld,filesep, 'data', filesep,'3-muscle_extract'];

% a) Copy step 2 files
if exist(fld3, 'dir')
    disp('removing old data folder...')
    rmdir(fld3)
end
copyfile(fld2,fld3)

% b) Extract Sex & GMFCS and/or missing anthro (Bodymass, Height)  
bmech_extract_in_mft(fld3,'Sex');   %(1=M, 2=F)
bmech_extract_in_mft(fld3,'GMFCS');
bmech_extract_in_mft(fld3,'Bodymass');
bmech_extract_in_mft(fld3,'Height');

% c) Delete mft file
fl = engine('fld',fld3,'extension','csv'); 
delfile(fl);

%% STEP 4: PREPARE DATA FOR ANALYSIS

fld4 = [fld,filesep, 'data', filesep, '4-remove_channels'];

% a) Copy step 3 files
if exist(fld4, 'dir')
    disp('removing old data folder...')
    rmdir(fld4)
end
copyfile(fld3,fld4)

% b) Explode channels 

bmech_explode(fld4)

% c) Add Foot Strike events
bmech_addevent(fld4, 'SACR_x','RFS', 'RFS')
bmech_addevent(fld4, 'SACR_x','LFS', 'LFS')

% d) Remove extra Vicon channels
chkp= {'LHipAngles_x','LHipAngles_y','LHipAngles_z',...
       'RHipAngles_x','RHipAngles_y','RHipAngles_z',...
       'LKneeAngles_x','LKneeAngles_y','LKneeAngles_z',...
       'RKneeAngles_x','RKneeAngles_y','RKneeAngles_z',...
       'LAnkleAngles_x','LAnkleAngles_y','LAnkleAngles_z',...
       'RAnkleAngles_x','RAnkleAngles_y','RAnkleAngles_z',...
       'SACR_x','SACR_y','SACR_z','LPelvisAngles_x',...
       'LPelvisAngles_y','LPelvisAngles_z','RPelvisAngles_x',...
       'RPelvisAngles_y','RPelvisAngles_z','LFootProgressAngles_x',...
       'LFootProgressAngles_y','LFootProgressAngles_z',...
       'RFootProgressAngles_x','RFootProgressAngles_y','RFootProgressAngles_z'};  

bmech_removechannel(fld4,chkp,'keep')

% e) Remove trials that have missing events and/or channels 

evt1 = 'LFS1';
evt2 = 'LFS2';

bmech_clean_for_pa(fld4,evt1, evt2); 

%% STEP 5: COMPUTE GPS

fld5 = [fld,filesep, 'data', filesep, '5-compute_gps'];

% a) Copy step 4 files
if exist(fld5, 'dir')
    disp('removing old data folder...')
    rmdir(fld5)
end
copyfile(fld4,fld5);

% b) Compute GPS
RightFS1 = 'RFS1';
RightFS2 = 'RFS2';
LeftFS1 = 'LFS1';
LeftFS2 = 'LFS2';
flag = '_g_';
bmech_gaitprofilescore(fld5,flag,RightFS1,RightFS2,LeftFS1,LeftFS2);

%% STEP 6: CRP PROCESS

fld6 = [fld,filesep, 'data', filesep, '6-process_crp'];

% a) Copy step 5 files
if exist(fld6, 'dir')
    disp('removing old data folder...')
    rmdir(fld6)
end
copyfile(fld5,fld6)

% b) Compute phase angle on complete signal 
chns = {'LHipAngles_x', 'LKneeAngles_x','LAnkleAngles_x'};
bmech_phase_angle(fld6, chns)

% d) Partition to a complete gait cycle
evt1 = 'LFS1';
evt2 = 'LFS2';
bmech_partition(fld6, evt1, evt2)

% e) Compute CRP
bmech_continuous_relative_phase(fld6, 'LKneeAnglesPhase_x','LHipAnglesPhase_x') % for KH
bmech_continuous_relative_phase(fld6, 'LAnkleAnglesPhase_x','LKneeAnglesPhase_x') % For AK

% f) Normalize to 101 frames
bmech_normalize(fld6)

%% STEP 7: COMPUTE METRICS (MARP, DP)

fld7 = [fld,filesep, 'data', filesep, '7-compute-MARP-DP'];

% a) Copy step 6 files
if exist(fld7, 'dir')
    disp('removing old data folder...')
    rmdir(fld7)
end
copyfile(fld6,fld7)

% b) Compute MARP and DP

bmech_computeMARP_DP(fld7)

% c) Remove subjects with not enough trials for MARP and DP computation

bmech_remove_2_trials_or_less(fld7)

%% STEP 8: CREATE GAIT EVENTS

fld8 = [fld,filesep, 'data', filesep, '8-gait-events'];

% a) Copy step 7 files
if exist(fld8, 'dir')
    disp('removing old data folder...')
    rmdir(fld8)
end
copyfile(fld7,fld8)

% b) Create gait events 
bmech_create_gait_events(fld8) 

%% STATISTICAL ANALYSIS (impro)

type = 'unpaired';
alpha = 0.05;
thresh = 0.05;
tail = 'both';
mode = 'full';
bonf = 1;

% a) GPS difference between groups (CPOFM/NORM) 
gps = {'GPS'};
group = {'Aschau_NORM', 'CPOFM'};
ch= 'SACR_x';
gps_comparison(fld_stats,group,gps,ch,type,alpha,thresh,tail,mode,bonf)

% b) GPS difference between CPOFM subgroups (GMFCS level)
gps = {'GPS_L'};
ch= 'SACR_x';
group = {'Level1','Level2'};
gps_comparison_gmfcs(fld_stats,group,gps,ch,type,alpha,thresh,tail,mode,bonf)

% c) MARP and DP difference between CPOFM subgroups (GMFCS level)
evt = {'IC', 'LR', 'MS', 'TS', 'PSw','ISw','MSw','TSw'};
bonf = 1;
group = {'Level1','Level2','Level3'};
metrics = {'L_KH_MARP','L_AK_MARP','L_KH_DP','L_AK_DP'};
metrics_comparison_gmfcs(fld_stats,group,metrics,evt,type,alpha,thresh,tail,mode,bonf)

% d) MARP and DP difference between groups at each event
evt = {'IC', 'LR', 'MS', 'TS', 'PSw','ISw','MSw','TSw'};
group = {'Aschau_NORM', 'CPOFM'};
bonf = 1;                                                                   % Changer pour 32 
MARP_DP_stats(fld_stats,group,evt,type,alpha,thresh,tail,mode,bonf)

%% GENERATE TABLES (impro)

fld9 = [fld,filesep, 'data', filesep, '9-tables'];

% a) Copy step 6 files
if exist(fld9, 'dir')
    disp('removing old data folder...')
    rmdir(fld9)
end
copyfile(fld8,fld9)

cd(fld9)

groups = GetSubDirsFirstLevelOnly(fld9);

for g = 1:length(groups)
    sub = GetSubDirsFirstLevelOnly([fld9, filesep, groups{g}]);
    for s = 1:length(sub)
        disp(sub{s})
        fl = engine('fld',fld9,'folder', sub{s},'extension','zoo');
        for f = 2:length(fl)
            delete(fl{f});
        end 
    end
end

sub1 = GetSubDirsFirstLevelOnly([fld9, filesep, groups{1}]);

sub2 = GetSubDirsFirstLevelOnly([fld9, filesep, groups{2}]);

anthro_evts = {'Height','Bodymass', 'Sex', 'Age', 'GMFCS'};
chns = {''};
fld10 = [fld,filesep, 'data', filesep, '9-tables', filesep, 'Aschau_NORM'];
fld11 = [fld,filesep, 'data', filesep, '9-tables', filesep, 'CPOFM'];

evalFile = eventval('fld', fld10, 'dim1', groups, 'dim2', sub1, 'ch', chns, ...
    'localevents', 'none', 'globalevents','none', 'anthroevts', anthro_evts);

evalFile = eventval('fld', fld11, 'dim1', groups, 'dim2', sub2, 'ch', chns, ...
    'localevents', 'none', 'globalevents','none', 'anthroevts', anthro_evts);

%% STEP 11: GROUP COMPARISON 

fld_stats = [fld,filesep, 'data', filesep, 'Compa-group'];

type = 'unpaired';
alpha = 0.05;
thresh = 0.05;
tail = 'both';
mode = 'full';
bonf = 1;

% a) Quantitative stats

extractnumberbyGMFCS(fld_stats)
extractnumberbygroup(fld_stats)

% b) Group similarity for anthro (NORM\CPOFM)
anthro = {'Age','Height','Bodymass'};
group = {'Aschau_NORM', 'CPOFM'};
ch= 'zoosystem';
group_comparison(fld_stats,group,anthro,ch,type,alpha,thresh,tail,mode,bonf)

%% TABLES ANTHRO DATA

fld_anthro = [fld,filesep, 'data', filesep, 'anthro'];

if exist(fld_anthro, 'dir')
    disp('removing old data folder...')
    rmdir(fld_anthro)
end

copyfile(fld_stats,fld_anthro)

cd(fld_anthro)

groups = GetSubDirsFirstLevelOnly(fld_anthro);

for g = 1:length(groups)
    sub = GetSubDirsFirstLevelOnly([fld_anthro, filesep, groups{g}]);
    for s = 1:length(sub)
        fl = engine('fld',fld_anthro,'folder', sub{s},'extension','zoo');
        for f = 2:length(fl)
            delete(fl{f});
        end 
    end
end

% c) Make tables

[~,subjects] = extract_filestruct(fld_anthro);

anthro_evts = {'Height','Bodymass', 'Sex', 'Age', 'GMFCS'};
chns = {''};

anthroFile = eventval('fld', fld_anthro, 'dim1', groups, 'dim2', subjects, 'ch', chns, ...
    'localevents', 'none', 'globalevents','none', 'anthroevts', anthro_evts);

%% FOR REGRESSION MARP_DP_GPS

fld = uigetfolder;
group = {'CPOFM'};
chns = {'L_KH_MARP','L_AK_MARP','L_KH_DP','L_AK_DP'};
subjects = GetSubDirsFirstLevelOnly(fld);
lcl_evts = {'IC', 'LR', 'MS', 'TS', 'PSw','ISw','MSw','TSw'};
antro_evts = {'GPS_L'};

% Good GPS value
gpsval = 'GPS_L';
bmech_transformGPSvalue(fld,gpsval)

evalFile = eventval('fld', fld, 'dim1', groups, 'dim2', subjects, 'ch', chns, ...
'localevents', lcl_evts, 'globalevents', 'none' ,'anthroevts', antro_evts);