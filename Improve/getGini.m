function Gini = getGini(y)
% �������ָ��
% y��Ӧ�ı�ǩ,Ϊ1��0����Ӧ�����뷴��
    N=length(y);            %��ǩ����
    P_T=sum(y)/N;           %��������
    P_F=1-P_T;              %��������
    Gini=1-P_T*P_T-P_F*P_F;  %����ָ��
end
