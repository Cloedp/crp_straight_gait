%% STEP 1: CONVERT C3D TO ZOO FILE

fld = uigetfolder;       % Select crp_straight_gait
fld_c3d = [fld,'data/c3d_data'];
fld1 = [fld,'data/1-c3d2zoo'];

% a) Copy c3d files
bmech_copyall(fld_c3d,fld1,'all')

% b) Delete trials that are not self-selected speed 
fldel_gl = engine('fld',fld1,'search file','_gl_'); 
fldel_gs = engine('fld',fld1,'search file','_gs_'); 
fldel_st = engine('fld',fld1,'search file','_st_'); 
delfile(fldel_gl);
delfile(fldel_gs);
delfile(fldel_st);

% c) Covert c3d to zoo
c3d2zoo(fld1,'yes')

%% STEP 2: EXTRACT MUSCLE FUCNTION DATA FROM CSV SHEET

%fld1 = [fld,'data/1-c3d2zoo'];
%fld2 = [fld,'data/2-muscle_extract'];

% a) Copy step 1 files
%bmech_copyall(fld1,fld2,'all')

% b) Create new anthro events for channel Anthro 
        bmech_extract_in_mft(fld2,'Age');
        bmech_extract_in_mft(fld2,'Sex');
        bmech_extract_in_mft(fld2,'GMFCS');
      
%% STEP 3: REMOVE ADULTS (-18 YEARS OLD?)

fld2 = [fld,'data/2-muscle_extract'];
fld3 = [fld,'data/3-remove_adults'];

% a) Copy step 2 files
bmech_copyall(fld2,fld3,'all')

% b) Batch remove adults 
bmech_remove_by_anthro(fld3,'Age',18,'>=');

%% STEP 4: REMOVE UNUSED CHANNELS

fld3 = [fld,'data/3-remove_adults'];
fld4 = [fld,'data/4-remove_channels'];

% a) Copy step 3 files
bmech_copyall(fld3,fld4,'all')

% Remove extra Vicon channels 
chkp= {'LHipAngles','RHipAngles', 'LKneeAngles','RKneeAngles',...
       'LAnkleAngles','RAnkleAngles','SACR'};  
bmech_removechannel('fld',fld4,'chkp','keep')

%% STEP 5: COMPUTE GPS

fld4 = [fld,'data/4-remove_channels'];
fld5 = [fld,'data/5-compute_gps'];

% a) Copy step 4 files
bmech_copyall(fld4,fld5,'all')

%% STEP 6: CRP PROCESS

fld5 = [fld,'data/5-compute_gps'];
fld6 = [fld,'data/6-process_crp'];

% a) Copy step 5 files
bmech_copyall(fld5,fld6,'all')

%% STEP 7: ADD EVENTS

%% STEP 8: EXPORT
% local event