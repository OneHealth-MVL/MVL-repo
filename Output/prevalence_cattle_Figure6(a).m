b = 1.6; 
b1 = 4*10^-5;
b2 = 3*10^-5;
d1 = 5*10^-6;
d2 = 4*10^-6;
a = 0.01;
m = 0.00055;
u1 = 0.011;
u2 = 0.013;
gamma1 = 4;
gamma2 = 4;
w1 = 0.11;
w2 = 0.09; 
c = 100;
g1 = 0.6;
g2 = 0.6;
r = 0.9;
sigma1 = 0.25;
sigma2 = 0.25;
eta = 0.15;
p_values = 0.05:0.01:0.90; 
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-5 1e-4 1e-5 1e-4 1e-4]);
format longG
mean_preval1 =zeros(size(p_values));
mean_preval2 =zeros(size(p_values));
max_preval1 =zeros(size(p_values));
min_preval1 =zeros(size(p_values));
max_preval2 =zeros(size(p_values));
min_preval2 =zeros(size(p_values));
for i = 1:length(p_values)
    p = p_values(i); % set p to the current value
    % update parameters with new p values
    par=[b,b1,b2,d1,d2,a,m,u1,u2,gamma1,gamma2,w1,w2,c,p,g1, g2,r,sigma1, sigma2,eta];
    % solve the ODEs as before
    [T,Y] = ode45(@SIRSprevalence,[0 TS],[2985 10 5 0 2 1],options,par);
    % compute total prevalence and its mean
    preval1=100*Y(:,2)./(Y(:,1)+Y(:,2)+Y(:,3)+Y(:,4));
    preval2=100*Y(:,3)./(Y(:,1)+Y(:,2)+Y(:,3)+Y(:,4));
    mean_preval1(i)=mean(preval1);
    mean_preval2(i)=mean(preval2);
    max_preval1(i) = max(preval1);
    min_preval1(i) = min(preval1);
    max_preval2(i) = max(preval2);
    min_preval2(i) = min(preval2);
end
figure;
plot(p_values, max_preval1, 'b--', p_values, min_preval1, 'b:' , p_values, mean_preval1,'b', ...
     p_values, max_preval2, 'r--', p_values, min_preval2,'r:' , p_values, mean_preval2,'r' );
xlabel('rate of drug resistance development (\rho)', 'FontWeight', 'bold');
ylabel('Prevalence in cattel (%)', 'FontWeight', 'bold');
legend('Max drug susceptible prevalence', 'Min drug susceptible prevalence', 'Mean drug susceptible prevalence', ...
       'Max drug resistant prevalence', 'Min drug resistant prevalence', 'Mean drug resistant prevalence', 'Location', 'best');

