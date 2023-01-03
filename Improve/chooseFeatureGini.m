function bestFeature=chooseFeatureGini(dataset,~)
% 选择基尼指数最小的属性特征

 %数据预处理
[N,M]=size(dataset);                %样本数量N
M=M-1;                              %特征个数M
y=strcmp(dataset(:,M+1),dataset(1,M+1)); %标签y(以第一个标签为1)
x=dataset(:,1:M);                   %数据x
Gini_index = zeros(1,M);            %创建一个数组，用于储存每个特征的信息增益
%bestFeature;                       %最大基尼系数的特征

%计算基尼指数
for i=1:M
    % 计算第i种属性的基尼指数
    temp=tabulate(x(:,i));
    value=temp(:,1);            %属性值
    count=cell2mat(temp(:,2));  %不同属性值的各自数量
    Kind_Num=length(value);     %取值数目
    Gini=zeros(Kind_Num,1);
    % i属性下 j取值的基尼指数
    for j=1:Kind_Num
        % 在第j种取值下正例的数目
        Gini(j)= getGini( y(strcmp(x(:,i),value(j))) );
    end
    Gini_index(i)=count'/N*Gini;
end
%随机挑选一个最小值
min_GiniIndex=find(Gini_index==min(Gini_index));
choose=randi(length(min_GiniIndex));
bestFeature=min_GiniIndex(choose);
end