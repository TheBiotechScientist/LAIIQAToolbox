classdef laiiqatoolbox < handle
    %LAIIQATOOLBOX Summary of this class goes here
    %   Detailed explanation goes here

    properties
        data;
        x0 = 1;
        title = 'Cinética de Ozonización';
        xlabel = 'Tiempo (min)';
        ylabel = 'Concentración [g/L]';
        xlim = [0 90];
        ylim = [0 35];
        fig;
    end

    methods
        function obj = laiiqatoolbox()
        end
        
        function obj = openfile(obj)
            [file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
            if isequal(file,0)
                disp('No se ha seleccionado ningun archivo.')
            else
                for i = 1:length(file)
                    obj.data{i} = importdata(fullfile(pathfile, file{i}));
                    obj.fig(i) = figure(i);
                    obj.fig(i) = plot(obj.data{i}(1,:),obj.data{i}(2,:));
                    hold on
                    obj.fig(i)
                    hold off
                end
            end
        end
    end
end
