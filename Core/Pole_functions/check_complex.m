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
phi = -pi/2;

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

%% check ComplexPoleDelayConvRect - ok
y_anal = ComplexPoleDelayConvRect([a,omega,phi,t0,T],t);
y_num  = step*filter(exp1c,1,rect);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('ComplexPoleDelayConvRect')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

%% check ComplexPoleDelayConvRectConvExp - ok
y_anal=ComplexPoleDelayConvRectConvExp([a,omega,phi,t0,T,b],t);
y_num=step*filter(step*filter(exp1c,1,rect),1,exp2);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('ComplexPoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')


%% check ComplexPoleDelayConvRectConvExp a==b - ok
y_anal=ComplexPoleDelayConvRectConvExp([a,omega,phi,t0,T,a],t);
y_num=step*filter(step*filter(exp1c,1,rect),1,exp2a);

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('ComplexPoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

%% check ComplexPoleDelayConvRectConvExp b=0 - ok
y_anal=ComplexPoleDelayConvRectConvExp([a,omega,phi,t0,T,0],t);
y_num=step*filter(step*filter(exp1c,1,rect),1,ones(size(exp2)));

figure
subplot(211)
plot(t,y_anal,'r',t,y_num,'b')
legend('analitico','numerico')
title('ComplexPoleDelayConvRectConvExp')
subplot(212)
plot(t,y_anal-y_num,'b')
ylabel('differenza')

%%
close all