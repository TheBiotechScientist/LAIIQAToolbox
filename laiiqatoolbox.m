classdef laiiqatoolbox < handle
    %% LAIIQATOOLBOX script v1.2.0.0
    %   Autor: F. Javier Morales Mtz.
    %   05/11/2022
    %   Matlab toolbox para ajustar y graficar los datos de los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties (Access = public)
        rawdata;
        fixeddata;
        title; % = "Cinética de Ozonización";
        xlabel; % = 'min';
        xf; % valor de x final
        xk; % multiplicador para x
        ylabel; % = "Concentración [g/L]";
        grid; % = 'on';
        LineWidth; % = 0.5;
        legend; % = '';
        legendFontSize; % = 8;
        legendLocation; % = 'best';
        imageResolution; % = 300;
        titleInterpreter; % = 'tex';
        labelInterpreter; % = 'tex';
        legendInterpreter; % = 'tex';
        ozoneUnits; % = 'g/L';
        ozoneresults;
    end

    properties (Access = private)
        fig;% = figure('visible','off');
        ax;% = axes;
        file;
        defaultlegend;
    end

    methods

        function obj = laiiqatoolbox()
            obj.fig = figure('Visible', 'off');
            obj.ax = axes;
            obj.title = "Cinética de Ozonización";
            obj.xlabel = 'min';
            obj.xf = {'end'};
            obj.xk = {1};
            obj.ylabel = "Concentración [g/L]";
            obj.grid = 'on';
            obj.LineWidth = 0.5;
            obj.legend = {'default'};
            obj.legendFontSize = 8;
            obj.legendLocation = 'best';
            obj.imageResolution = 300;
            obj.defaultlegend = {};
            obj.titleInterpreter = 'tex';
            obj.labelInterpreter = 'tex';
            obj.legendInterpreter = 'tex';
            obj.ozoneUnits = 'g/L';
        end

        function obj = openfiles(obj)
            clear obj.rawdata
            clear obj.fixeddata
            clear obj.legend
            clear obj.file
            clear pathfile
            clear obj.ozoneresults
            clear onj.defaultlegend

            [obj.file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');

            if isequal(obj.file,0)
                disp('No se seleccionó ningun archivo.');
            else
                if length(string(obj.file)) == 1
                  % obj.file = string(obj.file);
                  obj.defaultlegend{1} = string(erase(obj.file,".mat"));
                  % obj.xf{1} = 'end';
                elseif length(string(obj.file)) > 1
                    for i=1:length(obj.file)
                        % obj.file = string(obj.file);
                        obj.defaultlegend{i} = string(erase(obj.file{i},".mat"));
                        % obj.defaultlegend{i} = string(obj.defaultlegend{i});
                        obj.xf{i} = 'end';
                        obj.xk{i} = 1;
                    end
                end
                if isequal(obj.legendInterpreter,'latex')
                    for i=1:length(obj.defaultlegend)
                        obj.defaultlegend{i} = "$"+obj.defaultlegend{i}+"$";
                    end
                end
                for i=1:length(obj.file)
                  obj.rawdata{i} = importdata(fullfile(pathfile, obj.file{i}));
                    % obj.legend{i} = replace(lgnd{i},'_','-');
                end
            end
        end

        function obj = plotfiles(obj)
            obj.fixeddata = obj.rawdata;
            if isempty(obj.fixeddata)
                disp("No se han cargado archivos para graficar. Ejecute openfiles primero.");
            else
                if obj.xlabel == 'min'
                    t = 60;
                elseif obj.xlabel == 'h'
                    t = 3600;
                elseif obj.xlabel == 'seg'
                    t = 1;
                end

                if isequal(obj.legend,{'default'}) | isequal(obj.legend,obj.defaultlegend)
                    obj.legend = obj.defaultlegend;
                end
                obj.fig.Visible = 'on';
                cla(obj.ax);
                obj.ax; % = axes;
                hold(obj.ax,'on');
                for i=1:length(obj.fixeddata)
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)/t;
                    obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(1,:)==60/t):end);
                    obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(2,:)==min(obj.fixeddata{i}(2,1:find(obj.fixeddata{i}(1,:)==10*60/t)))):end);
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)*obj.xk{i};
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)-obj.fixeddata{i}(1,1);
                    obj.fixeddata{i}(1,:) = round(obj.fixeddata{i}(1,:),4);
                    if isequal(obj.xf{i},'end')
                        obj.fixeddata{i} = obj.fixeddata{i}(:,1:end);
                    else
                        obj.fixeddata{i} = obj.fixeddata{i}(:,1:find(obj.fixeddata{i}(1,:)==obj.xf{i}));
                    end
                    plot(obj.ax, obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:), 'LineWidth', obj.LineWidth);
                end
                title(obj.ax,obj.title, 'Interpreter', obj.titleInterpreter);
                xlabel(obj.ax,"Tiempo (" + obj.xlabel + ")",'Interpreter',obj.labelInterpreter);
                ylabel(obj.ax,obj.ylabel,'Interpreter',obj.labelInterpreter);
                grid(obj.ax,obj.grid);
                if isempty(obj.legend)
                    legend(obj.ax,'off');
                else
                    legend(obj.ax,'on');
                    legend(obj.ax,obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
                end
                hold(obj.ax,'off');
            end
        end

        function obj = saveplot(obj,name)
            cla(obj.ax, 'reset');
            obj.ax;
            hold(obj.ax,'on');
            for i=1:length(obj.fixeddata)
                plot(obj.ax,obj.fixeddata{i}(1,:),obj.fixeddata{i}(2,:));
            end
            title(obj.ax,obj.title, 'Interpreter', obj.titleInterpreter);
            xlabel(obj.ax,"Tiempo (" + obj.xlabel + ")", 'Interpreter', obj.labelInterpreter);
            ylabel(obj.ax,obj.ylabel,'Interpreter', obj.labelInterpreter);
            grid(obj.ax,obj.grid);
            if isempty(obj.legend)
                legend(obj.ax,'off');
            else
                legend(obj.ax,'on');
                legend(obj.ax,obj.legend, 'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
            end
            hold(obj.ax,'off');
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
                disp('Variable fixeddata vacía. Ejecute plotfiles primero.');
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
                        if obj.xlabel == 'h'
                            var(1) = consumed*60;
                            var(2) = residual*60;
                            var(3) = total*60;
                        elseif obj.xlabel == 'seg'
                            var(1) = consumed/60;
                            var(2) = residual/60;
                            var(3) = total/60;
                        else
                            var(1) = consumed;
                            var(2) = residual;
                            var(3) = total;
                        end
                        if isequal(obj.legend,{'default'}) | isempty(obj.legend) | length(obj.legend)<length(obj.fixeddata)
                            disp("Para " + obj.defaultlegend{i} + ":");
                        else
                            disp("Para " + obj.legend{i} + ":");
                        end
                        for j=1:2
                            disp("    " + ozonevars(j) + ": " + var(j) + " " + string(obj.ozoneUnits));
                            obj.ozoneresults{i,j} = {ozonevars(j), var(j)};
                        end
                        disp("    " + ozonevars(3) + ": " + var(3) + " " + string(obj.ozoneUnits) + " en " + max(obj.fixeddata{i}(1,:)) + " " + obj.xlabel);
                        obj.ozoneresults{i,3} = {ozonevars(3), var(3)};
                        disp(newline);
                    end
                end
            end
        end
    end
end
