%% start
clc
clear
close all

%% load data
jpm_sp500grow = load("JPMorgan U.S. Research Enhanced Equity Fund.txt");
jpm_smallcap = load("JPMorgan Small Cap Equity Fund.txt");
jpm_eqincome = load("JPMorgan Equity Income Fund.txt");

br_sp500grow = load("BlackRock SP-500 Growth ETF fund.txt");
br_smallcap = load("BlackRock Russell 2000 ETF fund.txt");
br_china = load("BlackRock MSCI China-ETF fund.txt");

FF3 = load("FF3.txt");

% extract FF 3 factors and risk free rate
mkt_rf = FF3(:,3) / 100;
smb = FF3(:,4) / 100;
hml = FF3(:,5) / 100;
rf = FF3(:,6) / 100;
mkt = mkt_rf + rf;

% each monthly return
jpm_lcap_r = jpm_sp500grow(:,3)/100;
jpm_scap_r = jpm_smallcap(:,3)/100;
jpm_eqincome_r = jpm_eqincome(:,3)/100;

br_lcap_r = br_sp500grow(:,3)/100;
br_scap_r = br_smallcap(:,3)/100;
br_china_r = br_china(:,3)/100;

% construct date
yr = FF3(:,1);
mo = FF3(:,2);
date = eomday(yr, mo);
matlabdate = datenum(yr, mo, date);
T = length(matlabdate);

%% correlation
correlation_matrix = corr([mkt, jpm_lcap_r, br_lcap_r, ...
    jpm_scap_r,br_scap_r, jpm_eqincome_r, br_china_r]);

%           mkt    jpm_lcp    br_lcp    jpm_scp   br_scp     eqincome  china
%mkt      1.0000    0.9914    0.9578    0.9290    0.9099    0.9364    0.4318
%jpm_lcp  0.9914    1.0000    0.9567    0.9069    0.8789    0.9416    0.4242
%br_lcp   0.9578    0.9567    1.0000    0.8293    0.7986    0.8407    0.3798
%jpm_scp  0.9290    0.9069    0.8293    1.0000    0.9628    0.9061    0.3785
%br_scp   0.9099    0.8789    0.7986    0.9628    1.0000    0.8601    0.4183
%eqincome 0.9364    0.9416    0.8407    0.9061    0.8601    1.0000    0.3754
%china    0.4318    0.4242    0.3798    0.3785    0.4183    0.3754    1.0000

%% plot each fund's monthly return
% figure
% plot(matlabdate, [jpm_lcap_r, jpm_scap_r, jpm_eqincome_r, br_lcap_r, ...
%     br_scap_r,br_china_r ])
% hold on
%     plot(xlim, [0,0], 'k--')
% hold off
% datetick

%% cumulate each monthly return to annual frequency
H = 12; % 12 months

%large cap
GR1 = jpm_lcap_r + 1;
sum_jpm_lcap = movsum(log(GR1), [H-1 0], 'Endpoints', 'fill') ;
jpm_lcap_annual= (exp(sum_jpm_lcap)-1)*100;

GR2 = br_lcap_r + 1;
sum_br_lcap = movsum(log(GR2), [H-1 0], 'Endpoints', 'fill') ;
br_lcap_annual= (exp(sum_br_lcap)-1)*100;

figure
subplot(2,2,1)
plot(matlabdate, [jpm_lcap_annual, br_lcap_annual],"LineWidth",2.0)
xlabel('Time','Interpreter','latex')
ylabel("Return",'Interpreter','latex')
datetick
title("Holding US LargeCap Fund for 1 Year",'Interpreter','latex')
hold on
    plot(xlim, [0,0], 'k--')
hold off
legend("JPMorgan U.S. Research Enhanced Equity Fund", ...
    "BlackRock SP-500 Growth ETF fund",'','Interpreter','latex')

% small cap
GR3 = jpm_scap_r + 1;
sum_jpm_scap = movsum(log(GR3), [H-1 0], 'Endpoints', 'fill') ;
jpm_scap_annual= (exp(sum_jpm_scap)-1)*100;

GR4 = br_scap_r + 1;
sum_br_scap = movsum(log(GR4), [H-1 0], 'Endpoints', 'fill') ;
br_scap_annual= (exp(sum_br_scap)-1)*100;

subplot(2,2,2)
plot(matlabdate, [jpm_scap_annual, br_scap_annual],"LineWidth",2.0)
xlabel('Time','Interpreter','latex')
ylabel("Return",'Interpreter','latex')
datetick
title("Holding US SmallCap Fund for 1 Year",'Interpreter','latex')
hold on
    plot(xlim, [0,0], 'k--')
