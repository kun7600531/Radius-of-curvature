function tra = trajectory(line_prop,data)
% Ѱ�ҿ��ܵĹ켣
m = length(data);                    % ���бߵ���Ŀ
lset = 1:m;                          % ��¼δ����켣�ı�

nline = lset(1);                     % ѡ���һ����
nset = nline;                        % ��Ź켣�����ı�
lset(lset==nline)=[];                % δ����켣�ı���ɾ����Ӧ��
K = 1;                               % ��һ���켣
Wflag = 1;
while Wflag
    if line_prop(nline).pos(2,3)~=0
        % ���߿����ڶ��������Բ��ʱ
        nline = line_prop(nline).pos(2,3);    % ���Բ�����ӵ���һ���ߵı��
    else
        nline = mod(nline,m)+1;      % ѡ����һ����
    end
    nset = [nset,nline];  %#ok       % ��Ź켣�����ı�
    lset(lset==nline)=[];            % δ����켣�ı���ɾ����Ӧ��  
    
    for i = 1:K-1
        % �ж���֮ǰ�Ĺ켣�غϳ̶�
        nset_use = zeros(1,m);% 
        nset_use(tra(i).nset) = 1;   % ��ʹ�õı�
        if sum(nset_use(nset)==1)>2  % ���ڳ��������߹���
            if isempty(lset)
                Wflag = 0;break;
            else
                nline = lset(1);
                nset = nline;        % ��Ź켣�����ı�
                lset(lset==nline)=[];
            end
        end
    end
    
    if length(unique(nset))<length(nset)       % �ߵ���β�Ѿ�����ʱ
        dA = 0;
        dLC = 0;                     % Բ������
        dLL = 0;                     % �߶γ���
        ind1 = find(nset==nset(end),1);        % �����һ���ߣ�����һ���߿�ʼ
        tra(K).route = [];  %#ok     % ����켣
        tra(K).point = [];  %#ok     % �����
        tra(K).nset = nset(ind1+1:end); %#ok   % �������ڱ�
        tra(K).cpoint = [];  %#ok    % ����Բ�����ڵ�
        tra(K).jpoint = [];  %#ok    % ���������߶εĽ���
        for i= ind1:length(nset)-1
            ind = nset(i);
            if line_prop(ind).pos(2,3)~=0
                %���Բ����
                arc = line_prop(ind).arc(:,3:4);
                tra(K).route = [tra(K).route;arc];                               % ��¼·��
                tra(K).point = [tra(K).point;arc(1,:);arc(end,:)];               % �ؼ���
                tra(K).cpoint = [tra(K).cpoint;line_prop(ind).pos(2,7:8)];
                tra(K).jpoint = [tra(K).jpoint;line_prop(ind).pos(2,9:10)];
                dA = dA + line_prop(ind).pos(2,5);
                dLC = dLC + line_prop(ind).pos(2,6);                             % ����Բ������
            else
                % ���ֱ�߶�
                tra(K).route = [tra(K).route;data(mod(ind,m)+1,:)];
                tra(K).point = [tra(K).point;data(mod(ind,m)+1,:)];
                if size(tra(K).point,1)>1
                    dLL = dLL + norm(tra(K).point(end,:)-tra(K).point(end-1,:)); % �����߶γ���
                end
            end
        end
        tra(K).S = polyarea([tra(K).point(:,1);tra(K).point(1,1)],[tra(K).point(:,2);tra(K).point(1,2)])+dA; %#ok  % �����������
        tra(K).LC = dLC;  %#ok      % ����Բ������
        tra(K).LL = dLL + norm(tra(K).point(end,:)-tra(1).point(end-1,:));  %#ok
        K = K + 1;
        
        % �����б߶��Ѿ�����ʱ
        if isempty(lset)
            break;
        else
            nline = lset(1);
            nset = nline;           % ��Ź켣�����ı�
            lset(lset==nline)=[];
        end
    end
end