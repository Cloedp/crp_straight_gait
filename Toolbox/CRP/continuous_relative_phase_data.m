function data = continuous_relative_phase_data(data, dist_phase_angle_ch, prox_phase_angle_ch)

% CONTINNUOUS_RELATIVE_PHASE_DATA(data, dist_phase_angle_ch,
% prox_phase_angle_ch) computes CRP between two angles
%
% ARGUMENTS
%  data                  ...  data to process 
%  dist_phase_angle_ch   ...   Phase angle channel for distal joint
%  prox_phase_angle_ch   ...   Phase angle channel for proximal joint

dist_angle = data.(dist_phase_angle_ch).line;
prox_angle = data.(prox_phase_angle_ch).line;

CRP_data = CRP(dist_angle,prox_angle);

data = addchannel_data(data, [prox_phase_angle_ch, '_', dist_phase_angle_ch, '_crp'], CRP_data, 'video');