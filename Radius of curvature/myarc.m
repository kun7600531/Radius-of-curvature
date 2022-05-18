function [A,L,ap,pcir,prop,pjia] = myarc(a,b,r,theta)
A=[];                    % Բ�����µ��������
L=[];                    % Բ������
ap=[];                   % ����Բ��
pcir=[];                 % ����Բ��
prop=[];                 % ����Բ���ǿ�������a�������յ�״̬
pjia=[];  %#ok           % ���������߶εĽ���
% �����߶�a���߶�b֮����ܵİ뾶r�µ�Բ��
b1=(a(2,2)-a(1,2))*a(1,1)+(a(1,1)-a(2,1))*a(1,2);  % (y2-y1)*x1+(x1-x2)*y1
b2=(b(2,2)-b(1,2))*b(1,1)+(b(1,1)-b(2,1))*b(1,2);  % (y4-y3)*x3+(x3-x4)*y3
D=(a(2,1)-a(1,1))*(b(2,2)-b(1,2))+(b(1,1)-b(2,1))*(a(2,2)-a(1,2));  % (x2-x1)(y4-y3)-(x4-x3)(y2-y1)
D1=b2*(a(2,1)-a(1,1))+b1*(b(1,1)-b(2,1));
D2=b2*(a(2,2)-a(1,2))-b1*(b(2,2)-b(1,2));
pc=[D1,D2]/D;            % ����
pjia=pc;
%%% �ؽ�ijk��
i=1;
j=2;
k=3;
data = zeros(3,2);
data(2,:) = pc;                  % �߶ν���
disa = sqrt(sum((a-pc).^2,2));   % �߶�a���㵽pc��ľ���
[~,ind1] = max(disa);            % ���ؾ�����Զ�������
data(1,:) = a(ind1,:);
disb = sqrt(sum((b-pc).^2,2));   % �߶�b���㵽pc��ľ���
[~,ind2] = max(disb);            % ���ؾ�����Զ�������
data(3,:) = b(ind2,:);
%%% ����Բ������
a1 = -data(j,:)+data(i,:);       % ��jָ���i������
a2 = -data(j,:)+data(k,:);       % ��jָ���k������

l1 = norm(a1);
l2 = norm(a2);
alpha = acos(a1*a2'/(l1*l2));    % �����н�
theta0 = pi-2*theta-alpha;
if theta0<0, return; end         % �޷�����Բ��
h = r*sin(0.5*(alpha+theta0));   % Բ�����ĵ��߶�ij�ľ���
l = h/tan(alpha*0.5)-r*cos(0.5*(alpha+theta0));  % Բ�����㵽��j�ľ���
if length(l)>1
    test = 1;  %#ok
end
% �жϽ����Ƿ����߶���
if (disa(1)-l)*(disa(2)-l)>0
    return;
end
if (disb(1)-l)*(disb(2)-l)>0
    return;
end
St = l*h-0.5*theta0*r^2;  %#ok
A = 0.5*theta0*r^2 - 0.5*r^2*sin(theta0);        % �������
L = r*theta0;                    % ��������
% A = - St;                      % ����ı�
% L = - 2*l + r*theta0;          % �ܳ��ı�
a10 = a1/norm(a1);
a20 = a2/norm(a2);
rc = (a10+a20)/norm(a10+a20)*h/sin(0.5*alpha);   % j��ָ��Բ��
pcir = rc + data(j,:);           % Բ������

% ����Բ���ߵ�
direc = cross([a10,0],[a20,0]);
direc = sign(direc(3));
thetap = linspace(0,theta0,10)'*direc;            % ��10�����ݵ�
ap = zeros(10,2);
for ii = 1:10
    T = [cos(thetap(ii)),sin(thetap(ii));-sin(thetap(ii)),cos(thetap(ii))];
    ap(ii,:) = (T*(a10*l-rc)')'+rc+data(j,:);
end

% �������ݼ�
prop = 3 - [ind1, ind2];
prop = [prop, abs(disa(1)-l)/abs(disa(2)-disa(1)), abs(disb(1)-l)/abs(disb(2)-disb(1))];% ���㵽�����߶ε�һ�����Ծ��릻

% ba1 = a(1,:)-b(1,:);
% a0 = (a(2,:)-a(1,:))/norm(a(2,:)-a(1,:));
% b0 = (b(2,:)-b(1,:))/norm(b(2,:)-b(1,:));
% theta0 = acos(a0*b0');
% theta1 = acos(ba1*b0'/norm(ba1));
% h = norm(ba1)*sin(theta1);
% ac = h/sin(theta0)*(-a0);
% pc = a(1,:)+ac;  % ��ý��������


