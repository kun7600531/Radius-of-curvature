function line_prop = cal_myshape(r,theta,data)
global direc_flag1 direc_flag2
% ���㵱ǰ�뾶�ͽǶ������п��ܵ�Բ����������Line_prop��
m = size(data,1);
% ���Գ�ʼ��
for i = 1:m
    % �����ߵ�һ/�����Բ������,�����һ��ĳ��ȣ���һ���߶εı�ţ���һ���߶εĿ��������,������ӣ���������
    % Բ�Ľڵ����꣬Բ����Ӧ�����ߵĽ�������
    line_prop(i).pos = [0,0,0,0,0,0,0,0,0,0;0,1,0,0,0,0,0,0,0,0];  %#ok
    line_prop(i).arc = zeros(10,4);  %#ok       % ���߶ε�һ/������ʼ��Բ��
end

for i = 1:m-1
    for i2 = i+1:m
        if i==20
            test = 1;  %#ok
        end
    j1 = i+1;                                   % �߶�1��j��
    j2 = i2;                                    % �߶�2��j��
    k = mod(i2, m)+1;                           % �߶�2��k��
    a1 = -data(j1,:)+data(i,:);                 % ��jָ���i������
    a2 = -data(j2,:)+data(k,:);                 % ��jָ���k������
    flag = cross(-[a1,0],[a2,0])*direc_flag1;   % �ж��Ƿ�Ϊ�ڹ�   ���ڱ߽�
    if j2>j1, flag(3)=1; end                    % ���ٽ���ʱ�޷��ж��Ƿ��ڹգ�һ����Ϊ����
    dataa = data([i,j1],:);
    datab = data([j2,k],:);
    if flag(3)>0
        [dA,dL,ap,pcir,prop,pjia] = myarc(dataa,datab,r,theta);  % ����Բ������
        if ~isempty(ap)                         % �ж��Ƿ���ڿ���Բ��
            %----------------- �ж�Բ���Ƿ���߽�� ---------------------------------------
            bflag = 1;
            rp1 = (ap(1,:)-pcir)/norm(ap(1,:)-pcir);             % Բ���߽�1
            rp2 = (ap(end,:)-pcir)/norm(ap(end,:)-pcir);         % Բ���߽�2
            rtheta = acos(rp1*rp2');                             % Բ���Ƕ�
            for i3 = 1:m
                if i3==i||i3==i2, continue; end
                lp = data(i3,:) + (data(mod(i3,m)+1,:)-data(i3,:)).*linspace(0,1,20)'-pcir; % ����Բ�����ĵ��߶��ϵĲ����������
                lp_theta1 = acos((lp*rp1')./sqrt(sum(lp.^2,2))); % ��Բ���߽�1�ļн�
                lp_theta2 = acos((lp*rp2')./sqrt(sum(lp.^2,2))); % ��Բ���߽�2�ļн�
                ind = find(lp_theta1<=rtheta&lp_theta2<=rtheta); % Ѱ����Բ���߽��ڵĵ�
                if ~isempty(ind)                                 % ������ʱ
                dislp = sqrt(sum((lp(ind,:)).^2,2))-r;           % ������뾶���
                if min(dislp)<0                                  % ���߽�ʱ
                    bflag = 0;
                    break;
                end
                end
            end
            if bflag == 0, continue; end                         % ������߽�㣬��ȥ��������һ����
            %-------------------- �ж�Բ�����ڱ߽��� --------------------------------------
            a2c = -data(j1,:)+pcir;                              % ��jָ���k������?
            cflag = cross(-[a1,0],[a2c,0])*direc_flag1*direc_flag2;   % �ж��Ƿ�Ϊ�ڹ� �������ڱ߽硿
            if cflag(3)<=0, continue; end                        % �ڱ߽��⣬������˴ν��
            %---------- ����Բ����ֱ�ߵĽ����ж���֮ǰ��Բ���Ƿ���ڽ��� ------------------
            jx1_flag = (line_prop(i).pos(3-prop(1),2)-prop(3))*(-1)^prop(1)>0;           % ����0ʱ���ڽ���
            jx2_flag = (line_prop(i2).pos(3-prop(2),2)-prop(4))*(-1)^prop(2)>0;          % ����0ʱ���ڽ���
            if jx1_flag||jx2_flag
                if jx1_flag
                    line2=line_prop(i).pos(3-prop(1),3:4);       % ֮ǰ�߶�Բ�����ڵ���һ���߱�ż��俿����
                    line_prop(line2(1)).pos(line2(2),:)=[0,line2(2)-1,0,0,0,0,0,0,0,0];  % �����һ���ߵĽ��
                    line_prop(i).pos(3-prop(1),:)=[0,2-prop(1),0,0,0,0,0,0,0,0];         % �����ǰ�����ߵĽ��
                end
                if jx2_flag
                    line2=line_prop(i3).pos(3-prop(2),3:4);      % ֮ǰ�߶�Բ�����ڵ���һ���߱�ż��俿����
                    line_prop(line2(1)).pos(line2(2),:)=[0,line2(2)-1,0,0,0,0,0,0,0,0];  % �����һ���ߵĽ��
                    line_prop(i2).pos(3-prop(2),:)=[0,2-prop(2),0,0,0,0,0,0,0,0];        % �����ǰ�����ߵĽ��
                end
                continue;                                        % ��������μ�����
            end
            %-------------------�ж�Բ����֮ǰԲ���Ĺ�ϵ-----------------------------------
            if line_prop(i).pos(prop(1),1)<dL&&line_prop(i2).pos(prop(2),1)<dL
                %  ��ĿǰԲ�����ȴ���֮ǰ���ɵ�Բ������ʱ
                line_old=line_prop(i).pos(prop(1),3);            % ��ȡСԲ�������ı�
                if line_old>0                                    % ��ȡСԲ�������ıߴ���ʱ
                cp_old=line_prop(i).pos(prop(1),4);              % ��ȡСԲ�������Ŀ�����
                line_prop(line_old).pos(cp_old,:)=[0,cp_old-1,0,0,0,0,0,0,0,0];          % �����һ���ߵĽ��
                end
                line_prop(i).pos(prop(1),:)=[dL,prop(3),i2,prop(2),dA,dL,pcir,pjia];     % ʹ�õ�ǰԲ��
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
%     j = mod(i, m)+1;              % �ڶ�����
%     k = mod(i+1, m)+1;            % ��������
%     a1 = -data(j,:)+data(i,:);    % ��jָ���i������
%     a2 = -data(j,:)+data(k,:);    % ��jָ���k������
%     flag = cross(-[a1,0],[a2,0])*direc;    % �ж��Ƿ�Ϊ�ڹ�
%     if flag(3)>0
%         [dA,dL,ap] = myarc(data([i,j],:),data([j,k],:),r,theta,plotflag,direc);  % ����Բ������
%         if ~isempty(ap)
%         A = A + dA;
%         L = L + dL;
%         if plotflag == 1
%             plot(ap(:,1),ap(:,2),'r');
%         end
%         end
%     end
% end
