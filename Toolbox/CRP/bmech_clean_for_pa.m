function bmech_clean_for_pa(fld)
% This function remove trials that have missing events and channels beforme
% computing bmech_phase_angle
    
cd(fld)
evt1 = 'Left_FootStrike1';
evt2 = 'Left_FootStrike2';

fl = engine('path',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});
    
    if isempty(findfield(data, evt1)) 
    delfile(fl{i}); 
    elseif isempty(findfield(data, evt2))
    delfile(fl{i});
    elseif ~isfield(data,'LHipAngles_x')
    delfile(fl{i});  
    end
end

end


