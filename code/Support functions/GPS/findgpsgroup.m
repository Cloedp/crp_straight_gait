function group = findgpsgroup(data)

if ~isfield(data.zoosystem.Anthro,'Age')
    error('missing age information for subject')
else
    age = data.zoosystem.Anthro.Age;
end

if ~isfield(data.zoosystem.Anthro,'Sex')
    error('missing sex information for subject')
else
    sex = data.zoosystem.Anthro.Sex;
end


if age > 18 && sex =='F'
    group = 'Adult F';
    
elseif age >18 && sex =='M'
    group = 'Adult M';
    
elseif age >=13 && sex =='F'
    group = '13-16 G';
    
elseif age >=13 && sex =='M'
    group = '13-16 B';
    
elseif age >=10 && sex =='F'
    group = '10-12 G';
    
elseif age >=10 && sex =='M'
    group = '10-12 B';
    
elseif age >=8
    group = '8-9';
    
elseif age>=5
    group = '5-7';
    
elseif age>=3
    group = '3-4';
else
    %     error('group not identified')
    group = '13-16 M'; % for testing
    disp('using random group for testing')
end
