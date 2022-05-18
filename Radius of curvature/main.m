global  direc_flag1 direc_flag2              % ��ǰ�켣���켣�����Ŀ
direc_flag1 = -1;                            % �켣�ķ���,��Ҫ����ʵ�ʶ�ȡ��txtȷ����-1/1
direc_flag2 = 1;                             % Բ���ķ���-1/1
% rmin = 0;                                    % �뾶����
% rmax = 0.3;                                  % �뾶����
theta = pi/9;    % ��ʪ�Ǧ�  pi/12  0 *
filefolder1 = '��ڰ뾶r\������Ϣ';
filefolder2 = '��ڰ뾶r\������';
filefolder3 = '��ڰ뾶r\����\';
% filefolder1 = 'C:\Users\2019\Desktop\123\��ڰ뾶\rHD\���';

dirfile = dir(fullfile(filefolder1,'*.txt'));
fname = {dirfile.name};
len = length(dirfile);

fid = fopen('��ڰ뾶r\1.txt','w+');          % �����ļ�
fprintf(fid,'���S ����ԲRins ˮ���뾶 R(S/P) ��ڰ뾶r ���fval �������Ao ˮ�����Aw\n');

for a = 1 : len
    data = load(fullfile(filefolder1,fname{3}));  % ��ȡ����   ����9 0.3/0.4
    
    %---------------------- ˮ���뾶 R -----------------------------------
    X = data(:,1);
    Y = data(:,2);
    X = [X;X(1)];  %#ok
    Y = [Y;Y(1)];  %#ok
    S = polyarea(X,Y);  % ���
    % plot(x,y)
    
    long = length(X);
    P = 0;              % �ܳ�
    for l=1:long-1
        d = sqrt((X(l+1)-X(l))^2+(Y(l+1)-Y(l))^2);
        P = P + d;
    end
    R = S/P;
    
    
    %--------------------- �������Բ Rins -------------------------------
    %--------------------- Բ������ center -------------------------------
    left_x=min(X);right_x=max(X);down_y=min(Y);up_y=max(Y);upper_r=min([right_x-left_x,up_y-down_y])/2;
    % �������ж��־���
    precision=sqrt((right_x-left_x)^2+(up_y-down_y)^2)/2^13;
    %������������ľ��ε��������ص�
    Nx=2^8;Ny=2^8;pixel_X=linspace(left_x,right_x,Nx);pixel_Y=linspace(down_y,up_y,Ny);
    [pixel_X,pixel_Y]=ndgrid(pixel_X,pixel_Y);pixel_X=reshape(pixel_X,numel(pixel_X),1);pixel_Y=reshape(pixel_Y,numel(pixel_Y),1);
    % ɸѡ���������������ص�
    in=inpolygon(pixel_X,pixel_Y,X,Y);
    pixel_X=pixel_X(in);pixel_Y=pixel_Y(in);
    % plot(X,Y,'*r',pixel_X,pixel_Y,'ob')

    %%%% ��������ٷ�֮һ�����������Բ�뾶����
    N=length(pixel_X);
    rand_index=randperm(N,floor(N/100));
    Rins=0;big_r=upper_r;center=[];
    for i = rand_index
        tr=iterated_optimal_incircle_Rins_get(X,Y,pixel_X(i),pixel_Y(i),Rins,big_r,precision);
        if tr>Rins
           Rins=tr;
           center=[pixel_X(i),pixel_Y(i)];    % ֻ�а뾶��������λ�ñ�������򱣳�֮ǰλ�ò���
        end
    end

    %%%% ѭ������ʣ�����ض�Ӧ����Բ�뾶
    loops_index=1:N;loops_index(rand_index)=[];
    for i = loops_index
        tr=iterated_optimal_incircle_Rins_get(X,Y,pixel_X(i),pixel_Y(i),Rins,big_r,precision);
        if tr>Rins
           Rins=tr;
           center=[pixel_X(i),pixel_Y(i)];    % ֻ�а뾶��������λ�ñ�������򱣳�֮ǰλ�ò���
        end
    end
    
    %%%% Ч������(�������Բ)
%     circle_X=center(1)+Rins*cos(linspace(0,2*pi,100));
%     circle_Y=center(2)+Rins*sin(linspace(0,2*pi,100));
%     figure
%     hold on
%     axis equal
%     plot(X,Y,'LineWidth',2.5)
%     plot(circle_X,circle_Y,'LineWidth',2)
%     axis off
%     hold off

    
    
    
    %---------------------- �������� -------------------------------------
    %------------------- ��С��ڰ뾶 r ----------------------------------
    %------------------- ��С��� fval -----------------------------------
    rmin = 0;                                     % �뾶����
    rmax = Rins;                                  % �뾶����

    % while Tind<=Tind_max
    % ���Ż����
    
    %   options = optimset('Display','iter');    % �����ñ�ʾ����ȡ�У���ʾ�������̡�
    %   options = optimset('PlotFcns',@optimplotfval);  % �����ñ�ʾ����ȡ�У����Ƶ���ͼ��
    
    [r,fval] = fminbnd(@(r)theory_f(r, theta, data),rmin,rmax);

    
