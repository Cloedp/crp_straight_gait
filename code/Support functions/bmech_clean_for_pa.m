function bmech_clean_for_pa(fld)
% This function remove trials that have missing event or channel before
% computing bmech_phase_angle
% TO BE ARRANGE!!!! J'AI FUCKED UP LA FONCTION EN GOSSANT DESSUS

cd(fld)


fl = engine('path',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});
    
    if isempty(findfield(data, 'LFS1'))
        delete(fl{i});
        batchdisp(fl{i},'deleting trial because of missing event');
    if isempty(findfield(data, 'RFS1'))
        delete(fl{i});
        batchdisp(fl{i},'deleting trial because of missing event');
        
    elseif isempty(findfield(data, evt2))
        delete(fl{i});
        batchdisp(fl{i},'deleting trial because of missing event');
    elseif ~isfield(data,'LHipAngles_x')
        delete(fl{i});
        batchdisp(fl{i},'deleting trial because of missing channels');
    end
end


