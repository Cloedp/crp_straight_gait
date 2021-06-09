function bmech_continuous_relative_phase(fld, chns)

% BMECH_CONTINUOUS_RELATIVE_PHASE(fld, side)
% Batch compute crp on straight gait trials
%
% ARGUMENTS
% fld       ...  Folder to batch process (string)
% limb      ...  limb to compute crp (string) 'L' or 'R'
%
% Created 2021

fl = engine('fld',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{1});
    
    % compute CRP
    dist_phase_angle_ch = chns{1};
    prox_phase_angle_ch = chns{2};
    data = continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch);
    
    % save to zoo file
    zsave(fl{i}, data)
end