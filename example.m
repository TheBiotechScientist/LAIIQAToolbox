disp('hola mundo');
pwd
% cd('C:\Users\javne\Proyectos\LAIIQAToolbox')


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



clear all
close all
clc

[file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
file
clear lgnd

for i=1:length(file)
  lgnd{i} = erase(file{i},'.mat');
  lgnd{i} = replace(lgnd{i},'_','-');
end
lgnd

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




nameoffig = 'myfig.pdf'


string(nameoffig)

contains(nameoffig,'.pdf')




clear all
close all
clc
pwd
%% ====== Utilizando Programación Orientada a Objetos:
clear cin01
cin01 = laiiqatoolboxclass

cin01.openfiles

cin01.plotfiles

lgnd = cin01.legend
for i=1:length(lgnd)
  lgnd{i} = erase(lgnd{i},'.mat');
  lgnd{i} = replace(lgnd{i},'_','-')
end

lgnd

cin01.legend = lgnd

cin01.title = 'Cinética de Ozonización'
cin01.xlabel = 'min'


lgnd = ''
isempty(lgnd)
if lgnd == ''
  disp('Vacío')
else
  disp('No vacío')
end



% Sincronización Pointer 2001 WolksVagen 1.6L 4Cil