hold off
legend("JPMorgan Small Cap Equity Fund", ...
    "BlackRock Russell 2000 ETF fund",'','Interpreter','latex')

% nation
GR5 = jpm_eqincome_r + 1;
sum_jpm_eqincome = movsum(log(GR5), [H-1 0], 'Endpoints', 'fill') ;
jpm_eqincome_annual= (exp(sum_jpm_eqincome)-1)*100;

GR6 = br_china_r + 1;
sum_br_china = movsum(log(GR6), [H-1 0], 'Endpoints', 'fill') ;
br_china_annual= (exp(sum_br_china)-1)*100;

subplot(2,2,3)
plot(matlabdate, [jpm_eqincome_annual, br_china_annual],"LineWidth",2.0)
xlabel('Time','Interpreter','latex')
ylabel("Return",'Interpreter','latex')
datetick
title("Holding US/China Fund for 1 Year",'Interpreter','latex')
hold on
    plot(xlim, [0,0], 'k--')
hold off
legend("JPMorgan Equity Income Fund", ...
    "BlackRock MSCI China-ETF fund",'','Interpreter','latex')

% since we found jpm us-companies fund perform better than br's china ETF, we can plot the 
% JPM' s outperformacne with BR
figure
plot(matlabdate, (1+jpm_eqincome_annual)./(1+br_china_annual)-1,"LineWidth",2.0)
hold on
    plot(xlim, [0,0], 'k--')
hold off
legend('JPMorgan Equity Income Fund Outperformance','')
datetick

%% Monte Carlo simulation

Nsim = 100;
Tsim = 60;

jpm_lcap_value = ones(Tsim , Nsim);
br_lcap_value = ones(Tsim , Nsim);

jpm_scap_value = ones(Tsim , Nsim);
br_scap_value = ones(Tsim , Nsim);

jpm_eqincome_value = ones(Tsim , Nsim);
br_china_value = ones(Tsim , Nsim);

for n =1: Nsim
    for t = 2: Tsim
        draw = 1+ floor(rand*T);
        jpm_lcapret = jpm_lcap_r(draw);
        br_lcapret = br_lcap_r(draw);
        jpm_scapret = jpm_scap_r(draw);
        br_scapret = br_scap_r(draw);
        jpm_eqincomeret = jpm_eqincome_r(draw);
        br_chinaret = br_china_r(draw);

        jpm_lcap_value(t,n) = jpm_lcap_value(t-1,n) * (1+jpm_lcapret);
        br_lcap_value(t,n) = br_lcap_value(t-1,n) * (1+br_lcapret);
        jpm_scap_value(t,n) = jpm_scap_value(t-1,n) * (1+jpm_scapret);
        br_scap_value(t,n) = br_scap_value(t-1,n) * (1+br_scapret);
        jpm_eqincome_value(t,n) = jpm_eqincome_value(t-1,n) * (1+jpm_eqincomeret);
        br_china_value(t,n) = br_china_value(t-1,n) * (1+ br_chinaret);
    end
end

% figure
% plot(jpm_lcap_value(:,1:5))

figure
subplot(2,2,1)
title('Comparing simulation distributions by US LargeCap fund','Interpreter','latex')
ylabel('Fund values for every \$1 invested', 'Interpreter','latex')
xlabel('Months','Interpreter','latex')
grid on
hold on
    h1 = plot(mean(jpm_lcap_value,2),'b', "LineWidth",2.0); 
    plot(prctile(jpm_lcap_value,95,2),'b:', "LineWidth",2.0) 
    plot(prctile(jpm_lcap_value,5,2),'b:', "LineWidth",2.0) 
    h2 = plot(mean(br_lcap_value,2),'r', "LineWidth",2.0); 
    plot(prctile(br_lcap_value,95,2),'r:', "LineWidth",2.0)
    plot(prctile(br_lcap_value,5,2),'r:', "LineWidth",2.0)
hold off
legend([h1(1) h2(1)],'JPMorgan U.S. Research Enhanced Equity Fund', ...
    'BlackRock SP-500 Growth ETF fund','Interpreter','latex')


