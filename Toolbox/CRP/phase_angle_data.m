function data = phase_angle_data(data, chns, dim)

if nargin == 2
    dim = '_x';
end
    
% compute phase angle and add to data
for i = 1:length(chns)
    joint_angle = data.(chns{i}).line;
    pa = phase_angle(joint_angle);
    och = chns{i};
    nch = strrep(och, dim, ['Phase', dim]);
    
    data = addchannel_data(data, nch, pa, 'video');

end