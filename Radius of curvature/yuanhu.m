global  direc_flag1 direc_flag2    % ��ǰ�켣���켣�����Ŀ
direc_flag1 = 1;                   % �켣�ķ���,��Ҫ����ʵ�ʶ�ȡ��txtȷ����-1/1
direc_flag2 = 1;                   % Բ���ķ���-1/1
rmin = 0;                          % �뾶����
rmax = 0.6;                        % �뾶����
theta = 0*pi/12;                   % ��ʪ��
filefolder = '��ڰ뾶r\������Ϣ';
dirfile = dir(fullfile(filefolder,'*.txt'));
fname = {dirfile.name};
data = load(fullfile(filefolder,fname{1}));  % ��ȡ����
r = 0.1465;
plotflag = 1;
S0 = 0;
L0 = 0;
[A,L] = cal_myshape_v0(r,theta,data,S0,L0,direc_flag1,plotflag);