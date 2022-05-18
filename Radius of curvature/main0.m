global  direc_flag1 direc_flag2              % 当前轨迹，轨迹最大数目
direc_flag1 = -1;                            % 轨迹的方向,需要根据实际读取的txt确定，-1/1
direc_flag2 = 1;                             % 圆弧的方向，-1/1
rmin = 0;                                    % 半径下限
rmax = 3;                                   % 半径上限
theta = pi/11.5;    % 润湿角θ    0 * pi/12
% filefolder = '入口半径r\坐标信息';
filefolder = 'C:\Users\2019\Desktop\123\入口半径\rHD\喉道';
dirfile = dir(fullfile(filefolder,'*.txt'));
fname = {dirfile.name};
data = load(fullfile(filefolder,fname{4}));  % 读取数据  例8 4 
% while Tind<=Tind_max
% 最优化求解
%   options = optimset('Display','iter');    % 该设置表示在求取中，显示迭代过程。
%   options = optimset('PlotFcns',@optimplotfval);  % 该设置表示在求取中，绘制迭代图。
[r,fval] = fminbnd(@(r)theory_f(r, theta, data),rmin,rmax);
%     Tind = Tind + 1;
% end

% 绘图
figure
plot([data(:,1);data(1,1)],[data(:,2);data(1,2)],'b');
% 填充图形，并指定颜色：k为黑色，b为蓝色，r为红色，w为白色...
% fill([data(:,1);data(1,1)],[data(:,2);data(1,2)],'k');
hold on

% 所有可能的圆弧绘图
line_prop = cal_myshape(r,theta,data);
for i = 1:size(data,1)                 % 边的数目
    for j=1:2                          % 每条边的2个点
        if line_prop(i).pos(j,3)~=0    % 根据另一条线段编号判断是否存在圆弧
            plot(line_prop(i).arc(:,j*2-1),line_prop(i).arc(:,j*2),'k');
        end
    end
end

% 结果提取
color = {'r--','g--','p--'};
pc = {'ro','go','po'};
jc = {'r*','g*','p*'};
cc = {'rx','gx','px'};
line_prop = cal_myshape(r,theta,data);
tra = trajectory(line_prop,data);
for i = 1:length(tra)
    % 轨迹绘制
    plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],color{mod(i-1,3)+1},'LineWidth',2);
    % plot([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'r');

    %%%%%%%%%%%%%% 填充图形并指定颜色：k为黑色，r为红色，w为白色... %%%%%%%%%%%%%%%%%%%%%%%%
    % fill([tra(i).route(:,1);tra(i).route(1,1)],[tra(i).route(:,2);tra(i).route(1,2)],'w');
    axis equal
    set(gca,'XTick',[],'YTick',[]);              % 隐藏坐标轴
    set(gca,'looseInset',[0 0 0 0]);             % 去除图片白色空白区域
    set(gca,'Visible','off');                    % 去除图片默认黑线边框
    set(gcf,'position',[200,500,179.2,179.2])    % 图片显示位置：200,500；指定图片大小：224*224
    set(gcf,'color','white');                    % 设定figure的背景颜色
%     str= strcat (filefolder2,fname{a});
%     img = getframe(gcf);
%     imwrite(img.cdata,[char(str(1:end-4)),'.png']);       % 存储调整过大小的图片  %3d,
    
    
    
    % 切点及已有交点绘制
    scatter(tra(i).point(:,1),tra(i).point(:,2),pc{mod(i-1,3)+1});
    % 虚拟交点绘制
    % scatter(tra(i).jpoint(:,1),tra(i).jpoint(:,2),jc{mod(i-1,3)+1});
    % 圆心点绘制
    % scatter(tra(i).cpoint(:,1),tra(i).cpoint(:,2),cc{mod(i-1,3)+1});
end




