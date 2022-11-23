classdef laiiqatoolbox < handle
    %% LAIIQATOOLBOX script v1.3.6
    %   Autor: F. Javier Morales Mtz.
    %   05/11/2022
    %   Matlab toolbox para ajustar y graficar los datos de los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties (Access = public)
        rawdata;
        fixeddata;
        fixedtitle; % = "Cinética de Ozonización";
        ozonetitle;
        ozoneUnits; % = 'g/L';
        xlabel; % = 'min';
        xk; % multiplicador para x
        xf; % valor de x final
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
        ozoneresults;
    end

    properties (Access = private)
        fixedfig;% = figure('visible','off');
        fixedax;% = axes;
        ozonefig;
        ozoneax;
        file;
        defaultlegend;
    end

    methods

        function obj = laiiqatoolbox()
            obj.fixedfig = figure('Visible', 'off');
            obj.fixedax = axes('Parent',obj.fixedfig);
            obj.ozonefig = figure('Visible','off');
            obj.ozoneax = axes('Parent',obj.ozonefig);
            obj.fixedtitle = "Cinética de Ozonización";
            obj.ozonetitle = "Consumo de Ozono";
            obj.ozoneUnits = 'g/L';
            obj.xlabel = 'min';
            obj.xk = {1};
            obj.xf = {'end'};
            obj.ylabel = 'default'; % 'Concentración [ozoneUnits]'
            obj.grid = 'on';
            obj.LineWidth = 0.5;
            obj.legend = {'default'}; % Nombres de archivos
            obj.legendFontSize = 8;
            obj.legendLocation = 'best';
            obj.imageResolution = 300;
            obj.defaultlegend = {};
            obj.titleInterpreter = 'tex';
            obj.labelInterpreter = 'tex';
            obj.legendInterpreter = 'tex';
        end

        function obj = openfiles(obj)
            clear obj.file
            clear pathfile
            [obj.file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo','MultiSelect','on');

            if isequal(obj.file,0)
                disp('No se seleccionó ningun archivo.');
            else
                clear obj.rawdata
                clear obj.fixeddata
                % clear obj.legend
                clear obj.ozoneresults
                clear onj.defaultlegend

                if length(string(obj.file)) == 1
                  obj.file = string(obj.file);
                  obj.defaultlegend{1} = erase(obj.file,".mat");
                  obj.rawdata{1} = importdata(fullfile(pathfile, obj.file));
                  % obj.xf{1} = 'end';
                elseif length(string(obj.file)) > 1
                    for i=1:length(obj.file)
                        % obj.file = string(obj.file);
                        obj.defaultlegend{i} = string(erase(obj.file{i},".mat"));
                        % obj.defaultlegend{i} = string(obj.defaultlegend{i});
                        obj.xf{i} = 'end';
                        obj.xk{i} = 1;
                        obj.rawdata{i} = importdata(fullfile(pathfile, obj.file{i}));
                    end
                end
                if isequal(obj.legendInterpreter,'latex')
                    for i=1:length(obj.defaultlegend)
                        obj.defaultlegend{i} = "$"+obj.defaultlegend{i}+"$";
                    end
                end
                %for i=1:length(obj.file)
                %  obj.rawdata{i} = importdata(fullfile(pathfile, obj.file{i}));
                %    % obj.legend{i} = replace(lgnd{i},'_','-');
                %end
            end
        end

        function obj = plotfiles(obj)
            clear obj.fixeddata;
            obj.fixeddata = obj.rawdata;
            if isempty(obj.fixeddata)
                disp("No se han cargado archivos para graficar. Ejecute openfiles primero.");
            else
                if isequal(obj.xlabel,'min')
                    t = 60;
                elseif isequal(obj.xlabel,'h')
                    t = 3600;
                elseif isequal(obj.xlabel,'seg')
                    t = 1;
                end

                if isequal(obj.legend,{'default'}) | isequal(obj.legend,obj.defaultlegend)
                xlabeltitle = char(sprintf("Tiempo (%s)",obj.xlabel));
                if isequal(obj.ylabel,'default')
                    ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                else
                end
                    obj.legend = obj.defaultlegend;
                end
                try
                    obj.fixedfig.Visible = 'on';
                catch
                    obj.fixedfig = figure;
                    obj.fixedax = axes('Parent',obj.fixedfig);
                end
                cla(obj.fixedax);
                % obj.fixedax.Parent = obj.fixedfig; % = axes;
                hold(obj.fixedax,'on');
                for i=1:length(obj.fixeddata)
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)/t;
                    obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(1,:)==60/t):end);
                    obj.fixeddata{i} = obj.fixeddata{i}(:,find(obj.fixeddata{i}(2,:)==min(obj.fixeddata{i}(2,1:find(obj.fixeddata{i}(1,:)==10*60/t)))):end);
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)*obj.xk{i};
                    obj.fixeddata{i}(1,:) = obj.fixeddata{i}(1,:)-obj.fixeddata{i}(1,1);
                    obj.fixeddata{i}(1,:) = round(obj.fixeddata{i}(1,:),2);
                    if isequal(obj.xf{i},'end') | obj.xf{i}>max(obj.fixeddata{i}(1,:))
                        obj.fixeddata{i} = obj.fixeddata{i}(:,1:end);
                    else
                        obj.fixeddata{i} = obj.fixeddata{i}(:,1:find(obj.fixeddata{i}(1,:)==obj.xf{i}));
                    end
                    plot(obj.fixedax, obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:), 'LineWidth', obj.LineWidth);
                end
                title(obj.fixedax,obj.fixedtitle, 'Interpreter', obj.titleInterpreter);
                if isempty(obj.xlabel)
                    xlabel(obj.fixedax,'off');
                else
                    xlabel(obj.fixedax,'on');
                    xlabel(obj.fixedax,xlabeltitle,'Interpreter',obj.labelInterpreter);
                end
                if isempty(obj.ylabel)
                    ylabel(obj.fixedax,'off');
                else
                    ylabel(obj.fixedax,'on');
                    ylabel(obj.fixedax,ylabeltitle,'Interpreter',obj.labelInterpreter);
                end
                grid(obj.fixedax,obj.grid);
                if isempty(obj.legend)
                    legend(obj.fixedax,'off');
                else
                    legend(obj.fixedax,'on');
                    legend(obj.fixedax,obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
                end
                hold(obj.fixedax,'off');
            end
        end

        function obj = plotozonecalc(obj)
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

                if isequal(obj.ylabel,'default')
                    ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                else
                end

                if isequal(u,0)
                    disp('Unidades incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    for i=1:length(obj.fixeddata)
                        residual = trapz(obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:))/u;
                        consumed = (max(obj.fixeddata{i}(1,:))*max(obj.fixeddata{i}(2,:)))/u - residual;
                        total = residual + consumed;
                        if isequal(obj.xlabel,'h')
                            var(1) = consumed*60;
                            var(2) = residual*60;
                            var(3) = total*60;
                        elseif isequal(obj.xlabel,'seg')
                            var(1) = consumed/60;
                            var(2) = residual/60;
                            var(3) = total/60;
                        else
                            var(1) = consumed;
                            var(2) = residual;
                            var(3) = total;
                        end
                        for j=1:3
                            obj.ozoneresults{i,j} = {ozonevars(j), var(j)};
                        end
                    end
                end
            end

            for i=1:length(obj.fixeddata)
                for j=1:3
                    y(i,j) = obj.ozoneresults{i,j}{2};
                end
                x{i} = char(obj.legend{i});
            end

            obj.ozonefig.Visible = 'on';
            cla(obj.ozoneax)
            hold(obj.ozoneax,'on');
            b = bar(obj.ozoneax,categorical(x),y);
            title(obj.ozoneax,obj.ozonetitle,'Interpreter',obj.titleInterpreter);
            legend(obj.ozoneax,ozonevars,'Location',"best");
            ylabel(obj.ozoneax,obj.ylabel,'Interpreter',obj.labelInterpreter);
            grid(obj.ozoneax,obj.grid);
            ylim(obj.ozoneax,[0 max(var(3))+0.3]);
            xcentr = vertcat(b.XEndPoints)';
            text(obj.ozoneax,xcentr(:),y(:),num2str(y(:),'%.2f'),'HorizontalAlignment','center','VerticalAlignment','bottom');
            hold(obj.ozoneax,'off');
        end

        function obj = saveplot(obj,name)
            cla(obj.ax, 'reset');
            obj.ax.Parent = obj.fig;
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
                        if isequal(obj.xlabel,'h')
                            var(1) = consumed*60;
                            var(2) = residual*60;
                            var(3) = total*60;
                        elseif isequal(obj.xlabel,'seg')
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
