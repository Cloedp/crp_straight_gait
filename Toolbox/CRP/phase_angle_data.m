function data = phase_angle_data(data, chns, evt1, evt2)

if isempty(evt1)
    events = false;
else
    events = true;
    evt1_indx = findfield(data, evt1);
    evt2_indx = findfield(data, evt2);  
    evt1_indx = evt1_indx(1);
    evt2_indx = evt2_indx(1);
end

    
% compute phase angle and add to data
for i = 1:length(chns)
    joint_angle = data.(chns{i}).line;
    if events
        pa = phase_angle(joint_angle, evt1_indx, evt2_indx);
    else
        pa = phase_angle(joint_angle);
    end
    
    data = addchannel_data(data, [chns{i}, '_phase'], pa, 'video');
    
end