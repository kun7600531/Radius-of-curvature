function [A,L] = cal_myshape_v0(r,theta,data,S0,L0,direc,plotflag)
if plotflag == 1
    figure
    plot([data(:,1);data(1,1)],[data(:,2);data(1,2)],'b');
    hold on
end

m = size(data,1);
A = S0;
L = L0;
for i = 1:m
    j = mod(i, m)+1;                          % 第二个点
    k = mod(i+1, m)+1;                        % 第三个点
    a1 = -data(j,:)+data(i,:);                % 点j指向点i的向量
    a2 = -data(j,:)+data(k,:);                % 点j指向点k的向量
    flag = cross(-[a1,0],[a2,0])*direc;       % 判断是否为内拐
    if flag(3)>0
        [dA,dL,ap] = myarc(data([i,j],:),data([j,k],:),r,theta);
        if ~isempty(ap)
        A = A + dA;
        L = L + dL;
%         l1 = norm(a1);
%         l2 = norm(a2);
%         alpha = acos(a1*a2'/(l1*l2));       % 向量夹角
%         theta0 = pi-2*theta-alpha;
%         h = r*sin(0.5*(alpha+theta0));      % 圆弧中心到线段ij的距离
%         l = h/tan(alpha*0.5)-r*cos(0.5*(alpha+theta0));     % 圆弧交点到点j的距离
%         St = l*h-0.5*theta0*r^2;
%         A = A - St;                         % 更新面积
%         L = L - 2*l + r*theta0;             % 更新周长
        if plotflag == 1
%             a10 = a1/norm(a1);
%             a20 = a2/norm(a2);
%             rc = (a10+a20)/norm(a10+a20)*h/sin(0.5*alpha);  % j点指向圆心
%             ah = rc-h/tan(alpha*0.5)*a1/norm(a1);           % 垂直线段向量
%             thetap = -linspace(0,theta0,10)'*direc;         % 画10个数据点
%             ap = zeros(10,2);
%             for ii = 1:10
%                 T = [cos(thetap(ii)),sin(thetap(ii));-sin(thetap(ii)),cos(thetap(ii))];
%                 ap(ii,:) = (T*(a10*l-rc)')'+rc+data(j,:);
%             end
            plot(ap(:,1),ap(:,2),'r');
        end
        end
    end
end
