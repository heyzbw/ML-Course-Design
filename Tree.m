clear;
clc;
addpath('Dataset\');

%% 读取数据
load('breastcancer.mat')
% load('tic_tac_toe.mat')
% load('cmc.mat')
dataset_choose = breastcancer;
size_data = size(dataset_choose); 

%% 10次10折交叉验证
k_t = 10;
cross_time = 10;
y_lable = dataset_choose(2:size_data(1),size_data(2));
T_P=zeros(k_t,cross_time);
tic;
for i = 1:cross_time
    %分为训练集和测试集(10折)，
    y_1 = find(strcmp(y_lable(:),y_lable(1)));%与第一个标签相同的为一层次
    y_2 = find(~strcmp(y_lable(:),y_lable(1)));%其余为另一个层次
    y_1_length = length(y_1);
    y_2_length = length(y_2);
    y_1_perNum = floor(y_1_length/k_t);
    y_2_perNum = floor(y_2_length/k_t);
    y_1_randIndex = randperm(y_1_length);
    y_2_randIndex = randperm(y_2_length);
    D_index = zeros(y_1_perNum+y_2_perNum,k_t); %D中存放了10组数据索引
    for j = 1:k_t                          %有数据被丢弃
        D_index(:,j)=[...
            y_1(y_1_randIndex(y_1_perNum*(j-1)+1:y_1_perNum*j));...
            y_2(y_2_randIndex(y_2_perNum*(j-1)+1:y_2_perNum*j))];
    end
    D_index = D_index+1;
    perNum_D = y_1_perNum+y_2_perNum;
    % 训练10折交叉验证
    for k=1:k_t
        % 获取此时的数据集以及测试集
        x_train = dataset_choose(...
            [1; reshape(D_index(:,1:k-1),[],1);...
             reshape(D_index(:,k+1:k_t),[],1)],:) ;     % 这里加上了属性标签行
        x_test = dataset_choose(D_index(:,k),:);  % 选择最后两个当测试集
        % 训练
        size_data = size(x_train);
        dataset = x_train(2:size_data(1),:); % 纯数据集
        labels = x_train(1,1:size_data(2)-1); % 属性标签
        % 生成决策树
        mytree = ID3(dataset,labels);
        % 预测测试集标签并计算精度
        y_test = predict(x_test(:,1:end-1),mytree,labels);
        T_P(i,k) = sum(strcmp(y_test',x_test(:,end)))/perNum_D;
    end
end
toc;

% y_all = predict(breastcancer(2:size_data(1),1:end-1),mytree,labels);
% T_All = sum(strcmp(y_all',breastcancer(2:size_data(1),end)))/(size_data(1)-1);
% auc = plot_roc(y_all',breastcancer(2:size_data(1),end));

%% 结果输出
fprintf('10次10折交叉验证的精度结果为:\n');
for i=1:10
    fprintf('第%d次:%f\n',i,mean(T_P(i,:)));
    fprintf('\t%f\t%f\t%f\t%f\t%f\n',T_P(i,1:5));
    fprintf('\t%f\t%f\t%f\t%f\t%f\n',T_P(i,6:10));
end 
fprintf('平均精度为：%f\n',mean(mean(T_P)));
% [nodeids_,nodevalue_,branchvalue_] = print_tree(mytree);
% tree_plot(nodeids_,nodevalue_,branchvalue_);
