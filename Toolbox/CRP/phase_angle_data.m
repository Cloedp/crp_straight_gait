function data = phase_angle_data(data, chns, dim)

if nargin == 2
    dim = '_x';
end
    
% compute phase angle and add to data
for i = 1:length(chns)
    joint_angle = data.(chns{i}).line;
   %if events %crée un bug parce que pahse_angle prend juste 1 input
        %pa = phase_angle(joint_angle, evt1_indx, evt2_indx);
    %else
    pa = phase_angle(joint_angle);
    och = chns{i};
    nch = strrep(och, dim, ['Phase', dim]);
    
    data = addchannel_data(data, nch, pa, 'video');

end