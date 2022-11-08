close all
clear all
clc

% === Cargamos los archivos a Graficar:
data1 = importdata('4CF001_corrida2_500mL_13082021.mat');
data2 = importdata('4CF002_corrida1_500mL_01092021.mat');
data3 = importdata('4CF003_corrida1_500mL_03092021.mat');

% === Convertimos el timepo de segundos a minutos:
data1(1,:) = data1(1,:)/60;
data2(1,:) = data2(1,:)/60;
data3(1,:) = data3(1,:)/60;
% data3(1,:) = data3(1,:)/3600; % Para convertir a horas

% ==== Eleiminamos los primeros valores hasta el minuto 1:
data1 = data1(:,find(data1(1,:)==1):end);
data2 = data2(:,find(data2(1,:)==1):end);
data3 = data3(:,find(data3(1,:)==1):end);

% === Encontramos el punto de concentración incial cercano
% a cero en los primeros 10 minutos:
data1 = data1(:,find(data1(2,:)==min(data1(2,1:find(data1(1,:)==10)))):end);
data2 = data2(:,find(data2(2,:)==min(data2(2,1:find(data2(1,:)==10)))):end);
data3 = data3(:,find(data3(2,:)==min(data3(2,1:find(data3(1,:)==10)))):end);

% === Restamos el tiempo sobrante para recorrer el gráfico
% a 0 en el eje x:
data1(1,:) = data1(1,:)-data1(1,1);
data2(1,:) = data2(1,:)-data2(1,1);
data3(1,:) = data3(1,:)-data3(1,1);

% === Definimos variables de tiempo y conc:
tiempo1 = data1(1,:);
conc1 = data1(2,:);

tiempo2 = data2(1,:);
conc2 = data2(2,:);

tiempo3 = data3(1,:);
conc3 = data3(2,:);

% === Unimos las gráficas en una sola:
hold on
plot(tiempo1,conc1);
plot(tiempo2,conc2);
plot(tiempo3,conc3);
title('Cinética de Ozonización')
xlabel('Tiempo (min)')
ylabel('Concentración [g/L]')
% xlim([0 90])
% ylim([0 35])
% legend('linea1','linea2','4CF-60min')
grid('on')
hold off