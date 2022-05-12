function bmech_computeMARP_DP(fld)
% This function batch compute the Mean Absolute Relative Phase (MARP)and
% Deviation Phase (DP). This function add the MARP and DP values in all
% files for every subjects if sufficients
% 

%   fld    ...  folder to batch compute the MARP

cd(fld)

[~,subjects] = extract_filestruct(fld);

for s = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{s});
        if size(fl) < 2
        batchdisp(subjects{s},'insufficient trials for CRP analysis')
        else    
        % Preparing data
         L_KH_CRP_stk = ones(length(fl), 101); 
         L_AK_CRP_stk = ones(length(fl), 101);
            for i = 1:length(fl)
                data = zload(fl{i});
                L_KH_CRP_stk(i,:) = data.LHipAnglesPhase_x_LKneeAnglesPhase_x_crp.line;
                L_AK_CRP_stk(i,:) = data.LKneeAnglesPhase_x_LAnkleAnglesPhase_x_crp.line;
            end   
    % compute mean absolute relative phase (MARP)  
    L_KH_MARP = mean(L_KH_CRP_stk);
    L_AK_MARP = mean(L_AK_CRP_stk);
    batchdisp(subjects{s},'calculating Ankle-Knee and Knee-Hip Mean Absolute Relative Phase')
    
    % Compute deviation phase (DP)  
    L_KH_DP = std(L_KH_CRP_stk);
    L_AK_DP = std(L_AK_CRP_stk);
    batchdisp(subjects{s},'calculating Ankle-Knee and Knee-Hip Deviation Phase')
    
            for i = 1:length(fl)  
               data = zload(fl{i});
               data.L_KH_MARP.line = L_KH_MARP;
               data.L_AK_MARP.line = L_AK_MARP;
               batchdisp(fl{i},'adding Ankle-Knee and Knee-Hip MARP values')
               data.L_KH_DP.line = L_KH_DP;
               data.L_AK_DP.line = L_AK_DP;
               batchdisp(fl{i},'adding Ankle-Knee and Knee-Hip DP values')
               zsave(fl{i}, data) 
            end
        end 
end 
