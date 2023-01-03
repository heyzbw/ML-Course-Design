function [nodeids_,nodevalue_,branchvalue_] = print_tree(tree)
% 层序遍历决策树
% 返回nodeids（节点关系），nodevalue（节点信息），branchvalue（枝干信息）
nodeids(1) = 0;
nodeid = 0;
nodevalue={};
branchvalue={};

% 形成队列，一个一个进去
queue = {tree} ;      
while ~isempty(queue)
    node = queue{1};
    queue(1) = [];                  %在队列中除去该节点
    if string(class(node))~="containers.Map" %叶节点的话（即走到底了）
        nodeid = nodeid+1;
        nodevalue = [nodevalue,{node}];
    elseif string(class(node))=="containers.Map" 
         %节点的话
        if length(node.keys)==1
            nodevalue = [nodevalue,node.keys];      %储存该节点名
            node_info = node(char(node.keys));      %储存该节点下的属性对应的map
            nodeid = nodeid+1;
            branchvalue = [branchvalue,node_info.keys];   %每个节点下的属性
            for i=1:length(node_info.keys)
                nodeids = [nodeids,nodeid];
            end
        end
        
        keys = node.keys();
        for i = 1:length(keys)
            key = keys{i};
            queue=[queue,{node(key)}];                  %队列变成该节点下面的节点
        end
    end
end
nodeids_=nodeids;
nodevalue_=nodevalue;
branchvalue_ = branchvalue;
end