%%%%%%%%%%%%%%%%%%%%%%% ���ƶ�������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    plot([data(:,1);data(1,1)],[data(:,2);data(1,2)],'b');
    
    % ���ͼ�Σ���ָ����ɫ��kΪ��ɫ��rΪ��ɫ��bΪ��ɫ��wΪ��ɫ...
    fill([data(:,1);data(1,1)],[data(:,2);data(1,2)],'k');
    hold on

%%%%%%%%%%%%%%%%%%%%%% ���п��ܵ�Բ����ͼ %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     line_prop = cal_myshape(r,theta,data);
%     for i = 1:size(data,1)                 % �ߵ���Ŀ
%         for j=1:2                          % ÿ���ߵ�2����
%             if line_prop(i).pos(j,3)~=0    % ������һ���߶α���ж��Ƿ����Բ��
%                 plot(line_prop(i).arc(:,j*2-1),line_prop(i).arc(:,j*2),'k');
%             end
%         end
%     end

    % �����ȡ
    color = {'r--','g--','p--'};
    pc = {'ro','go','po'};
    jc = {'r*','g*','p*'};
    cc = {'rx','gx','px'};
    line_prop = cal_myshape(r,theta,data);
    tra = trajectory(line_prop,data);
    for i = 1:length(tra)
        % �켣����
        % plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],color{mod(i-1,3)+1},'LineWidth',4);
        plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'k');
        
%%%%%%%%%%%%%%% ���ͼ�β�ָ����ɫ��kΪ��ɫ��rΪ��ɫ��wΪ��ɫ... %%%%%%%%%%%%%%%%%%%%%%%%
        fill([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'w');
        axis equal
        set(gca,'XTick',[],'YTick',[]);              % ����������
        set(gca,'looseInset',[0 0 0 0]);             % ȥ��ͼƬ��ɫ�հ�����
        set(gca,'Visible','off');                    % ȥ��ͼƬĬ�Ϻ��߱߿�
        set(gcf,'position',[200,500,179.2,179.2])    % ͼƬ��ʾλ�ã�200,500��ָ��ͼƬ��С��224*224
        set(gcf,'color','white');                    % �趨figure�ı�����ɫ
        str= strcat (filefolder3,fname{a});
        img = getframe(gcf);
        imwrite(img.cdata,[char(str(1:end-4)),'.png']);       % �洢��������С��ͼƬ

        
        % �е㼰���н������
        %scatter(tra(i).point(:,1),tra(i).point(:,2),pc{mod(i-1,3)+1});
        % ���⽻�����
        % scatter(tra(i).jpoint(:,1),tra(i).jpoint(:,2),jc{mod(i-1,3)+1});
        % Բ�ĵ���� 
        %scatter(tra(i).cpoint(:,1),tra(i).cpoint(:,2),cc{mod(i-1,3)+1});
    end
    
    
    Ao = sum(cat(1,tra.S));     % �����������Ao
    % Aw = S - Ao;              % ����ˮ���������Ao
    fprintf(fid,'%f %f %f %f %8f %f %f\n',S,Rins,R,r,fval,Ao,S-Ao);
    
end
fclose(fid);



function radius=iterated_optimal_incircle_Rins_get(X,Y,pixelx,pixely,small_r,big_r,precision)
radius=small_r;
L=linspace(0,2*pi,360);        % ȷ��Բɢ���ʷ���360,720
% L=2*pi*sort(rand(1,360));    % ���ȷ��Բɢ���ʷ���360,720
circle_X=pixelx+radius*cos(L);circle_Y=pixely+radius*sin(L);
if numel(circle_X(~inpolygon(circle_X,circle_Y,X,Y)))>0           % ���Բɢ����������֮��ĵ�
    return
else
    while big_r-small_r>=precision                                % ���ַ�Ѱ�����뾶
        half_r=(small_r+big_r)/2;
        circle_X=pixelx+half_r*cos(L);circle_Y=pixely+half_r*sin(L);
        if numel(circle_X(~inpolygon(circle_X,circle_Y,X,Y)))>0   % ���Բɢ����������֮��ĵ�
            big_r=half_r;
        else
            small_r=half_r;    
        end
    end
    radius=small_r;
end
end
