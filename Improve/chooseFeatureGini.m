function bestFeature=chooseFeatureGini(dataset,~)
% ѡ�����ָ����С����������

 %����Ԥ����
[N,M]=size(dataset);                %��������N
M=M-1;                              %��������M
y=strcmp(dataset(:,M+1),dataset(1,M+1)); %��ǩy(�Ե�һ����ǩΪ1)
x=dataset(:,1:M);                   %����x
Gini_index = zeros(1,M);            %����һ�����飬���ڴ���ÿ����������Ϣ����
%bestFeature;                       %������ϵ��������

%�������ָ��
for i=1:M
    % �����i�����ԵĻ���ָ��
    temp=tabulate(x(:,i));
    value=temp(:,1);            %����ֵ
    count=cell2mat(temp(:,2));  %��ͬ����ֵ�ĸ�������
    Kind_Num=length(value);     %ȡֵ��Ŀ
    Gini=zeros(Kind_Num,1);
    % i������ jȡֵ�Ļ���ָ��
    for j=1:Kind_Num
        % �ڵ�j��ȡֵ����������Ŀ
        Gini(j)= getGini( y(strcmp(x(:,i),value(j))) );
    end
    Gini_index(i)=count'/N*Gini;
end
%�����ѡһ����Сֵ
min_GiniIndex=find(Gini_index==min(Gini_index));
choose=randi(length(min_GiniIndex));
bestFeature=min_GiniIndex(choose);
end