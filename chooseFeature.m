function bestFeature=chooseFeature(dataset,~)
% 选择信息增益最大的属性特征
% 数据预处理
[N,M]=size(dataset);                %样本数量N
M=M-1;                              %特征个数M
y=strcmp(dataset(:,M+1),dataset(1,M+1)); %标签y(以第一个标签为1)
x=dataset(:,1:M);                   %数据x
gain = (1:M);                       %创建一个数组，用于储存每个特征的信息增益
%bestFeature;                       %最大信息增益的特征
Ent_D=calShannonEnt(y);             %当前信息熵
%计算信息增益
for i=1:M
    % 计算第i种属性的增益
    temp=tabulate(x(:,i));
    value=temp(:,1);            %属性值
    count=cell2mat(temp(:,2));  %不同属性值的各自数量
    Kind_Num=length(value);     %取值数目
    Ent=zeros(Kind_Num,1);
    % i属性下 j取值的信息熵
    for j=1:Kind_Num
        % 在第j种取值下正例的数目
        Ent(j)= calShannonEnt( y(strcmp(x(:,i),value(j))) );
    end
    gain(i)=Ent_D-count'/N*Ent;
end
%随机挑选一个最大值
max_gain=find(gain==max(gain));
choose=randi(length(max_gain));
bestFeature=max_gain(choose);
%%%%============================================
end
