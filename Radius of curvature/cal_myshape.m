function line_prop = cal_myshape(r,theta,data)
global direc_flag1 direc_flag2
% 计算当前半径和角度下所有可能的圆弧，储存在Line_prop中
m = size(data,1);
% 属性初始化
for i = 1:m
    % 靠近线第一/二点的圆弧长度,距离第一点的长度，另一条线段的编号，另一条线段的靠近点情况,面积增加，长度增加
    % 圆心节点坐标，圆弧对应两条线的交点坐标
    line_prop(i).pos = [0,0,0,0,0,0,0,0,0,0;0,1,0,0,0,0,0,0,0,0];  %#ok
    line_prop(i).arc = zeros(10,4);  %#ok       % 从线段第一/二点起始的圆弧
end

for i = 1:m-1
    for i2 = i+1:m
        if i==20
            test = 1;  %#ok
        end
    j1 = i+1;                                   % 线段1的j点
    j2 = i2;                                    % 线段2的j点
    k = mod(i2, m)+1;                           % 线段2的k点
    a1 = -data(j1,:)+data(i,:);                 % 点j指向点i的向量
    a2 = -data(j2,:)+data(k,:);                 % 点j指向点k的向量
    flag = cross(-[a1,0],[a2,0])*direc_flag1;   % 判断是否为内拐   相邻边界
    if j2>j1, flag(3)=1; end                    % 非临近点时无法判断是否内拐，一律认为可行
    dataa = data([i,j1],:);
    datab = data([j2,k],:);
    if flag(3)>0
        [dA,dL,ap,pcir,prop,pjia] = myarc(dataa,datab,r,theta);  % 计算圆弧交点
        if ~isempty(ap)                         % 判断是否存在可用圆弧
            %----------------- 判断圆弧是否过边界点 ---------------------------------------
            bflag = 1;
            rp1 = (ap(1,:)-pcir)/norm(ap(1,:)-pcir);             % 圆弧边界1
            rp2 = (ap(end,:)-pcir)/norm(ap(end,:)-pcir);         % 圆弧边界2
            rtheta = acos(rp1*rp2');                             % 圆弧角度
            for i3 = 1:m
                if i3==i||i3==i2, continue; end
                lp = data(i3,:) + (data(mod(i3,m)+1,:)-data(i3,:)).*linspace(0,1,20)'-pcir; % 生成圆弧中心到线段上的采样点的向量
                lp_theta1 = acos((lp*rp1')./sqrt(sum(lp.^2,2))); % 与圆弧边界1的夹角
                lp_theta2 = acos((lp*rp2')./sqrt(sum(lp.^2,2))); % 与圆弧边界2的夹角
                ind = find(lp_theta1<=rtheta&lp_theta2<=rtheta); % 寻找在圆弧边界内的点
                if ~isempty(ind)                                 % 当存在时
                dislp = sqrt(sum((lp(ind,:)).^2,2))-r;           % 距离与半径相减
                if min(dislp)<0                                  % 过边界时
                    bflag = 0;
                    break;
                end
                end
            end
            if bflag == 0, continue; end                         % 如果过边界点，舍去，查找下一条边
            %-------------------- 判断圆弧是在边界外 --------------------------------------
            a2c = -data(j1,:)+pcir;                              % 点j指向点k的向量?
            cflag = cross(-[a1,0],[a2c,0])*direc_flag1*direc_flag2;   % 判断是否为内拐 【不相邻边界】
            if cflag(3)<=0, continue; end                        % 在边界外，不储存此次结果
            %---------- 根据圆弧与直线的交点判断与之前的圆弧是否存在交叉 ------------------
            jx1_flag = (line_prop(i).pos(3-prop(1),2)-prop(3))*(-1)^prop(1)>0;           % 大于0时存在交叉
            jx2_flag = (line_prop(i2).pos(3-prop(2),2)-prop(4))*(-1)^prop(2)>0;          % 大于0时存在交叉
            if jx1_flag||jx2_flag
                if jx1_flag
                    line2=line_prop(i).pos(3-prop(1),3:4);       % 之前线段圆弧所在的另一条边编号及其靠近点
                    line_prop(line2(1)).pos(line2(2),:)=[0,line2(2)-1,0,0,0,0,0,0,0,0];  % 清除另一条边的结果
                    line_prop(i).pos(3-prop(1),:)=[0,2-prop(1),0,0,0,0,0,0,0,0];         % 清除当前这条边的结果
                end
                if jx2_flag
                    line2=line_prop(i3).pos(3-prop(2),3:4);      % 之前线段圆弧所在的另一条边编号及其靠近点
                    line_prop(line2(1)).pos(line2(2),:)=[0,line2(2)-1,0,0,0,0,0,0,0,0];  % 清除另一条边的结果
                    line_prop(i2).pos(3-prop(2),:)=[0,2-prop(2),0,0,0,0,0,0,0,0];        % 清除当前这条边的结果
                end
                continue;                                        % 不储存这次计算结果
            end
            %-------------------判断圆弧与之前圆弧的关系-----------------------------------
            if line_prop(i).pos(prop(1),1)<dL&&line_prop(i2).pos(prop(2),1)<dL
                %  当目前圆弧长度大于之前生成的圆弧长度时
                line_old=line_prop(i).pos(prop(1),3);            % 获取小圆弧接壤的边
                if line_old>0                                    % 获取小圆弧接壤的边存在时
                cp_old=line_prop(i).pos(prop(1),4);              % 获取小圆弧接壤的靠近点
                line_prop(line_old).pos(cp_old,:)=[0,cp_old-1,0,0,0,0,0,0,0,0];          % 清除另一条边的结果
                end
                line_prop(i).pos(prop(1),:)=[dL,prop(3),i2,prop(2),dA,dL,pcir,pjia];     % 使用当前圆弧
                line_prop(i2).pos(prop(2),:)=[dL,prop(4),i,prop(1),dA,dL,pcir,pjia];
                line_prop(i).arc(:,2*prop(1)-1:2*prop(1))=ap;
                line_prop(i2).arc(:,2*prop(2)-1:2*prop(2))=ap(end:-1:1,:);
                bflag = 1;   %#ok
            end
        end
    end
    end
end
% 
% for i = 1:m
%     j = mod(i, m)+1;              % 第二个点
%     k = mod(i+1, m)+1;            % 第三个点
%     a1 = -data(j,:)+data(i,:);    % 点j指向点i的向量
%     a2 = -data(j,:)+data(k,:);    % 点j指向点k的向量
%     flag = cross(-[a1,0],[a2,0])*direc;    % 判断是否为内拐
%     if flag(3)>0
%         [dA,dL,ap] = myarc(data([i,j],:),data([j,k],:),r,theta,plotflag,direc);  % 计算圆弧交点
%         if ~isempty(ap)
%         A = A + dA;
%         L = L + dL;
%         if plotflag == 1
%             plot(ap(:,1),ap(:,2),'r');
%         end
%         end
%     end
% end
