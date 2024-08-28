%   
%                  SIR_dram3.m
%

  clear all
  close all
clc

%GitHub page: https://github.com/mjlaine/mcmcstat/tree/master 
%SIR Codes:  https://rsmith.math.ncsu.edu/RTG_BIOMATH18/
  global N Y0

%
%  Load data which consists of 61 points of infectious data.
%

 %load mrsa19 % load SIR_data
 %load MRSA_19_Gold_4
 num_infected = [
2
2 
1
2
3
2 
3 
0
4
5 
2 
1];

%
% Set parameters and initial conditions
%

  S0 = 237;
  I0 = 1;
  R0 = 0;
  N = 238;

  gamma = 0.0040;
  r = 0.6;
  delta = 0.15;
  params = [gamma r delta];

  tf = length(num_infected)-1;%6;
  dt = 1;
  t_vals = 0:dt:tf;
  Y0 = [S0; I0];

  xgamma = datastats(gamma);

xdelta = datastats(delta);

xr = datastats(r);
%
% Define the standard deviation sigma for the measurement error.
%

  sigma = 0.1*500;

%
% Integrate the system using ode45.m.  We exploit the fact that R(t) = N - S(t) - I(t).
%

  ode_options = odeset('RelTol',1e-6);
  [t,Y] = ode45(@SIR_rhs3,t_vals,Y0,ode_options,params);
  Y(:,3) = N - Y(:,1) - Y(:,2);

%
% Plot the results.
%

  figure(1)
  plot(t,Y(:,2),t,num_infected,'x','linewidth',3)
  set(gca,'Fontsize',[22]);
  xlabel('Time')
  ylabel('Number of Infectious')

%
% Cosntruct chains, marginal, and joint densities using DRAM.
%

  clear model options

  data.xdata = t_vals';
  data.ydata = num_infected;

  pmin = [.022 .63 .16];
  params = {
     {'gamma',pmin(1),0,1}
     {'r',pmin(2),0,1}
     {'delta',pmin(3),0,1}};

  model.ssfun = @SIRss3;
  model.sigma2 = sigma^2;
  options.nsimu = 1e+4;
  options.updatesigma = 1;

  [results,chain,s2chain] = mcmcrun(model,data,params,options);

%
% Plot the chains, pairwise densities and marginal densities.
%

  figure(2); clf
 % mcmcplot(chain,[],results,'chainpanel');

   gamma = chain(:,1);
  r = chain(:,2);
  delta = chain(:,3);

  figure(2)
  subplot(2,2,1)
  plot(gamma,'-')
  set(gca,'Fontsize',[20]);
  xlabel('Chain Iteration')
  ylabel('Parameter \gamma')
  subplot(2,2,2)
  plot(r,'-')
  set(gca,'Fontsize',[20]);
  xlabel('Chain Iteration')
  ylabel('Parameter r')
  subplot(2,2,3)
  plot(delta,'-')
  set(gca,'Fontsize',[20]);
  xlabel('Chain Iteration')
  ylabel('Parameter \delta')

  
  figure(3); clf
  mcmcplot(chain,[],results,'pairs');

  figure(4); clf
  mcmcplot(chain,[],results,'denspanel',1);

% 
% Construct and plot predictions intervals
%

  t = linspace(0,length(num_infected)-1)';
  out = mcmcpred(results,chain,s2chain,t,@SIR_fun3,1000)
  mcmcpredplot_custom(out);

  figure(6)
  hold on
  plot(t_vals,num_infected,'x','linewidth',3)
  hold off 
  set(gca,'Fontsize',[22]);
  xlabel('Time')
  ylabel('Infection Data and Prediction Interval') 
  
  
  
