function y_test=predict(x_test,mytree,feature_list)
% 对测试样本进行分类

y_test = {};
row = size(x_test);


for j= 1:row(1)
    % 按队列顺序一个一个进
    queue = {mytree};     
    feature_name = 0;
    feature = 0;
    
    while ~isempty(queue)
        node = queue{1};
        % 除去节点
        queue(1) = []; 
        tag = 2;
        % 直到找到叶节点
        if string(class(node))~="containers.Map" 
            y_test{j} = node; 
            continue
        elseif length(node.keys)==1 
            % 得到mytree节点的名字
            feature_name = char(node.keys);      
            % mytree该特征所在的坐标
            id = ismember(feature_list,feature_name);    
            x = x_test(j,:);
            % 得到测试数据的特征属性
            feature = x(id);                
            tag = 1;  
        end


        %tag==2 即要走入下个节点
        if tag==2
            if string(class(node))=="containers.Map" 
                hasKeys=0;
                keys = node.keys();
                for i = 1:length(keys)
                    key = keys{i};
                    c = char(feature);
                    if strcmp(key,c)
                        % 队列变成该节点下面的节点
                        queue=[queue,{node(key)}];                  
                        hasKeys=1;
                    end
                end
                if(~hasKeys)
                    key = keys{randi(length(keys))};
                    % 队列变成该节点下面的节点
                    queue=[queue,{node(key)}];                  
                end
            end
        end

        %tag==1 即要选则符合测试数据的特征属性，这样就不用历遍整个mytree
        if tag==1
            if string(class(node))=="containers.Map" 
                keys = node.keys();
                for i = 1:length(keys)
                    key = keys{i};
                    queue=[queue,{node(key)}]; 
                end
            end
        end
    end
    if length(y_test)<j
        test=1;
    end
end

end
    