subplot(2,2,2)
title('Comparing simulation distributions by US SmallCap fund','Interpreter','latex')
ylabel('Fund values for every \$1 invested', 'Interpreter','latex')
xlabel('Months','Interpreter','latex')
grid on
hold on
    h3 = plot(mean(jpm_scap_value,2),'b', "LineWidth",2.0); 
    plot(prctile(jpm_scap_value,95,2),'b:', "LineWidth",2.0) 
    plot(prctile(jpm_scap_value,5,2),'b:', "LineWidth",2.0) 
    h4 = plot(mean(br_scap_value,2),'r', "LineWidth",2.0); 
    plot(prctile(br_scap_value,95,2),'r:', "LineWidth",2.0)
    plot(prctile(br_scap_value,5,2),'r:', "LineWidth",2.0)
hold off
legend([h3(1) h4(1)],'JPMorgan Small Cap Equity Fund', ...
    'BlackRock Russell 2000 ETF fund','Interpreter','latex')

subplot(2,2,3)
title('Comparing simulation distributions by investing US/Chinese Companies','Interpreter','latex')
ylabel('Fund values for every \$1 invested', 'Interpreter','latex')
xlabel('Months','Interpreter','latex')
grid on
hold on
    h5 = plot(mean(jpm_eqincome_value,2),'b', "LineWidth",2.0); 
    plot(prctile(jpm_eqincome_value,95,2),'b:', "LineWidth",2.0) 
    plot(prctile(jpm_eqincome_value,5,2),'b:', "LineWidth",2.0) 
    h6 = plot(mean(br_china_value,2),'r', "LineWidth",2.0); 
    plot(prctile(br_china_value,95,2),'r:', "LineWidth",2.0)
    plot(prctile(br_china_value,5,2),'r:', "LineWidth",2.0)
hold off
legend([h5(1) h6(1)],'JPMorgan Equity Income Fund', ...
    'BlackRock MSCI China-ETF fund','Interpreter','latex')

subplot(2,2,4)
title('Comparing simulation distributions of 6 funds','Interpreter','latex')
ylabel('Fund values for every \$1 invested', 'Interpreter','latex')
xlabel('Months','Interpreter','latex')
grid on
hold on
    plot(mean(jpm_lcap_value,2), "LineWidth",2.0); 
    plot(mean(jpm_scap_value,2), "LineWidth",2.0); 
    plot(mean(jpm_eqincome_value,2), "LineWidth",2.0); 
    plot(mean(br_lcap_value,2), "LineWidth",2.0); 
    plot(mean(br_scap_value,2), "LineWidth",2.0); 
    plot(mean(br_china_value,2), "LineWidth",2.0); 
hold off
legend("JPMorgan U.S. Research Enhanced Equity Fund", ...
    'JPMorgan Small Cap Equity Fund','JPMorgan Equity Income Fund', ...
    'BlackRock SP-500 Growth ETF fund','BlackRock Russell 2000 ETF fund', ...
    'BlackRock MSCI China-ETF fund','Interpreter','latex')

%% regression and performance evaluation

% extract excess return
jpm_lcap_exr = jpm_sp500grow(:,3)/100 - rf;
jpm_scap_exr = jpm_smallcap(:,3)/100 - rf;
jpm_eqincome_exr = jpm_eqincome(:,3)/100 -rf;

br_lcap_exr = br_sp500grow(:,3)/100 - rf;
br_scap_exr = br_smallcap(:,3)/100 -rf;
br_china_exr = br_china(:,3)/100 -rf;

% put all of them into a matrix

Allreturn_matrix = [jpm_lcap_exr, br_lcap_exr,jpm_scap_exr, br_scap_exr, ...
    jpm_eqincome_exr, br_china_exr];


%% Does Fund's average excess return statiscially different from the average return on the market?

null = mean(mkt_rf);
% H0: mu = 0.0109
% Ha: mu != 0.0109

t_crit = tinv(0.025, T-1);

t_stat = zeros(6,1);

for i = 1:6
    avg = mean(Allreturn_matrix(:,i));
    se = std(Allreturn_matrix(:,i)) / sqrt(T);
    t_stat(i,1) = (avg - null) / se;
end

% t_stat

%jpm_lcap_exr        -0.0329
%br_lcap_exr          0.3086
%jpm_scap_exr        -0.3330
%br_scap_exr         -0.3662
%jpm_eqincome_exr    -0.4827
%br_china_exr        -1.2963

% cannot reject H0, do not add value 

y = Allreturn_matrix;
X = [ones(T,1) mkt_rf smb hml];
[~, K] = size(X);

bhat = X\y;

