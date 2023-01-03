function [correct,tree_pruning] = pruning(x_V,tree,feature_list)
% ��֦
% correct�����ص����ݼ���Ԥ��ֵ��ȷ�̶����飬1ΪԤ����ȷ
% tree_pruning����֦�������
% x_V��ѵ����
% tree����֦ǰ����
% feature_list��ѵ�����ı�ǩ
if(string(class(tree))~="containers.Map")
    %�ﵽҶ�ڵ㣬�����ǩ�뵱ǰ���ݵ���ʵ��ǩ����ͬ
    %�����������correct������
    correct=strcmp(x_V(:,end),tree)';
    tree_pruning=tree;%����ԭ���Ľڵ�
    return;
else
    size_data = size(x_V);
    labels=feature_list;            %���ݵ�����
    Feature=char(tree.keys);        %��ǰ�ڵ������
    FeatureIndex=strcmp(labels,Feature);%�ڵ����������������е�����
    FeatureValue=x_V(:,FeatureIndex);   %��������
    x_V=x_V(:,logical([~FeatureIndex,1])); %ɾ��������
    feature_list=feature_list(~FeatureIndex);
    theTree = containers.Map;%�µĽڵ��Լ���
    theLeaf = containers.Map;
    leaf=tree(Feature);%ԭ����Ҷ�ӽڵ�
    keys=leaf.keys;    %��ȡ���Ե�ȡֵ
    %��ȥnodelable��ǩ����Ӱ���⣩
    index=find(strcmp(keys,'nodeLabel'));
    if(~isempty(index))
        keys=[keys(1:(index-1)),keys((index+1):end)];
    end

    correct=[];  %���ݽ�����Ŀǰ����Ԥ�����ȷ���Ϊ0-1����
    for i=1:length(keys)
        value=keys{i};
        x_V_value=x_V(strcmp(FeatureValue,value),:); %ɾ��ӵ������������
        if(~isempty(x_V_value))
            %���ݼ����и�ȡֵ������Ԥ������ȷ���
            [correct_per,theLeaf(value)] = pruning(x_V_value,leaf(value),feature_list);
            correct=[correct,correct_per];
        else
            %���ݼ���û�и�ȡֵ������ԭ���Ľڵ�
            theLeaf(value)=leaf(value);
        end
    end
    theLeaf('nodeLabel')= char(leaf('nodeLabel'));%��ȡ֮ǰ�Ľڵ�
    theTree(Feature) = theLeaf;                     
    
    acc = sum(correct)/length(correct);%ԭ���ľ��� 
    acc_pruning = strcmp(x_V(:,end),leaf('nodeLabel'))/size_data(1);%�����ֵľ��� 
    if(acc<=acc_pruning)
        %���粻���ֵľ��ȸ��ߣ���ôѡȡԭ��ѵ��ʱ���ı�ǩ
        tree_pruning= char(leaf('nodeLabel'));
    else
        %������
        tree_pruning=theTree;
    end
end

end
