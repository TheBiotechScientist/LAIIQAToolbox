%% LAIIQAToolboox
% Programa para graficar los archivos de la ozonización
% desde un tiempo de concentración inicial cercano a cero.
% Autor: F. Javier Morales Mtz.
% 05/11/2022

%%
close all
clear all
clc

%% === Titulo del gráfico
titulo = 'Cinética de Ozonización';

%% === Selección del tiempo en el eje X:
ejex = 'min'; % Opiones: 'min', 'h', 'seg'

%% === Etiqueta eje Y:
labelY = 'Concentración [g/L]';

%% === Leyenda de los datos (comentar para quitar leyendas):
leyendas = {''}; % ejem: {'data1', 'data2', 'data3', etc...}

%% === Rejillas: 'on' , 'off'
gridonoff = 'on';


%% === Seleccionamos los archivos a graficar:
[file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
if isempty(file)
    disp("No se seleccionaron archivos");
else
    if length(string(file)) == 1
        file = string(file);
    end
    % === Damos formato a los archivos:
    for i=1:length(file)
        % === Asignamos los archivos a graficar a una variable:
        data = importdata(fullfile(pathfile, file{i}));
        if ejex == 'min'
            time = 60;
        elseif ejex == 'h'
            time = 3600;
        elseif ejex == 'seg'
            time = 1;
        end
        data(1,:) = data(1,:)/time;
        data = data(:,find(data(1,:)==60/time):end);
        data = data(:,find(data(2,:)==min(data(2,1:find(data(1,:)==10*60/time)))):end);
        data(1,:) = data(1,:)-data(1,1);
        tiempo = data(1,:);
        conc = data(2,:);
        hold on
        plot(tiempo,conc);
        if exist('titulo', 'var')
            title(titulo);
        else
        end
        xlabel("Tiempo ("+ ejex + ")");
        ylabel(labelY);
        % xlim([0 90])
        % ylim([0 35])
        if exist('leyendas','var')
            if isempty(leyendas)
                legend();
            elseif leyendas{1} == ''
                legend(leyendas);
            end
        else
        end
        grid(gridonoff);
        hold off;
    end
end
