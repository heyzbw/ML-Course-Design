function myTree = ID3(dataset,labels)
% ID3算法构建决策树
% 输入参数：
% dataset：数据集
% labels：属性标签
% 输出参数：
% tree：构建的决策树
size_data = size(dataset);
classList = dataset(:,size_data(2));   %得到标签

% 全为同一类，熵为0
if length(unique(classList))==1
    myTree =  char(classList(1));
    return 
end

% 去除完全相同的属性，避免产生没有分类结果的节点
choose=ones(1,size_data(2));
for i=1:(size_data(2)-1)
    featValues = dataset(:,i);
    uniqueVals = unique(featValues);
    if(length(uniqueVals)<=1)
        choose(i)=0;
    end
end
labels=labels((choose(1:size_data(2)-1))==1);
dataset=dataset(:,choose==1);

size_data = size(dataset);
classList = dataset(:,size_data(2));

% 属性集为空，用找最多数
if size_data(2) == 1
    temp=tabulate(classList);
    value=temp(:,1);            % 属性值
    count=cell2mat(temp(:,2));  % 不同属性值的各自数量
    index=find(max(count)==count);
    choose=index(randi(length(index)));
    myTree =  char(value(choose));
    return
end

bestFeature = chooseFeature(dataset);           % 找到信息增益最大的特征
bestFeatureLabel = char(labels(bestFeature));     % 得到信息增益最大的特征的名字，即为接下来要删除的特征
myTree = containers.Map;
leaf = containers.Map;
featValues = dataset(:,bestFeature);
uniqueVals = unique(featValues);

labels=[labels(1:bestFeature-1) labels(bestFeature+1:length(labels))]; % 删除该特征

% 形成递归，一个特征的按每个类别再往下分
for i=1:length(uniqueVals)
    subLabels = labels(:)';                            
    value = char(uniqueVals(i));
    subdata = splitDataset(dataset,bestFeature,value);    % 取出该特征值为value的所有样本,并去除该属性
    leaf(value) = ID3(subdata,subLabels);
    myTree(char(bestFeatureLabel)) = leaf;
end

end