function bmech_crp(fld, chns)

% BMECH_COMPUTECRP_STRAIGHT(fld, side)
% Batch compute crp on straight gait trials
%
% ARGUMENTS
% fld       ...  Folder to batch process (string)
% limb      ...  limb to compute crp (string) 'L' or 'R'
%
% Created 2021

[subjects] = extract_filestruct(fld);

for i = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{i});
    data = zload(fl{1});
    
    % normalized data in 101 frames
    normalize_data(data)
    
    % compute phase angle using hilbert transform
    if strcmp(limb,'L')
        evt1 = 'Left_FootStrike1'; % data before and after evt1 and evt2 are used for padding
        evt2 = 'Left_FootStrike2';
        chns = {'LHipAngles_x','LKneeAngles_x'};
        data = phase_angle_data(data, chns, evt1, evt2);
        
        % compute CRP for Knee-Hip
        dist_phase_angle_ch = 'LKneeAngles_x_phase';
        prox_phase_angle_ch = 'LHipAngles_x_phase';
        data = continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch);
        
        % compute CRP for Ankle-knee
        
        dist_phase_angle_ch = 'LAnkleAngles_x_phase';
        prox_phase_angle_ch = 'LKneeAngles_x_phase';
        continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch)
    end
    
    if strcmp(limb,'R')
        evt1 = 'Right_FootStrike1'; % data before and after evt1 and evt2 are used for padding
        evt2 = 'Right_FootStrike2';
        chns = {'RHipAngles_x','RKneeAngles_x'};
        phase_angle_data(data, chns, evt1, evt2)
        
        % compute CRP for Knee-Hip
        dist_phase_angle_ch = 'RKneeAngles_x_phase';
        prox_phase_angle_ch = 'RHipAngles_x_phase';
        continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch)
        
        % compute CRP for Ankle-knee
        
        dist_phase_angle_ch = 'RAnkleAngles_x_phase';
        prox_phase_angle_ch = 'RKneeAngles_x_phase';
        continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch)
    end
    
    zsave(fl{i}, data)
end