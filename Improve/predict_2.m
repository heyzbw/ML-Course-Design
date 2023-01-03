function y_test=predict_2(x_test,mytree,feature_list)
% �Բ����������з���

y_test = {};
row = size(x_test);


for j= 1:row(1)
    % ������˳��һ��һ����
    queue = {mytree};     
    feature_name = 0;
    feature = 0;
    
    while ~isempty(queue)
        node = queue{1};
        % ��ȥ�ڵ�
        queue(1) = [];                 
        tag = 2;
        % ֱ���ҵ�Ҷ�ڵ�
        if string(class(node))~="containers.Map" 
            y_test{j} = node; 
            continue
        else
            % ��ȥnodelable��ǩ����Ӱ���⣩
            keys = node.keys();
            index=find(strcmp(keys,'nodeLabel'));
            if(~isempty(index))
                keys=[keys(1:(index-1)),keys((index+1):end)];
            end
            
            if length(keys)==1 
                % �õ�mytree�ڵ������
                feature_name = char(keys);       
                % mytree���������ڵ�����
                id = ismember(feature_list,feature_name);     
                x = x_test(j,:);
                % �õ��������ݵ���������
                feature = x(id);                
                tag = 1;  
            end
            % tag==2 ��Ҫ�����¸��ڵ�
            if tag==2
                hasKeys=0;
                for i = 1:length(keys)
                    key = keys{i};
                    c = char(feature);
                    if strcmp(key,c)
                        % ���б�ɸýڵ�����Ľڵ�
                        queue=[queue,{node(key)}];                  
                        hasKeys=1;
                    end
                end
                if(~hasKeys)
                    % ѡȡ�ñ�ǩ�����ֵ
                    y_test{j}=node('nodeLabel');                        
                end
            end

            % tag==1 ��Ҫѡ����ϲ������ݵ��������ԣ������Ͳ�����������mytree
            if tag==1
                for i = 1:length(keys)
                    key = keys{i};
                    % ���б�ɸýڵ�����Ľڵ�
                    queue=[queue,{node(key)}];                  
                end
            end
        end
    end
end

end
    

