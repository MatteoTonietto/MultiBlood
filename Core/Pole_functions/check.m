%Check
clear all
clc
% time
step = 0.001;
t = [0:step:20]';

% rect
T = 2;
rect = zeros(size(t));
rect(t<=T)=1;

% exp1
a = 0.1;
t0 = 1;
omega = 2*pi;
phi = pi/2;

exp1 = exp(-a*(t-t0));
exp1(t<=t0)=0;

exp1d = (t-t0).*exp(-a*(t-t0));
exp1d(t<=t0)=0;

exp1c = exp(-a*(t-t0)).*sin(omega*(t-t0)+phi);  
exp1c(t<=t0)=0;

% exp2
b = 0.01;
% exp2 = exp(-b*(t-t0));
exp2 = exp(-b*t);

exp2a = exp(-a*t);


%% check SimplePoleDelayConvRect
% analytical convolution:   ok 
% analytical Jacobian:      ok

[y_anal,J_anal] = SimplePoleDelayConvRect([a,t0,T],t);
y_num           = step*filter(exp1,1,rect);

fun             = @(c) SimplePoleDelayConvRect([c(1),c(2),c(3)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('SimplePoleDelayConvRect')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')


figure
for i = 1 : 3
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['SimplePoleDelayConvRect - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end

%% check SimplePoleDelayConvRectConvExp
% analytical convolution:   ok 
% analytical Jacobian:      ok 
[y_anal,J_anal] = SimplePoleDelayConvRectConvExp([a,t0,T,b],t);
y_num           = step*filter(step*filter(exp1,1,rect),1,exp2);

fun             = @(c) SimplePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,b]);


figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('SimplePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['SimplePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end


%% check SimplePoleDelayConvRectConvExp a==b
% analytical convolution:   ok 
% analytical Jacobian:      ok
[y_anal,J_anal] = SimplePoleDelayConvRectConvExp([a,t0,T,a],t);
y_num           = step*filter(step*filter(exp1,1,rect),1,exp2a);

fun             = @(c) SimplePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,a]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('SimplePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['SimplePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end


%% check SimplePoleDelayConvRectConvExp b=0
% analytical convolution:   ok 
% analytical Jacobian:      ok 
[y_anal,J_anal] = SimplePoleDelayConvRectConvExp([a,t0,T,0],t);
y_num           = step*filter(step*filter(exp1,1,rect),1,ones(size(exp2)));

fun             = @(c) SimplePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,0]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('SimplePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['SimplePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end

%% check DoublePoleDelayConvRect
% analytical convolution:   ok 
% analytical Jacobian:      ok 
[y_anal,J_anal] = DoublePoleDelayConvRect([a,t0,T],t);
y_num           = step*filter(exp1d,1,rect);

fun             = @(c) DoublePoleDelayConvRect([c(1),c(2),c(3)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('DoublePoleDelayConvRect')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 3
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['DoublePoleDelayConvRect - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end
%% check DoublePoleDelayConvRectConvExp
% analytical convolution:   ok 
% analytical Jacobian:      ok 
[y_anal,J_anal] = DoublePoleDelayConvRectConvExp([a,t0,T,b],t);
y_num           = step*filter(step*filter(exp1d,1,rect),1,exp2);

fun             = @(c) DoublePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,b]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('DoublePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['DoublePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end

%% check DoublePoleDelayConvRectConvExp a==b
% analytical convolution:   ok 
% analytical Jacobian:      ok 
[y_anal,J_anal] = DoublePoleDelayConvRectConvExp([a,t0,T,a],t);
y_num           = step*filter(step*filter(exp1d,1,rect),1,exp2a);

fun             = @(c) DoublePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,a]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('DoublePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['DoublePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end

%% check DoublePoleDelayConvRectConvExp b=0
% analytical convolution:   ok 
% analytical Jacobian:      ok    
[y_anal,J_anal] = DoublePoleDelayConvRectConvExp([a,t0,T,0],t);
y_num           = step*filter(step*filter(exp1d,1,rect),1,ones(size(exp2)));


fun             = @(c) DoublePoleDelayConvRectConvExp([c(1),c(2),c(3),c(4)],t);
[J_num,err]     = jacobianest(fun,[a,t0,T,0]);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('DoublePoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

figure
for i = 1 : 4
    subplot(211)
    plot(t,J_anal(:,i),'r',t,J_num(:,i),'b')
    legend('analitico','numerico')
    title(['DoublePoleDelayConvRectConvExp - Jac par ', num2str(i)])
    subplot(212)
    plot(t,J_anal(:,i)-J_num(:,i),'b')
    ylabel('differenza')
    pause
end


%% check SimplePoleDelayConvRectInt - ok

delta = [ ...
    0.5 * ones(3,1); ...
    1   * ones(3,1); ...
    2   * ones(3,1); ...
    5   * ones(3,1); ...
    10  * ones(3,1); ...
    15  * ones(3,1); ...
    ];

t2 = cumsum(delta);
t1 = t2 - delta;

for i = 1 : length(delta)
    y_anal(i) = SimplePoleDelayConvRectInt([a,t0,T],t1(i),t2(i));
    y_num(i)  = integral(@(x)SimplePoleDelayConvRect([a,t0,T],x),t1(i),t2(i))/(t2(i)-t1(i));
end

tmid = t1 + delta(2);

figure
subplot(211)
plot(tmid,y_anal,'r',tmid,y_num,'ob')
legend('analitico','numerico')
title('SimplePoleDelayConvRectInt')
subplot(212)
plot(tmid,y_anal-y_num,'b')
ylabel('differenza')

%% check DoublePoleDelayConvRectInt - ok

delta = [ ...
    0.5 * ones(3,1); ...
    1   * ones(3,1); ...
    2   * ones(3,1); ...
    5   * ones(3,1); ...
    10  * ones(3,1); ...
    15  * ones(3,1); ...
    ];

t2 = cumsum(delta);
t1 = t2 - delta;

for i = 1 : length(delta)
    y_anal(i) = DoublePoleDelayConvRectInt([a,t0,T],t1(i),t2(i));
    y_num(i)  = integral(@(x)DoublePoleDelayConvRect([a,t0,T],x),t1(i),t2(i))/(t2(i)-t1(i));
end

tmid = t1 + delta(2);

figure
subplot(211)
plot(tmid,y_anal,'r',tmid,y_num,'ob')
legend('analitico','numerico')
title('DoublePoleDelayConvRectInt')
subplot(212)
plot(tmid,y_anal-y_num,'b')
ylabel('differenza')

