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
[~,subjects] = extract_filestruct(fld0);
for i = 1:length(subjects)
    fl = engine('fld',fld0, 'search path', subjects{i}, 'extension','c3d'); % chek for only c3d files
    if isempty(fl)                                                          % if no csv files
    bmech_removefolder(fld0,subjects{i});
    disp(['removing subject ', subjects{i},' because he has no files'])
    end
end

% d) Delete folder with no mft sheet
[~,subjects] = extract_filestruct(fld0);
for i = 1:length(subjects)
    fl = engine('fld',fld0, 'search path', subjects{i},'extension','csv');  % chek for only csv files
    if isempty(fl)                                                          % if no csv file = no mft file
    bmech_removefolder(fld0,subjects{i}); 
    disp(['removing subject ', subjects{i},' because he has no mft sheet'])                                   % remove subject because not enough info
    end
end

%% STEP 1: CONVERT C3D TO ZOO FILE

fld1 = [fld,filesep, 'data', filesep, '1-c3d2zoo'];

% a) Copy c3d clean files
if exist(fld1, 'dir')
    disp('removing old  data folder...')
    rmdir(fld1)
end
copyfile(fld0,fld1);

% b) Covert c3d to zoo
c3d2zoo(fld1,'yes');
      
%% STEP 2: REMOVE ADULTS (-18 YEARS OLD)

fld2 = [fld,filesep, 'data', filesep,'2-remove_adults'];

% a) Copy step 1 files
if exist(fld2, 'dir')
    disp('removing old  data folder...')
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
    disp('removing old  data folder...')
    rmdir(fld3)
end
copyfile(fld2,fld3)

% b) Extract Anthro Sex & GMFCS  
bmech_extract_in_mft(fld3,'Sex');   %(1=M, 2=F)
bmech_extract_in_mft(fld3,'GMFCS');

% c) delete mft file
fl = engine('fld',fld3,'extension','csv'); 
delfile(fl);

%% STEP 4: REMOVE CHANNELS

fld4 = [fld,filesep, 'data', filesep, '4-remove_channels'];

% a) Copy step 3 files
if exist(fld4, 'dir')
    disp('removing old  data folder...')
    rmdir(fld4)
end
copyfile(fld3,fld4)

% b) Remove extra Vicon channels
chkp= {'LHipAngles','RHipAngles', 'LKneeAngles','RKneeAngles',...
       'LAnkleAngles','RAnkleAngles','SACR','LPelvisAngles',...
       'RPelvisAngles','LFootProgressAngles','RFootProgressAngles'};  

bmech_removechannel(fld4,chkp,'keep')

% c) Explode channels 

bmech_explode(fld4,chkp)

%% STEP 5: COMPUTE GPS

fld5 = [fld,filesep, 'data', filesep, '5-compute_gps'];

% a) Copy step 4 files
if exist(fld5, 'dir')
    disp('removing old  data folder...')
    rmdir(fld5)
end
copyfile(fld4,fld5);

bmech_gaitprofilescore(fld5);

%% STEP 6: CRP PROCESS

fld6 = [fld,filesep, 'data', filesep, '6-process_crp'];

% a) Copy step 5 files
if exist(fld6, 'dir')
    disp('removing old  data folder...')
    rmdir(fld6)
end
copyfile(fld5,fld6)

% b) Remove trials that have missing events and channels 
% *** PARFOIS JUSTE RIGHT_FOOTSTRIKE1,2 ET JUSTE UN LEFT

bmech_clean_for_pa(fld6); % **** ICI IL Y A UN ANS=0 QUI GOSSE

% b) compute phase angle on complete signal 
chns = {'LHipAngles_x', 'LKneeAngles_x','LAnkleAngles_x'};
evt1 = 'Left_FootStrike1';
evt2 = 'Left_FootStrike2';
bmech_phase_angle(fld6, chns, evt1, evt2)

% c) partition to 1 gait cycle
%evt1 = 'Left_FootStrike1';
%evt2 = 'Left_FootStrike2';
%bmech_partition(fld6, evt1, evt2)

% d) normalize to 100
bmech_normalize(fld6)

% e) Compute CRP
ch_KH = {'LKneeAnglesPhase_x','LHipAnglesPhase_x'}; 
ch_AK = {'LAnkleAnglesPhase_x','LKneeAnglesPhase_x'}; 
bmech_continuous_relative_phase(fld6, ch_KH)
bmech_continuous_relative_phase(fld6, ch_AK)

% f) Calculate deviation phase (DP) and mean absolute relative phase (MARP)
%bmech_computeMARP_straight(fld6,'L')
%bmech_computeMARP_straight(fld6,'R')
%bmech_computeDP_straight(fld6,'L')
%bmech_computeDP_straight(fld6,'R')


%% STEP 7: ADD EVENTS

%% STEP 8: EXPORT
% local event