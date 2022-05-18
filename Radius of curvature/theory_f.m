function f = theory_f(r, theta, data)
f = r*0;  % 初始化
for I = 1:length(r)
    line_prop = cal_myshape(r(I),theta,data);
    tra = trajectory(line_prop,data);
    Tind_max = length(tra);  % 生成线段的数目
    Los = 0;
    Low = 0;
    A0 = 0;
    for Tind = 1:Tind_max
        Los = Los + tra(Tind).LC;
        Low = Low + tra(Tind).LL;
        A0 = A0 + tra(Tind).S;
    end
    f(I) = (A0/(Los*cos(theta)+Low)-r(I))^2;
end

