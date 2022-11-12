classdef laiiqatoolbox < handle
    %% LAIIQATOOLBOX script v1.1
    %   Autor: F. Javier Morales Mtz.
    %   05/11/2022
    %   Programa para ajustar y graficar los datos de los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties (Access = public)
        rawdata;
        fixeddata;
        title; % = "Cinética de Ozonización";
        titleInterpreter;
        xlabel; % = 'min';
        ylabel; % = "Concentración [g/L]";
        labelInterpreter;
        grid; % = 'on';
        LineWidth; % = 0.5;
        legend; % = '';
        legendFontSize; % = 8;
        legendLocation; % = 'best';
        legendInterpreter; % = 'tex';
        imageResolution; % = 300;
        ozoneresults;
        ozoneUnits;
    end

    properties (Access = private)
        fig;% = figure('visible','off');
        ax;% = axes;
        file;
    end

    methods

        function obj = laiiqatoolbox()
            obj.fig = figure('Visible', 'off');
            obj.ax = axes;
            obj.title = "Cinética de Ozonización";
            obj.titleInterpreter = 'tex';
            obj.xlabel = 'min';
            obj.ylabel = "Concentración [g/L]";
            obj.labelInterpreter = 'tex';
            obj.grid = 'on';
            obj.LineWidth = 0.5;
            obj.legend = {};
            obj.legendFontSize = 8;
            obj.legendLocation = 'best';
            obj.legendInterpreter = 'tex';
            obj.imageResolution = 300;
            obj.ozoneUnits = 'g/L';
        end

        function obj = openfiles(obj)
            clear obj.rawdata
            clear obj.fixeddata
            clear obj.legend
            clear obj.file pathfile
            clear obj.ozoneresults
            [obj.file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
            if isequal(obj.file,0)
                disp('No seleccionó ningun archivo.');
            else
                if length(string(obj.file)) == 1
                  obj.file = string(obj.file);
                  obj.legend{1} = erase(obj.file,".mat");
                else
                    for i=1:length(obj.file)
                        obj.legend{i} = erase(obj.file{i},'.mat');
                        obj.legend{i} = string(obj.legend{i});
                    end
                end
                if isequal(obj.legendInterpreter,'latex')
                    for i=1:length(obj.legend)
                        obj.legend{i} = "$"+obj.legend{i}+"$";
                    end
                end
                for i = 1:length(obj.file)
                  obj.rawdata{i} = importdata(fullfile(pathfile, obj.file{i}));
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
            obj.fig.Visible = 'on';
            obj.ax; % = axes;
            cla(obj.ax);
            hold(obj.ax,'on');
            for i=1:length(obj.fixeddata)
                obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)/t;
                obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(1,:)==60/t):end);
                obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(2,:)==min(obj.fixeddata{i}(2,1:find(obj.fixeddata{i}(1,:)==10*60/t)))):end);
                obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)-obj.fixeddata{i}(1,1);
                plot(obj.ax, obj.fixeddata{i}(1,:),obj.fixeddata{i}(2,:), 'LineWidth', obj.LineWidth);
            end
            hold(obj.ax,'off');
            title(obj.title, 'Interpreter', obj.titleInterpreter);
            xlabel("Tiempo (" + obj.xlabel + ")",'Interpreter',obj.labelInterpreter);
            ylabel(obj.ylabel,'Interpreter',obj.labelInterpreter);
            grid(obj.grid);
            if isempty(obj.legend)
                legend(obj.ax,'off');
            else
                legend(obj.ax,'on');
                legend(obj.ax,obj.legend, 'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
            end
        end

        function obj = saveplot(obj,name)
            obj.fig;
            cla(obj.ax);
            obj.ax;% = axes; % Checar como limpiar la figura
            hold(obj.ax,'on');
            for i=1:length(obj.fixeddata)
                plot(obj.ax,obj.fixeddata{i}(1,:),obj.fixeddata{i}(2,:));
            end
            hold(obj.ax,'off');
            title(obj.title, 'Interpreter', obj.titleInterpreter);
            xlabel("Tiempo (" + obj.xlabel + ")", 'Interpreter', obj.labelInterpreter);
            ylabel(obj.ylabel,'Interpreter', obj.labelInterpreter);
            grid(obj.grid);
            if isempty(obj.legend)
                legend(obj.ax,'off');
            else
                legend(obj.ax,'on');
                legend(obj.ax,obj.legend, 'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
            end
            if contains(name,'.pdf')
                exportgraphics(obj.fig,name,'ContentType','vector');
            elseif contains(name,'.png') | contains(name,'.jpg') | contains(name,'.jpeg')
                exportgraphics(obj.fig,name,'Resolution',obj.imageResolution);
            elseif contains(name,'.fig')
                savefig(obj.fig,name);
            elseif contains(name,'.svg') | contains(name,'.eps') | contains(name,'.tif')
                saveas(obj.fig,name)
            else
                disp("Especifica un formato válido: .png, .jpg, .jpeg, .pdf, .eps, .tif, .svg, .fig. Ejemplo: 'mifigura.pdf'");
            end
        end

        function obj = ozonecalc(obj)
            if isempty(obj.fixeddata)
                disp('Variable fixeddata vacía. Ejecute plotfiles primero');
            else
                ozonevars = ["Consumido","Residual","Total"];
                if isequal(obj.ozoneUnits,'g/L')
                    u = 1000;
                elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                    u = 1;
                else
                    u = 0;
                end
                if isequal(u,0)
                    disp('Unidades incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    for i=1:length(obj.fixeddata)
                        residual = trapz(obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:))/u;
                        consumed = (max(obj.fixeddata{i}(1,:))*max(obj.fixeddata{i}(2,:)))/u - residual;
                        total = residual + consumed;
                        var(1) = residual;
                        var(2) = consumed;
                        var(3) = total;
                        disp("Para " + obj.file{i} + ":");
                        for j=1:length(ozonevars)
                          disp("    " + ozonevars(j) + ": " + var(j) + obj.ozoneUnits);
                          obj.ozoneresults{i,j} = {ozonevars(j), var(j)};
                        end
                        disp(newline);
                    end
                end
            end
        end
    end
end
