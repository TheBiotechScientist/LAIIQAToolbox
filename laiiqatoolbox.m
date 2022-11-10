classdef laiiqatoolbox
    %% LAIIQATOOLBOX script v0.1
    %   Autor: F. Javier Morales Mtz.
    %   05/11/2022
    %   Programa para dar tratamiento y graficar los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties (Access = public)
        rawdata;
        fixeddata;
        title = "Cinética de Ozonización";
        xlabel = 'min';
        ylabel = "Concentración [g/L]";
        grid = 'on';
        legend;
        legendFontSize = 8;
        legendLocation = 'best';
        Interpreter = 'tex';
        Resolution = 300;
    end

    properties (Access = private)
        plotfig;
        fig = figure('visible','off');
        ax = axes;
    end

    methods

        function obj = laiiqatoolbox()
        end

        function obj = openfiles(obj)
            clear obj.rawdata
            clear obj.fixeddata
            clear obj.legend
            clear file pathfile
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
                  obj.rawdata{i} = importdata(fullfile(pathfile, file{i}));
                    obj.legend{i} = erase(file{i},'.mat');
                    obj.legend{i} = string(obj.legend{i});
                    % obj.legend{i} = replace(lgnd{i},'_','-');
                end
            end
        end

        function obj = plotfiles(obj)
            obj.fixeddata = obj.rawdata;
            if obj.xlabel == 'min'
                t = 60;
            elseif obj.xlabel == 'h'
                t = 3600;
            elseif obj.xlabel == 'seg'
                t = 1;
            end
            obj.fig.Visible = 'on';% = figure;
            cla(obj.ax);
            obj.ax;% = axes;
            for i=1:length(obj.fixeddata)
                obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)/t;
                obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(1,:)==60/t):end);
                obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(2,:)==min(obj.fixeddata{i}(2,1:find(obj.fixeddata{i}(1,:)==10*60/t)))):end);
                obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)-obj.fixeddata{i}(1,1);
                hold(obj.ax,'on');
                obj.plotfig(i) = plot(obj.ax, obj.fixeddata{i}(1,:),obj.fixeddata{i}(2,:))
                title(obj.title);
                xlabel("Tiempo (" + obj.xlabel + ")");
                ylabel(obj.ylabel);
                grid(obj.grid);
                if isempty(obj.legend)
                else
                  legend(obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.Interpreter);
                end
                hold(obj.ax,'off');
            end
        end

        function obj = saveplot(obj,name)
            obj.fig;
            cla(obj.ax);
            obj.ax;% = axes; % Checar como limpiar la figura
            for i=1:length(obj.fixeddata)
                hold(obj.ax,'on');
                plot(obj.ax,obj.fixeddata{i}(1,:),obj.fixeddata{i}(2,:));
                title(obj.title);
                xlabel("Tiempo (" + obj.xlabel + ")");
                ylabel(obj.ylabel);
                grid(obj.grid);
                if isempty(obj.legend)
                else
                  legend(obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.Interpreter);
                end
                hold(obj.ax,'off');
            end
            if contains(name,'.pdf')
                exportgraphics(obj.fig,name,'ContentType','vector');
            elseif contains(name,'.png') | contains(name,'.jpg') | contains(name,'.jpeg')
                exportgraphics(obj.fig,name,'Resolution',obj.Resolution);
            elseif contains(name,'.fig')
                savefig(obj.fig,name);
            elseif contains(name,'.svg') | contains(name,'.eps')
                saveas(obj.fig,name)
            else
                disp("Especifica un formato válido: .png, .jpg, .jpeg, .pdf, .svg, .fig. Ejemp.: 'mifigura.pdf'");
            end
        end
    end
end
