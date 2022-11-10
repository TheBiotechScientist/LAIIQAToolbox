pwd
cd('C:\Users\javne\Proyectos\LAIIQAToolbox')

datacell{1} = importdata('testfiles\4CF001_corrida2_500mL_13082021.mat');

datacell

datacell{2} = importdata('testfiles\4CF002_corrida1_500mL_01092021.mat');

length(datacell{1}(1,:))

time = 60;
datacell{1}(1,:) = datacell{1}(1,:)/time;
datacell{1} = datacell{1}(:,find(datacell{1}(1,:)==60/time):end);
datacell
datacell{1}(1,1:10)

datacell{1}(1,:) = datacell{1}(1,:)-datacell{1}(1,1);


[file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
file
for i = 1:length(file)
  datacell{i} = importdata(fullfile(pathfile, file{i}));
end

datacell

time = 60;

length(datacell)

for i=1:length(datacell)
    data = datacell;
    data{i}(1,:) = data{i}(1,:)/time;
    data{i} = data{i}(:,find(data{i}(1,:)==60/time):end);
    data{i} = data{i}(:,find(data{i}(2,:)==min(data{i}(2,1:find(data{i}(1,:)==10*60/time)))):end);
    data{i}(1,:) = data{i}(1,:)-data{i}(1,1);
    hold('on');
    plot(data{i}(1,:),data{i}(2,:));
    title("Cinética");
    xlabel("Tiempo (min)");
    ylabel("Concentración");
    grid('on');
    hold('off');
end


clear all
close all
clc

cin01 = laiiqatoolboxclass

cin01
cin01.openfiles


cin01

cin01.xlabel = 'h'
cin01.title = 'Hola';
