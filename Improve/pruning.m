function [correct,tree_pruning] = pruning(x_V,tree,feature_list)
% 剪枝
% correct：返回的数据集的预测值正确程度数组，1为预测正确
% tree_pruning：剪枝后的数组
% x_V：训练集
% tree：剪枝前的树
% feature_list：训练集的标签
if(string(class(tree))~="containers.Map")
    %达到叶节点，计算标签与当前数据的真实标签的异同
    %将结果保存在correct数组中
    correct=strcmp(x_V(:,end),tree)';
    tree_pruning=tree;%返回原本的节点
    return;
else
    size_data = size(x_V);
    labels=feature_list;            %数据的属性
    Feature=char(tree.keys);        %当前节点的属性
    FeatureIndex=strcmp(labels,Feature);%节点属性在所有属性中的索引
    FeatureValue=x_V(:,FeatureIndex);   %所有属性
    x_V=x_V(:,logical([~FeatureIndex,1])); %删除该特征
    feature_list=feature_list(~FeatureIndex);
    theTree = containers.Map;%新的节点以及边
    theLeaf = containers.Map;
    leaf=tree(Feature);%原本的叶子节点
    keys=leaf.keys;    %获取属性的取值
    %除去nodelable标签（不影响检测）
    index=find(strcmp(keys,'nodeLabel'));
    if(~isempty(index))
        keys=[keys(1:(index-1)),keys((index+1):end)];
    end

    correct=[];  %数据将包含目前数据预测的正确与否，为0-1数组
    for i=1:length(keys)
        value=keys{i};
        x_V_value=x_V(strcmp(FeatureValue,value),:); %删除拥有特征的数量
        if(~isempty(x_V_value))
            %数据集里有该取值，计算预测结果正确与否
            [correct_per,theLeaf(value)] = pruning(x_V_value,leaf(value),feature_list);
            correct=[correct,correct_per];
        else
            %数据集里没有该取值，保留原本的节点
            theLeaf(value)=leaf(value);
        end
    end
    theLeaf('nodeLabel')= char(leaf('nodeLabel'));%获取之前的节点
    theTree(Feature) = theLeaf;                     
    
    acc = sum(correct)/length(correct);%原本的精度 
    acc_pruning = strcmp(x_V(:,end),leaf('nodeLabel'))/size_data(1);%不划分的精度 
    if(acc<=acc_pruning)
        %假如不划分的精度更高，那么选取原本训练时最多的标签
        tree_pruning= char(leaf('nodeLabel'));
    else
        %保留树
        tree_pruning=theTree;
    end
end

end
