function bmech_clean_for_pa(fld, evt1, evt2)
% This function remove trials that have missing events and channels before
% computing bmech_phase_angle

cd(fld)


fl = engine('path',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});
    
    if isempty(findfield(data, evt1))
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


