function bmech_del_nocompletegc(fld)
% This function remove trials that have missing complete gait cycle before
% computing bmech_phase_angle

cd(fld)


fl = engine('path',fld,'extension','zoo');

for i = 1:length(fl)
    data = zload(fl{i});
    
    if isempty(findfield(data, 'LFS1')) || isempty(findfield(data, 'LFS2'))
        if isempty(findfield(data, 'RFS1')) || isempty(findfield(data, 'RFS2'))
        delete(fl{i});
        batchdisp(fl{i},'deleting trial because there is no complete gait cycle');
        end
    end
end


