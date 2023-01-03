function shannonEnt = calShannonEnt(y)
% 计算信息熵
% y对应的标签,为1或0，对应正例与反例
    N=length(y);            %标签长度
    P_T=sum(y)/N;           %正例概率
    P_F=(N-sum(y))/N;         %反例概率
    if(P_T==0||P_F==0)
        % 使得p*log2p为0
        shannonEnt = 0; 
        return
    end
    shannonEnt=-(P_T*log2(P_T)+P_F*log2(P_F));  %信息熵
end
