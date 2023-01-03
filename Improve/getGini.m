function Gini = getGini(y)
% 计算基尼指数
% y对应的标签,为1或0，对应正例与反例
    N=length(y);            %标签长度
    P_T=sum(y)/N;           %正例概率
    P_F=1-P_T;              %正例概率
    Gini=1-P_T*P_T-P_F*P_F;  %基尼指数
end
