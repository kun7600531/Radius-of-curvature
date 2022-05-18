function [A,L,ap,pcir,prop,pjia] = myarc(a,b,r,theta)
A=[];                    % 圆弧导致的面积增加
L=[];                    % 圆弧长度
ap=[];                   % 储存圆弧
pcir=[];                 % 储存圆心
prop=[];                 % 储存圆弧是靠近向量a的起点或终点状态
pjia=[];  %#ok           % 储存两条线段的交点
% 返回线段a和线段b之间可能的半径r下的圆弧
b1=(a(2,2)-a(1,2))*a(1,1)+(a(1,1)-a(2,1))*a(1,2);  % (y2-y1)*x1+(x1-x2)*y1
b2=(b(2,2)-b(1,2))*b(1,1)+(b(1,1)-b(2,1))*b(1,2);  % (y4-y3)*x3+(x3-x4)*y3
D=(a(2,1)-a(1,1))*(b(2,2)-b(1,2))+(b(1,1)-b(2,1))*(a(2,2)-a(1,2));  % (x2-x1)(y4-y3)-(x4-x3)(y2-y1)
D1=b2*(a(2,1)-a(1,1))+b1*(b(1,1)-b(2,1));
D2=b2*(a(2,2)-a(1,2))-b1*(b(2,2)-b(1,2));
pc=[D1,D2]/D;            % 交点
pjia=pc;
%%% 重建ijk点
i=1;
j=2;
k=3;
data = zeros(3,2);
data(2,:) = pc;                  % 线段交点
disa = sqrt(sum((a-pc).^2,2));   % 线段a两点到pc点的距离
[~,ind1] = max(disa);            % 返回距离最远点的索引
data(1,:) = a(ind1,:);
disb = sqrt(sum((b-pc).^2,2));   % 线段b两点到pc点的距离
[~,ind2] = max(disb);            % 返回距离最远点的索引
data(3,:) = b(ind2,:);
%%% 计算圆弧交点
a1 = -data(j,:)+data(i,:);       % 点j指向点i的向量
a2 = -data(j,:)+data(k,:);       % 点j指向点k的向量

l1 = norm(a1);
l2 = norm(a2);
alpha = acos(a1*a2'/(l1*l2));    % 向量夹角
theta0 = pi-2*theta-alpha;
if theta0<0, return; end         % 无法构造圆弧
h = r*sin(0.5*(alpha+theta0));   % 圆弧中心到线段ij的距离
l = h/tan(alpha*0.5)-r*cos(0.5*(alpha+theta0));  % 圆弧交点到点j的距离
if length(l)>1
    test = 1;  %#ok
end
% 判断交点是否在线段上
if (disa(1)-l)*(disa(2)-l)>0
    return;
end
if (disb(1)-l)*(disb(2)-l)>0
    return;
end
St = l*h-0.5*theta0*r^2;  %#ok
A = 0.5*theta0*r^2 - 0.5*r^2*sin(theta0);        % 面积增加
L = r*theta0;                    % 长度增加
% A = - St;                      % 面积改变
% L = - 2*l + r*theta0;          % 周长改变
a10 = a1/norm(a1);
a20 = a2/norm(a2);
rc = (a10+a20)/norm(a10+a20)*h/sin(0.5*alpha);   % j点指向圆心
pcir = rc + data(j,:);           % 圆心坐标

% 返回圆弧线点
direc = cross([a10,0],[a20,0]);
direc = sign(direc(3));
thetap = linspace(0,theta0,10)'*direc;            % 画10个数据点
ap = zeros(10,2);
for ii = 1:10
    T = [cos(thetap(ii)),sin(thetap(ii));-sin(thetap(ii)),cos(thetap(ii))];
    ap(ii,:) = (T*(a10*l-rc)')'+rc+data(j,:);
end

% 返回数据集
prop = 3 - [ind1, ind2];
prop = [prop, abs(disa(1)-l)/abs(disa(2)-disa(1)), abs(disb(1)-l)/abs(disb(2)-disb(1))];% 交点到两条线段第一点的相对距离

% ba1 = a(1,:)-b(1,:);
% a0 = (a(2,:)-a(1,:))/norm(a(2,:)-a(1,:));
% b0 = (b(2,:)-b(1,:))/norm(b(2,:)-b(1,:));
% theta0 = acos(a0*b0');
% theta1 = acos(ba1*b0'/norm(ba1));
% h = norm(ba1)*sin(theta1);
% ac = h/sin(theta0)*(-a0);
% pc = a(1,:)+ac;  % 获得交点的坐标


