global  direc_flag1 direc_flag2              % 当前轨迹，轨迹最大数目
direc_flag1 = -1;                            % 轨迹的方向,需要根据实际读取的txt确定，-1/1
direc_flag2 = 1;                             % 圆弧的方向，-1/1
% rmin = 0;                                    % 半径下限
% rmax = 0.3;                                  % 半径上限
theta = pi/9;    % 润湿角θ  pi/12  0 *
filefolder1 = '入口半径r\坐标信息';
filefolder2 = '入口半径r\中轴线';
filefolder3 = '入口半径r\测试\';
% filefolder1 = 'C:\Users\2019\Desktop\123\入口半径\rHD\喉道';

dirfile = dir(fullfile(filefolder1,'*.txt'));
fname = {dirfile.name};
len = length(dirfile);

fid = fopen('入口半径r\1.txt','w+');          % 创建文件
fprintf(fid,'面积S 内切圆Rins 水力半径 R(S/P) 入口半径r 误差fval 油区面积Ao 水区面积Aw\n');

for a = 1 : len
    data = load(fullfile(filefolder1,fname{3}));  % 读取数据   例子9 0.3/0.4
    
    %---------------------- 水力半径 R -----------------------------------
    X = data(:,1);
    Y = data(:,2);
    X = [X;X(1)];  %#ok
    Y = [Y;Y(1)];  %#ok
    S = polyarea(X,Y);  % 面积
    % plot(x,y)
    
    long = length(X);
    P = 0;              % 周长
    for l=1:long-1
        d = sqrt((X(l+1)-X(l))^2+(Y(l+1)-Y(l))^2);
        P = P + d;
    end
    R = S/P;
    
    
    %--------------------- 最大内切圆 Rins -------------------------------
    %--------------------- 圆心坐标 center -------------------------------
    left_x=min(X);right_x=max(X);down_y=min(Y);up_y=max(Y);upper_r=min([right_x-left_x,up_y-down_y])/2;
    % 定义相切二分精度
    precision=sqrt((right_x-left_x)^2+(up_y-down_y)^2)/2^13;
    %构造包含轮廓的矩形的所有像素点
    Nx=2^8;Ny=2^8;pixel_X=linspace(left_x,right_x,Nx);pixel_Y=linspace(down_y,up_y,Ny);
    [pixel_X,pixel_Y]=ndgrid(pixel_X,pixel_Y);pixel_X=reshape(pixel_X,numel(pixel_X),1);pixel_Y=reshape(pixel_Y,numel(pixel_Y),1);
    % 筛选出轮廓内所有像素点
    in=inpolygon(pixel_X,pixel_Y,X,Y);
    pixel_X=pixel_X(in);pixel_Y=pixel_Y(in);
    % plot(X,Y,'*r',pixel_X,pixel_Y,'ob')

    %%%% 随机搜索百分之一像素提高内切圆半径下限
    N=length(pixel_X);
    rand_index=randperm(N,floor(N/100));
    Rins=0;big_r=upper_r;center=[];
    for i = rand_index
        tr=iterated_optimal_incircle_Rins_get(X,Y,pixel_X(i),pixel_Y(i),Rins,big_r,precision);
        if tr>Rins
           Rins=tr;
           center=[pixel_X(i),pixel_Y(i)];    % 只有半径变大才允许位置变更，否则保持之前位置不变
        end
    end

    %%%% 循环搜索剩余像素对应内切圆半径
    loops_index=1:N;loops_index(rand_index)=[];
    for i = loops_index
        tr=iterated_optimal_incircle_Rins_get(X,Y,pixel_X(i),pixel_Y(i),Rins,big_r,precision);
        if tr>Rins
           Rins=tr;
           center=[pixel_X(i),pixel_Y(i)];    % 只有半径变大才允许位置变更，否则保持之前位置不变
        end
    end
    
    %%%% 效果测试(最大内切圆)
%     circle_X=center(1)+Rins*cos(linspace(0,2*pi,100));
%     circle_Y=center(2)+Rins*sin(linspace(0,2*pi,100));
%     figure
%     hold on
%     axis equal
%     plot(X,Y,'LineWidth',2.5)
%     plot(circle_X,circle_Y,'LineWidth',2)
%     axis off
%     hold off

    
    
    
    %---------------------- 代码正文 -------------------------------------
    %------------------- 最小入口半径 r ----------------------------------
    %------------------- 最小误差 fval -----------------------------------
    rmin = 0;                                     % 半径下限
    rmax = Rins;                                  % 半径上限

    % while Tind<=Tind_max
    % 最优化求解
    
    %   options = optimset('Display','iter');    % 该设置表示在求取中，显示迭代过程。
    %   options = optimset('PlotFcns',@optimplotfval);  % 该设置表示在求取中，绘制迭代图。
    
    [r,fval] = fminbnd(@(r)theory_f(r, theta, data),rmin,rmax);

    
