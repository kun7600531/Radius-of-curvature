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
    j = mod(i, m)+1;                          % �ڶ�����
    k = mod(i+1, m)+1;                        % ��������
    a1 = -data(j,:)+data(i,:);                % ��jָ���i������
    a2 = -data(j,:)+data(k,:);                % ��jָ���k������
    flag = cross(-[a1,0],[a2,0])*direc;       % �ж��Ƿ�Ϊ�ڹ�
    if flag(3)>0
        [dA,dL,ap] = myarc(data([i,j],:),data([j,k],:),r,theta);
        if ~isempty(ap)
        A = A + dA;
        L = L + dL;
%         l1 = norm(a1);
%         l2 = norm(a2);
%         alpha = acos(a1*a2'/(l1*l2));       % �����н�
%         theta0 = pi-2*theta-alpha;
%         h = r*sin(0.5*(alpha+theta0));      % Բ�����ĵ��߶�ij�ľ���
%         l = h/tan(alpha*0.5)-r*cos(0.5*(alpha+theta0));     % Բ�����㵽��j�ľ���
%         St = l*h-0.5*theta0*r^2;
%         A = A - St;                         % �������
%         L = L - 2*l + r*theta0;             % �����ܳ�
        if plotflag == 1
%             a10 = a1/norm(a1);
%             a20 = a2/norm(a2);
%             rc = (a10+a20)/norm(a10+a20)*h/sin(0.5*alpha);  % j��ָ��Բ��
%             ah = rc-h/tan(alpha*0.5)*a1/norm(a1);           % ��ֱ�߶�����
%             thetap = -linspace(0,theta0,10)'*direc;         % ��10�����ݵ�
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
