global  direc_flag1 direc_flag2              % ��ǰ�켣���켣�����Ŀ
direc_flag1 = -1;                            % �켣�ķ���,��Ҫ����ʵ�ʶ�ȡ��txtȷ����-1/1
direc_flag2 = 1;                             % Բ���ķ���-1/1
rmin = 0;                                    % �뾶����
rmax = 3;                                   % �뾶����
theta = pi/11.5;    % ��ʪ�Ǧ�    0 * pi/12
% filefolder = '��ڰ뾶r\������Ϣ';
filefolder = 'C:\Users\2019\Desktop\123\��ڰ뾶\rHD\���';
dirfile = dir(fullfile(filefolder,'*.txt'));
fname = {dirfile.name};
data = load(fullfile(filefolder,fname{4}));  % ��ȡ����  ��8 4 
% while Tind<=Tind_max
% ���Ż����
%   options = optimset('Display','iter');    % �����ñ�ʾ����ȡ�У���ʾ�������̡�
%   options = optimset('PlotFcns',@optimplotfval);  % �����ñ�ʾ����ȡ�У����Ƶ���ͼ��
[r,fval] = fminbnd(@(r)theory_f(r, theta, data),rmin,rmax);
%     Tind = Tind + 1;
% end

% ��ͼ
figure
plot([data(:,1);data(1,1)],[data(:,2);data(1,2)],'b');
% ���ͼ�Σ���ָ����ɫ��kΪ��ɫ��bΪ��ɫ��rΪ��ɫ��wΪ��ɫ...
% fill([data(:,1);data(1,1)],[data(:,2);data(1,2)],'k');
hold on

% ���п��ܵ�Բ����ͼ
line_prop = cal_myshape(r,theta,data);
for i = 1:size(data,1)                 % �ߵ���Ŀ
    for j=1:2                          % ÿ���ߵ�2����
        if line_prop(i).pos(j,3)~=0    % ������һ���߶α���ж��Ƿ����Բ��
            plot(line_prop(i).arc(:,j*2-1),line_prop(i).arc(:,j*2),'k');
        end
    end
end

% �����ȡ
color = {'r--','g--','p--'};
pc = {'ro','go','po'};
jc = {'r*','g*','p*'};
cc = {'rx','gx','px'};
line_prop = cal_myshape(r,theta,data);
tra = trajectory(line_prop,data);
for i = 1:length(tra)
    % �켣����
    plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],color{mod(i-1,3)+1},'LineWidth',2);
    % plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'r');

    %%%%%%%%%%%%%% ���ͼ�β�ָ����ɫ��kΪ��ɫ��rΪ��ɫ��wΪ��ɫ... %%%%%%%%%%%%%%%%%%%%%%%%
    % fill([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'w');
    axis equal
    set(gca,'XTick',[],'YTick',[]);              % ����������
    set(gca,'looseInset',[0 0 0 0]);             % ȥ��ͼƬ��ɫ�հ�����
    set(gca,'Visible','off');                    % ȥ��ͼƬĬ�Ϻ��߱߿�
    set(gcf,'position',[200,500,179.2,179.2])    % ͼƬ��ʾλ�ã�200,500��ָ��ͼƬ��С��224*224
    set(gcf,'color','white');                    % �趨figure�ı�����ɫ
%     str= strcat (filefolder2,fname{a});
%     img = getframe(gcf);
%     imwrite(img.cdata,[char(str(1:end-4)),'.png']);       % �洢��������С��ͼƬ  %3d,
    
    
    
    % �е㼰���н������
    scatter(tra(i).point(:,1),tra(i).point(:,2),pc{mod(i-1,3)+1});
    % ���⽻�����
    % scatter(tra(i).jpoint(:,1),tra(i).jpoint(:,2),jc{mod(i-1,3)+1});
    % Բ�ĵ����
    % scatter(tra(i).cpoint(:,1),tra(i).cpoint(:,2),cc{mod(i-1,3)+1});
end




