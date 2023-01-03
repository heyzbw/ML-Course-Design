function subDataset = splitDataset(dataset,axis,value)
% 划分数据集，axis为某特征列， 取出该特征值为value的所有样本,并去除该属性

subDataset = {};
data_size = size(dataset);

% 取 该特征列 该属性 对应的数据集
for i=1:data_size(1)
    data = dataset(i,:);
    if string(data(axis)) == string(value)
        subDataset = [subDataset;[data(1:axis-1) data(axis+1:length(data))]];  %取 该特征列 该属性 对应的数据集
    end
end
end