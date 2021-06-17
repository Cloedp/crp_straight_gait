function bmech_computeMARP_DP(fld)
% This function batch compute the Mean Absolute Relative Phase (MARP)

%   fld    ...  folder to batch compute the MARP

cd(fld)

[~,subjects] = extract_filestruct(fld);

for s = 1:length(subjects)
    fl = engine('fld',fld,'extension','zoo', 'search path', subjects{s});
    data = zload(fl);
        if fl < 2
        disp('insufficient trials for CRP analysis, setting trial as outlier with 999 code')
        else    
        % compute mean absolute relative phase (MARP)
            for i = length(fl)
            L_HK_CRP_stk = ones(length(fl), 101); 
            L_AK_CRP_stk = ones(length(fl), 101);
            
            L_KH_CRP_stk(i,:) = data.LHipAnglesPhase_x_LKneeAnglesPhase_x_crp;
            L_AK_CRP_stk(i,:) = data.LKneeAnglesPhase_x_LAnkleAnglesPhase_x_crp;
            
            L_KH_MARP = mean(L_KH_CRP_stk);
            L_AK_MARP = mean(L_AK_CRP_stk);
        % Compute deviation phase (DP)  
            L_KH_DP = std(L_KH_CRP_stk);
            L_AK_DP = std(L_AK_CRP_stk);
            
            %%data. AJOUTER CHANNEL
            end
        end
        zsave(fl{i}, data)
end