%%%%%%%%%%%%%%%%%%%%%%% 绘制多边形轮廓 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    plot([data(:,1);data(1,1)],[data(:,2);data(1,2)],'b');
    
    % 填充图形，并指定颜色：k为黑色，r为红色，b为蓝色，w为白色...
    fill([data(:,1);data(1,1)],[data(:,2);data(1,2)],'k');
    hold on

%%%%%%%%%%%%%%%%%%%%%% 所有可能的圆弧绘图 %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     line_prop = cal_myshape(r,theta,data);
%     for i = 1:size(data,1)                 % 边的数目
%         for j=1:2                          % 每条边的2个点
%             if line_prop(i).pos(j,3)~=0    % 根据另一条线段编号判断是否存在圆弧
%                 plot(line_prop(i).arc(:,j*2-1),line_prop(i).arc(:,j*2),'k');
%             end
%         end
%     end

    % 结果提取
    color = {'r--','g--','p--'};
    pc = {'ro','go','po'};
    jc = {'r*','g*','p*'};
    cc = {'rx','gx','px'};
    line_prop = cal_myshape(r,theta,data);
    tra = trajectory(line_prop,data);
    for i = 1:length(tra)
        % 轨迹绘制
        % plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],color{mod(i-1,3)+1},'LineWidth',4);
        plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'k');
        
%%%%%%%%%%%%%%% 填充图形并指定颜色：k为黑色，r为红色，w为白色... %%%%%%%%%%%%%%%%%%%%%%%%
        fill([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'w');
        axis equal
        set(gca,'XTick',[],'YTick',[]);              % 隐藏坐标轴
        set(gca,'looseInset',[0 0 0 0]);             % 去除图片白色空白区域
        set(gca,'Visible','off');                    % 去除图片默认黑线边框
        set(gcf,'position',[200,500,179.2,179.2])    % 图片显示位置：200,500；指定图片大小：224*224
        set(gcf,'color','white');                    % 设定figure的背景颜色
        str= strcat (filefolder3,fname{a});
        img = getframe(gcf);
        imwrite(img.cdata,[char(str(1:end-4)),'.png']);       % 存储调整过大小的图片

        
        % 切点及已有交点绘制
        %scatter(tra(i).point(:,1),tra(i).point(:,2),pc{mod(i-1,3)+1});
        % 虚拟交点绘制
        % scatter(tra(i).jpoint(:,1),tra(i).jpoint(:,2),jc{mod(i-1,3)+1});
        % 圆心点绘制 
        %scatter(tra(i).cpoint(:,1),tra(i).cpoint(:,2),cc{mod(i-1,3)+1});
    end
    
    
    Ao = sum(cat(1,tra.S));     % 油区的总面积Ao
    % Aw = S - Ao;              % 角落水区的总面积Ao
    fprintf(fid,'%f %f %f %f %8f %f %f\n',S,Rins,R,r,fval,Ao,S-Ao);
    
end
fclose(fid);



function radius=iterated_optimal_incircle_Rins_get(X,Y,pixelx,pixely,small_r,big_r,precision)
radius=small_r;
L=linspace(0,2*pi,360);        % 确定圆散点剖分数360,720
% L=2*pi*sort(rand(1,360));    % 随机确定圆散点剖分数360,720
circle_X=pixelx+radius*cos(L);circle_Y=pixely+radius*sin(L);
if numel(circle_X(~inpolygon(circle_X,circle_Y,X,Y)))>0           % 如果圆散集有在轮廓之外的点
    return
else
    while big_r-small_r>=precision                                % 二分法寻找最大半径
        half_r=(small_r+big_r)/2;
        circle_X=pixelx+half_r*cos(L);circle_Y=pixely+half_r*sin(L);
        if numel(circle_X(~inpolygon(circle_X,circle_Y,X,Y)))>0   % 如果圆散集有在轮廓之外的点
            big_r=half_r;
        else
            small_r=half_r;    
        end
    end
    radius=small_r;
end
end