%         jpm_lcap   br_lcap   jpm_scap   br_scap jpm_eqincome  br_china
%alpha    -0.0002    0.0006     -0.0007   -0.0015    0.0002     -0.0017
%beta     1.0031     1.0388     0.9569    1.0056     0.8475     0.5586
%s        -0.1074    -0.1987    0.4587    0.8481    -0.1240     0.1845
%h        0.0270     -0.2648    0.1614    0.1824     0.2694     -0.0006

% fitted value and uhat and R2
yhat = zeros(T,6);
uhat = zeros(T,6);
SSR = zeros(6,1);
dy = zeros(T,6);
SST = zeros(6,1);
R2 = zeros(6,1);
for i = 1:6
    yhat(:,i) = X*bhat(:,i);
    uhat(:,i) = y(:,i) - yhat(:,i);
    SSR(i,1) = uhat(:,i)'*uhat(:,i);
    dy(:,i) = y(:,i) - mean(y(:,i));
    SST(i,1) = dy(:,i)'*dy(:,i);
    R2(i,1) = 1-SSR(i,1)/SST(i,1);
end

%R2
%jpm_lcap     0.9871
%br_lcap      0.9717
%jpm_scap     0.9327
%br_scap      0.9883
%jpm_eqincome 0.9425
%br_china     0.1932

% jpm_lcap
varbhat_jpm_lcap =(X'*X)^(-1)*(X'*diag(uhat(:,1).^2)*X)*(X'*X)^(-1);

se_jpm_lcap =sqrt(diag(varbhat_jpm_lcap));

t_table_jpm_lcap = [bhat(:,1) (bhat(:,1) -0)./se_jpm_lcap]

% br_lcap
varbhat_br_lcap =(X'*X)^(-1)*(X'*diag(uhat(:,2).^2)*X)*(X'*X)^(-1);

se_br_lcap =sqrt(diag(varbhat_br_lcap));

t_table_br_lcap = [bhat(:,2) (bhat(:,2) -0)./se_br_lcap]


% jpm_scap
varbhat_jpm_scap =(X'*X)^(-1)*(X'*diag(uhat(:,3).^2)*X)*(X'*X)^(-1);

se_jpm_scap =sqrt(diag(varbhat_jpm_scap));

t_table_jpm_scap = [bhat(:,3) (bhat(:,3) -0)./se_jpm_scap]

% br_scap
varbhat_br_scap =(X'*X)^(-1)*(X'*diag(uhat(:,4).^2)*X)*(X'*X)^(-1);

se_br_scap =sqrt(diag(varbhat_br_scap));

t_table_br_scap = [bhat(:,4) (bhat(:,4) -0)./se_br_scap]

% jpm_eqincome
varbhat_jpm_eqincome =(X'*X)^(-1)*(X'*diag(uhat(:,5).^2)*X)*(X'*X)^(-1);

se_jpm_eqincome =sqrt(diag(varbhat_jpm_eqincome));

t_table_jpm_eqincome = [bhat(:,5) (bhat(:,5) -0)./se_jpm_eqincome]

% br_china
varbhat_br_china =(X'*X)^(-1)*(X'*diag(uhat(:,6).^2)*X)*(X'*X)^(-1);

se_br_china =sqrt(diag(varbhat_br_china));

t_table_br_china = [bhat(:,6) (bhat(:,6) -0)./se_br_china]

% since we have two fund have alpha, br_lcap and jpm_eqincome, we can
% compre it to mkt

% br_lcap
benchmark_br_lcap = rf*(1-bhat(2,2)) + bhat(2,2)*mkt + X(:,3:4)*bhat(3:4,2);

asset = [br_lcap_r benchmark_br_lcap mkt];

value_br_lcap = exp(cumsum(log(1+asset)));

figure
plot(matlabdate, value_br_lcap, "LineWidth",2.0)
legend('BlackRock SP-500 Growth ETF fund', 'Benchmark', 'Makret', 'Interpreter','latex')
title('Value of invested \$1','Interpreter','latex')
datetick

% jpm_eqincome
benchmark_jpm_eqincome = rf*(1-bhat(2,5)) + bhat(2,5)*mkt + X(:,3:4)*bhat(3:4,5);

asset = [jpm_eqincome_r benchmark_jpm_eqincome mkt];

value_jpm_eqincome = exp(cumsum(log(1+asset)));

figure
plot(matlabdate, value_jpm_eqincome, "LineWidth",2.0)
legend('JPMorgan Equity Income Fund', 'Benchmark', 'Makret', 'Interpreter','latex')
title('Value of invested \$1','Interpreter','latex')
datetick



