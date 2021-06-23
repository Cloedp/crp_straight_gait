function bmech_create_gait_events(fld)
% This function creates gait events of the MARP & DP channels

cd(fld)
fl = engine('fld',fld,'extension','zoo');

for i = 1:length(fl)  
    data = zload(fl{i});
    
    chns = {'LHipAngles_x','LKneeAngles_x','LAnkleAngles_x',...
         'LHipAnglesPhase_x','LKneeAnglesPhase_x',...                       
         'LAnkleAnglesPhase_x','LHipAnglesPhase_x_LKneeAnglesPhase_x_crp',...
         'LKneeAnglesPhase_x_LAnkleAnglesPhase_x_crp','L_KH_MARP',...
         'L_AK_MARP','L_KH_DP','L_AK_DP'};
     
    batchdisp(fl{i},'adding gait events');
    
    for c = 1:length(chns)
        b = data.(chns{c}).line;
%CHANGER FRAMES
        events = struct;
        events.IC  = [1,  mean(b(1:2)),    0];
        events.LR  = [2,  mean(b(2:12)),   0]; 
        events.MS  = [12, mean(b(12:31)),  0];
        events.TS  = [31, mean(b(31:50)),  0];
        events.PSw = [50, mean(b(50:62)),  0];
        events.ISw = [62, mean(b(62:75)),  0];
        events.MSw = [75, mean(b(75:87)),  0];
        events.TSw = [87, mean(b(87:100)), 0];
        data.(chns{c}).event = events;
    end
    zsave(fl{i}, data) 
end

