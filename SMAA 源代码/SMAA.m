% Enter criteria measurements

alternatives = 73;
criteria = 55;
iterations = 10000;

mean = [0,0.086,0.095,0.113;11.7,9.2,15.4,5.5;7.2,10.6,7.5,15.7;16.6,21.2,20.2,12.8;13.7,14.3,15,11.2;18.6,18.3,19.5,31];
standard = [0,0.056,0.044,0.048;2.5,1.86,2.65,2.32;1.45,1.58,1.48,4.44;3.27,5.15,3.78,2.45;1.89,2.93,3.21,3.98;1.79,3.7,2.6,1.68];

% Initialization

rankaccept = zeros(alternatives);%4*4的矩阵
central = zeros(alternatives,criteria);
confidence = zeros(1,alternatives);

% Compute rank acceptability indices + central weight vectors

for i = 1:iterations
    
    % Generate weights
    
    randNum = rand(1,criteria-1);
    q = [0,sort(randNum),1];
    for j = 2:criteria+1
        weights(j-1) = q(j) - q(j-1);
    end
       
    % Generate criteria measuments + compute utility of each alternative
    
    value=[];%对矩阵初始化设置 创建一个空矩阵
    for a = 1:alternatives
        measurements=[]; %对矩阵初始化设置 创建一个空矩阵
        for c = 1:criteria
            measurements(c) = mean(c,a) + standard(c,a)*randn;
        end
        measurements(1) = exp(measurements(1));
        value(a)=utility(measurements,weights);
    end
    
    % Ranking of the alternatives based on their utility scores
    
    [y,rank] = sort(value);%y是排序好的向量，rank 是向量y中对value的索引！
    rank = flipud(rank');%实现矩阵的上下翻转
    rank = rank';%根据效应值，得到每个方案的排序，最大为1,以此类推
        
    % Update counters
    
    for a = 1:alternatives
        rankaccept(rank(a),a) = rankaccept(rank(a),a) + 1;
        if rank(1)==a
            for c = 1:criteria
                central(a,c) = central(a,c) + weights(c);%？
            end
        end
    end
    
end

% Compute SMAA descriptive measures

for a = 1:alternatives
    if rankaccept(a,1)>0
        for c = 1:criteria
            central(a,c) = central(a,c)/rankaccept(a,1);
        end
    end
end
rankaccept = rankaccept/iterations;

% Compute confidence facors

for alt = 1:alternatives
    weights=central(alt,:); % Get central weight factor of alternative alt
    
    for i = 1:iterations
        
        % Generate criteria measuments + compute utility of each alternative
        
        value=[];
        for a = 1:alternatives
            measurements=[];
            for c = 1:criteria
                measurements(c) = mean(c,a) + standard(c,a)*randn;
            end
            measurements(1) = exp(measurements(1));
            value(a)=utility(measurements,weights);
        end
    
        % Ranking of the alternatives based on their utility scores
    
        [y,rank] = sort(value);
        rank = flipud(rank');
        rank = rank';
    
        % Update counter
    
        if rank(1)==alt
            confidence(alt) = confidence(alt) + 1;
        end
    
    end
end
confidence = confidence/iterations;

% Display SMAA descriptive measures

rankaccept
central
confidence


    