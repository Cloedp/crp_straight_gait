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

        events = struct;
        events.IC  = [1,  mean(b(1:3)),    0];
        events.LR  = [3,  mean(b(3:13)),   0]; 
        events.MS  = [13, mean(b(13:32)),  0];
        events.TS  = [32, mean(b(32:51)),  0];
        events.PSw = [51, mean(b(51:63)),  0];
        events.ISw = [63, mean(b(63:76)),  0];
        events.MSw = [76, mean(b(76:88)),  0];
        events.TSw = [88, mean(b(88:101)), 0];
        data.(chns{c}).event = events;
    end
    zsave(fl{i}, data) 
end

