function tra = trajectory(line_prop,data)
% 寻找可能的轨迹
m = length(data);                    % 所有边的数目
lset = 1:m;                          % 记录未进入轨迹的边

nline = lset(1);                     % 选择第一条边
nset = nline;                        % 存放轨迹经过的边
lset(lset==nline)=[];                % 未进入轨迹的边中删掉对应边
K = 1;                               % 第一条轨迹
Wflag = 1;
while Wflag
    if line_prop(nline).pos(2,3)~=0
        % 当边靠近第二个点存在圆弧时
        nline = line_prop(nline).pos(2,3);    % 获得圆弧连接的另一条边的编号
    else
        nline = mod(nline,m)+1;      % 选择下一条边
    end
    nset = [nset,nline];  %#ok       % 存放轨迹经过的边
    lset(lset==nline)=[];            % 未进入轨迹的边中删掉对应边  
    
    for i = 1:K-1
        % 判断与之前的轨迹重合程度
        nset_use = zeros(1,m);% 
        nset_use(tra(i).nset) = 1;   % 已使用的边
        if sum(nset_use(nset)==1)>2  % 存在超过两条边共用
            if isempty(lset)
                Wflag = 0;break;
            else
                nline = lset(1);
                nset = nline;        % 存放轨迹经过的边
                lset(lset==nline)=[];
            end
        end
    end
    
    if length(unique(nset))<length(nset)       % 边的首尾已经相连时
        dA = 0;
        dLC = 0;                     % 圆弧长度
        dLL = 0;                     % 线段长度
        ind1 = find(nset==nset(end),1);        % 从最后一条边，即第一条边开始
        tra(K).route = [];  %#ok     % 储存轨迹
        tra(K).point = [];  %#ok     % 储存点
        tra(K).nset = nset(ind1+1:end); %#ok   % 储存所在边
        tra(K).cpoint = [];  %#ok    % 储存圆心所在点
        tra(K).jpoint = [];  %#ok    % 储存两条线段的交点
        for i= ind1:length(nset)-1
            ind = nset(i);
            if line_prop(ind).pos(2,3)~=0
                %添加圆弧段
                arc = line_prop(ind).arc(:,3:4);
                tra(K).route = [tra(K).route;arc];                               % 记录路径
                tra(K).point = [tra(K).point;arc(1,:);arc(end,:)];               % 关键点
                tra(K).cpoint = [tra(K).cpoint;line_prop(ind).pos(2,7:8)];
                tra(K).jpoint = [tra(K).jpoint;line_prop(ind).pos(2,9:10)];
                dA = dA + line_prop(ind).pos(2,5);
                dLC = dLC + line_prop(ind).pos(2,6);                             % 计算圆弧长度
            else
                % 添加直线段
                tra(K).route = [tra(K).route;data(mod(ind,m)+1,:)];
                tra(K).point = [tra(K).point;data(mod(ind,m)+1,:)];
                if size(tra(K).point,1)>1
                    dLL = dLL + norm(tra(K).point(end,:)-tra(K).point(end-1,:)); % 计算线段长度
                end
            end
        end
        tra(K).S = polyarea([tra(K).point(:,1);tra(K).point(1,1)],[tra(K).point(:,2);tra(K).point(1,2)])+dA; %#ok  % 计算多边形面积
        tra(K).LC = dLC;  %#ok      % 储存圆弧长度
        tra(K).LL = dLL + norm(tra(K).point(end,:)-tra(1).point(end-1,:));  %#ok
        K = K + 1;
        
        % 当所有边都已经遍历时
        if isempty(lset)
            break;
        else
            nline = lset(1);
            nset = nline;           % 存放轨迹经过的边
            lset(lset==nline)=[];
        end
    end
end