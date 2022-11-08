% clear all
% close all
% clc

c4cf1 = importdata('testfiles\4CF001_corrida2_500mL_13082021.mat');
c4cf2 = importdata('testfiles\4CF002_corrida1_500mL_01092021.mat');
c4cf3 = importdata('testfiles\4CF003_corrida1_500mL_03092021.mat');

c4cf1x = c4cf1(1,find(c4cf1==0);

hold on
plot(c4cf1(1,6000:end),c4cf1(2,6000:end));
plot(c4cf2(1,:),c4cf2(2,:));
plot(c4cf3(1,:),c4cf3(2,:));
legend('c1','c2','c3');
title('Cinética de Ozonización');
xlabel('Tiempo (min)');
ylabel('Concentración [g/L]');
hold off