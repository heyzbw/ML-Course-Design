function [myTree] = ID3_2(dataset,labels)
% ID3�㷨����������
% ���������
% dataset�����ݼ�
% labels�����Ա�ǩ
% ���������
% tree�������ľ�����
size_data = size(dataset);
classList = dataset(:,size_data(2));   %�õ���ǩ

%ȫΪͬһ�࣬��Ϊ0
if length(unique(classList))==1
    myTree =  char(classList(1));
    return 
end

%ȥ����ȫ��ͬ�����ԣ��������û�з������Ľڵ�
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
% ���Լ�Ϊ�գ��������
temp=tabulate(classList);
value=temp(:,1);            % ����ֵ
count=cell2mat(temp(:,2));  % ��ͬ����ֵ�ĸ�������
index=find(max(count)==count);
choose=index(randi(length(index)));
nodeLable =  char(value(choose));
if size_data(2) == 1
    myTree =  nodeLable;
    return
end

% �ҵ�����ָ����С������
bestFeature = chooseFeatureGini(dataset);   
% �õ�����ָ����С�����������֣���Ϊ������Ҫɾ��������
bestFeatureLabel = char(labels(bestFeature));     
myTree = containers.Map;
leaf = containers.Map;
featValues = dataset(:,bestFeature);
uniqueVals = unique(featValues);

labels=[labels(1:bestFeature-1) labels(bestFeature+1:length(labels))]; %ɾ��������

% �γɵݹ飬һ�������İ�ÿ����������·�
for i=1:length(uniqueVals)
    subLabels = labels(:)';                            
    value = char(uniqueVals(i));
    subdata = splitDataset(dataset,bestFeature,value);    %ȡ��������ֵΪvalue����������,��ȥ��������
    leaf(value) = ID3_2(subdata,subLabels);
end
leaf('nodeLabel')= nodeLable;
myTree(char(bestFeatureLabel)) = leaf;
end