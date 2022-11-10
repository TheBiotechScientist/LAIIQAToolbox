classdef laiiqatoolboxclass < handle
    %% LAIIQATOOLBOX script v0.1
    %   Autor: F. Javier Morales Mtz.
    %   05/11/2022
    %   Programa para dar tratamiento y graficar los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties
        datacell;
        datacutted;
        title = "Cinética de Ozonización";
        xlabel = 'min';
        ylabel = "Concentración [g/L]";
        grid = 'on';
        legend;
        legendFontSize = 8;
        legendLocation = 'best';
        Interpreter = 'tex';
        plotfig;

    end

    methods

        function obj = laiiqatoolboxclass()
        end

        function obj = openfiles(obj)
            clear datacell
            [file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
            if isequal(file,0)
                disp('No seleccionó ningun archivo.');
            else
                if length(string(file)) == 1
                  file = string(file);
                  obj.legend = file;
                else
                  obj.legend = file;
                end
                for i = 1:length(file)
                  obj.datacell{i} = importdata(fullfile(pathfile, file{i}));
                    obj.legend{i} = erase(file{i},'.mat');
                    obj.legend{i} = string(obj.legend{i});
                    % obj.legend{i} = replace(lgnd{i},'_','-');
                end
            end
        end

        function obj = plotfiles(obj)
            obj.datacutted = obj.datacell;
            if obj.xlabel == 'min'
                t = 60;
            elseif obj.xlabel == 'h'
                t = 3600;
            elseif obj.xlabel == 'seg'
                t = 1;
            end
            fig = figure;
            ax = axes;
            for i=1:length(obj.datacutted)
                obj.datacutted{i}(1,:) = obj.datacutted{i}(1,:)/t;
                obj.datacutted{i} = obj.datacutted{i}(:,find(obj.datacutted{i}(1,:)==60/t):end);
                obj.datacutted{i} = obj.datacutted{i}(:,find(obj.datacutted{i}(2,:)==min(obj.datacutted{i}(2,1:find(obj.datacutted{i}(1,:)==10*60/t)))):end);
                obj.datacutted{i}(1,:) = obj.datacutted{i}(1,:)-obj.datacutted{i}(1,1);
                hold(ax,'on');
                obj.plotfig = plot(ax, obj.datacutted{i}(1,:),obj.datacutted{i}(2,:))
                title(obj.title);
                xlabel("Tiempo (" + obj.xlabel + ")");
                ylabel(obj.ylabel);
                grid(obj.grid);
                if isempty(obj.legend)
                else
                  legend(obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.Interpreter);
                end
                hold(ax,'off');
            end
        end

        function obj = set(obj,title)
            obj.title = title;
            obj.plotfiles(obj);
        end
    end
end
