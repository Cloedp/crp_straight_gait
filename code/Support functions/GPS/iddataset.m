function [group, norm_data] = iddataset(data)

group = findgpsgroup(data);
norm_data = GetOGLnormGPS(group);
end