clear;
clc;
addpath('Dataset\');
addpath('Improve\');

%% ��ȡ����
load('breastcancer.mat')
% load('tic_tac_toe.mat')
% load('cmc.mat')
dataset_choose = breastcancer;
size_data = size(dataset_choose); %dataset_choose Ϊ���빤��̨������
p = 'recurrence-events';
n = 'no-recurrence-events';

%% 10��10�۽�����֤
k_t=10;
cross_time=10;
y_lable=dataset_choose(2:size_data(1),size_data(2));
T_P=zeros(k_t,cross_time);
tic;
for i=1:cross_time
    %��Ϊѵ�����Ͳ��Լ�(10��)��
    y_1=find(strcmp(y_lable(:),y_lable(1)));%���һ����ǩ��ͬ��Ϊһ���
    y_2=find(~strcmp(y_lable(:),y_lable(1)));%����Ϊ��һ�����
    y_1_length=length(y_1);
    y_2_length=length(y_2);
    y_1_perNum=floor(y_1_length/k_t);
    y_2_perNum=floor(y_2_length/k_t);
    y_1_randIndex=randperm(y_1_length);
    y_2_randIndex=randperm(y_2_length);
    D_index=zeros(y_1_perNum+y_2_perNum,k_t);
    for j=1:k_t                          %�����ݱ�����
        D_index(:,j)=[...
            y_1(y_1_randIndex(y_1_perNum*(j-1)+1:y_1_perNum*j));...
            y_2(y_2_randIndex(y_2_perNum*(j-1)+1:y_2_perNum*j))];
    end
    D_index=D_index+1;
    perNum_D=y_1_perNum+y_2_perNum;
    for k=1:k_t
        if k~=k_t
            x_train = dataset_choose(...
                [1; reshape(D_index(:,1:k-1),[],1);...
                reshape(D_index(:,k+2:k_t),[],1)],:) ;     % ������������Ա�ǩ��
        else
            x_train = dataset_choose([1; reshape(D_index(:,2:k-1),[],1)],:) ;     % ������������Ա�ǩ��
        end
        x_valid = dataset_choose(D_index(:,k),:);              % ѡ����֤��
        x_test = dataset_choose(D_index(:,mod(k+1,k_t)+1),:);  % ѡ����Լ�
        % ѵ��
        size_data = size(x_train);
        dataset = x_train(2:size_data(1),:); % �����ݼ�
        labels = x_train(1,1:size_data(2)-1); % ���Ա�ǩ
        % ���ɾ�����
        mytree = ID3_2(dataset,labels);
        % ��֦
        [correct,tree_pruning] = pruning(x_valid,mytree,labels);
        % Ԥ����Լ���ǩ�����㾫��
        y_test=predict_2(x_test(:,1:end-1),tree_pruning,labels);
        T_P(i,k)=sum(strcmp(y_test',x_test(:,end)))/perNum_D;
%         auc(i,k) = plot_roc(y_test',x_test(:,end),p,n);
    end
end
toc;
auc_l = mean(mean(auc(i,k)));
% y_all = predict(breastcancer(2:size_data(1),1:end-1),mytree,labels);
% T_All = sum(strcmp(y_all',breastcancer(2:size_data(1),end)))/(size_data(1)-1);
% auc = plot_roc(y_all',breastcancer(2:size_data(1),end));

%% ������
fprintf('10��10�۽�����֤�ľ��Ƚ��Ϊ:\n');
for i=1:10
    fprintf('��%d��:%f\n',i,mean(T_P(i,:)));
    fprintf('\t%f\t%f\t%f\t%f\t%f\n',T_P(i,1:5));
    fprintf('\t%f\t%f\t%f\t%f\t%f\n',T_P(i,6:10));
end 
fprintf('ƽ������Ϊ��%f\n',mean(mean(T_P)));
[nodeids_,nodevalue_,branchvalue_] = print_tree(mytree);
tree_plot(nodeids_,nodevalue_,branchvalue_);
