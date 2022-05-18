global  direc_flag1 direc_flag2    % 当前轨迹，轨迹最大数目
direc_flag1 = 1;                   % 轨迹的方向,需要根据实际读取的txt确定，-1/1
direc_flag2 = 1;                   % 圆弧的方向，-1/1
rmin = 0;                          % 半径下限
rmax = 0.6;                        % 半径上限
theta = 0*pi/12;                   % 润湿角
filefolder = '入口半径r\坐标信息';
dirfile = dir(fullfile(filefolder,'*.txt'));
fname = {dirfile.name};
data = load(fullfile(filefolder,fname{1}));  % 读取数据
r = 0.1465;
plotflag = 1;
S0 = 0;
L0 = 0;
[A,L] = cal_myshape_v0(r,theta,data,S0,L0,direc_flag1,plotflag);