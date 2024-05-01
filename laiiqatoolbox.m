classdef laiiqatoolbox < handle
    %% LAIIQATOOLBOX script v2.0.0
    %   Autor: F. Javier Morales Mtz.
    %   01/05/2024
    %   Matlab toolbox para ajustar y graficar los datos de los archivos
    %   generados del proceso de ozonización en el Laboratorio
    %   de Investigación en Ingeniería Química Ambiental (LAIIQA)
    %   de ESIQIE - IPN.

    properties (Access = public)
        rawdata;
        fixeddata;
        ozoneresults;
        rawtitle; % = 'Datos sin ajustar'
        fixedtitle; % = "Cinética de Ozonización";
        onlytitle; % = '';
        % signaltitle;
        ozonetitle;
        ozoneUnits; % = 'g/Nm^3';
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
    end

    properties (Access = private)
        data;
        rawfig;
        rawax;
        fixedfig;% = figure('visible','off');
        fixedax;% = axes;
        onlyfig;
        % onlyax;
        ozonefig;
        ozoneax;
        % signalfig;
        % signalax;
        % startButton;
        % searchButton;
        file;
        defaultlegend;
        % ports;
        % dropdown;
        % adino;
    end

    methods

        function obj = laiiqatoolbox()
            obj.fixedfig = figure('Visible','off');
            obj.fixedax = axes('Parent',obj.fixedfig);
            obj.rawfig = figure('Visible','off');
            obj.rawax = axes('Parent',obj.rawfig);
            obj.ozonefig = figure('Visible','off');
            obj.ozoneax = axes('Parent',obj.ozonefig);
            obj.onlyfig = figure('Visible','off');
            obj.onlyax = axes('Parent',obj.onlyfig);
            % obj.signalfig = uifigure('Name','Ozonegraph','Visible','off');
            % obj.signalfig.Position(3) = obj.signalfig.Position(3)*1.42;
            % obj.signalax = uiaxes('Parent',obj.signalfig,'Position',[obj.signalfig.Position(3)*0.2818 10 obj.signalfig.Position(3)*0.70425 obj.signalfig.Position(4)-20]);
            obj.rawtitle = "Datos sin ajustar";
            obj.fixedtitle = "Cinética de Ozonización";
            obj.onlytitle = 'default';
            % obj.signaltitle = '';
            obj.ozonetitle = "Consumo de Ozono";
            obj.ozoneUnits = 'g/Nm^3';
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
                clear obj.data
                clear obj.rawdata
                clear obj.fixeddata
                % clear obj.legend
                clear obj.ozoneresults
                clear onj.defaultlegend

                if length(string(obj.file)) == 1
                  obj.file = string(obj.file);
                  obj.defaultlegend{1} = erase(obj.file,".mat");
                  obj.data{1} = importdata(fullfile(pathfile, obj.file));
                  % obj.xf{1} = 'end';
                elseif length(string(obj.file)) > 1
                    for i=1:length(obj.file)
                        % obj.file = string(obj.file);
                        obj.defaultlegend{i} = string(erase(obj.file{i},".mat"));
                        % obj.defaultlegend{i} = string(obj.defaultlegend{i});
                        obj.xf{i} = 'end';
                        obj.xk{i} = 1;
                        obj.data{i} = importdata(fullfile(pathfile, obj.file{i}));
                    end
                end
                if isequal(obj.legendInterpreter,'latex')
                    for i=1:length(obj.defaultlegend)
                        obj.defaultlegend{i} = "$"+obj.defaultlegend{i}+"$";
                    end
                end
                obj.rawdata = obj.data;
            end
        end % func openfiles

        function obj = plotfixed(obj)
            clear obj.fixeddata;
            obj.fixeddata = obj.data;
            if isempty(obj.data) | isempty(obj.fixeddata)
                disp("No se han cargado archivos para graficar o variable fixeddata vacía. Ejecute openfiles primero.");
            else
                if isequal(obj.ozoneUnits,'g/L')
                    u = 1000;
                elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                    u = 1;
                else
                    u = 0;
                end
                if isequal(u,0)
                    disp('Unidades de concentración de ozono incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    if isequal(obj.xlabel,'min')
                        t = 60;
                    elseif isequal(obj.xlabel,'h')
                        t = 3600;
                    elseif isequal(obj.xlabel,'seg')
                        t = 1;
                    end

                    xlabeltitle = char(sprintf("Tiempo (%s)",obj.xlabel));

                    if isequal(obj.ylabel,'default')
                        ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                    end

                    if isequal(obj.legend,{'default'}) | isequal(obj.legend,obj.defaultlegend) | ~isequal(obj.legend,{}) & length(obj.legend)<length(obj.fixeddata)
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
                        obj.fixeddata{i}(2,:) = obj.fixeddata{i}(2,:)/u;
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
                end % if iseq. (u,0)
            end % if isempt. fixeddata
        end % func. plotfixed

        function obj = plotraw(obj)
            if isempty(obj.data)
                disp("No se han cargado archivos para graficar o variable rawdata vacía. Ejecute openfiles primero.");
            else
                if isequal(obj.ozoneUnits,'g/L')
                    u = 1000;
                elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                    u = 1;
                else
                    u = 0;
                end
                if isequal(u,0)
                    disp('Unidades de concentración de ozono incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    clear obj.rawdata;
                    obj.rawdata = obj.data;

                    if isequal(obj.xlabel,'min')
                        t = 60;
                    elseif isequal(obj.xlabel,'h')
                        t = 3600;
                    elseif isequal(obj.xlabel,'seg')
                        t = 1;
                    end

                    xlabeltitle = char(sprintf("Tiempo (%s)",obj.xlabel));

                    if isequal(obj.ylabel,'default')
                        ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                    end

                    if isequal(obj.legend,{'default'}) | isequal(obj.legend,obj.defaultlegend) | ~isequal(obj.legend,{}) & length(obj.legend)<length(obj.fixeddata)
                        obj.legend = obj.defaultlegend;
                    end
                    try
                        obj.rawfig.Visible = 'on';
                    catch
                        obj.rawfig = figure;
                        obj.rawax = axes('Parent',obj.rawfig);
                    end
                    cla(obj.rawax);
                    % obj.rawax.Parent = obj.rawfig; % = axes;
                    hold(obj.rawax,'on');
                    for i=1:length(obj.rawdata)
                        obj.rawdata{i}(1,:) = obj.rawdata{i}(1,:)/t;
                        obj.rawdata{i}(1,:) = obj.rawdata{i}(1,:)*obj.xk{i};
                        obj.rawdata{i}(1,:) = round(obj.rawdata{i}(1,:),2);
                        if isequal(obj.xf{i},'end')
                            obj.rawdata{i} = obj.rawdata{i}(:,1:end);
                        else
                            obj.rawdata{i} = obj.rawdata{i}(:,1:find(obj.rawdata{i}(1,:)==obj.xf{i}));
                        end
                        obj.rawdata{i}(2,:) = obj.rawdata{i}(2,:)/u;
                        plot(obj.rawax, obj.rawdata{i}(1,:), obj.rawdata{i}(2,:), 'LineWidth', obj.LineWidth);
                    end
                    title(obj.rawax,obj.rawtitle, 'Interpreter', obj.titleInterpreter);
                    if isempty(obj.xlabel)
                        xlabel(obj.rawax,'off');
                    else
                        xlabel(obj.rawax,'on');
                        xlabel(obj.rawax,xlabeltitle,'Interpreter',obj.labelInterpreter);
                    end
                    if isempty(obj.ylabel)
                        ylabel(obj.rawax,'off');
                    else
                        ylabel(obj.rawax,'on');
                        ylabel(obj.rawax,ylabeltitle,'Interpreter',obj.labelInterpreter);
                    end
                    grid(obj.rawax,obj.grid);
                    if isempty(obj.legend)
                        legend(obj.rawax,'off');
                    else
                        legend(obj.rawax,'on');
                        legend(obj.rawax,obj.legend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
                    end
                    hold(obj.rawax,'off');
                end % if isequ. (u, 0)
            end % if isempt rawdata
        end % func. plotraw

        function obj = plotonly(obj,number,typedata)
            if ~exist('number','var')
                number = 1;
            end
            if ~exist('typedata','var')
                typedata = 'fixed';
            end
            if isequal(typedata,'fixed') | isequal(typedata,'raw') | isequal(typedata,'both')
                if isequal(typedata,'raw') & isempty(obj.rawdata)
                    disp("No se ha ejecutado plotfixed o no hay datos en rawdata. Ejecute plotfixed primero.");
                elseif isequal(typedata,'fixed') & isempty(obj.fixeddata)
                    disp("No se ha ejecutado openfiles o no hay datos en fixeddata. Ejecute openfiles primero.");
                elseif isequal(typedata,'both') & isempty(obj.rawdata) | isempty(obj.fixeddata)
                    disp("No se ha ejecutado openfiles o no hay datos en rawdata y fixeddata. Ejecute openfiles primero.");
                else
                    if isequal(obj.ozoneUnits,'g/L')
                        u = 1000;
                    elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                        u = 1;
                    else
                        u = 0;
                    end
                    if isequal(u,0)
                        disp('Unidades de concentración de ozono incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');

                    else
                        % if isequal(obj.xlabel,'min')
                        %     t = 60;
                        % elseif isequal(obj.xlabel,'h')
                        %     t = 3600;
                        % elseif isequal(obj.xlabel,'seg')
                        %     t = 1;
                        % end

                        if isequal(obj.onlytitle,'default') & isequal(typedata,'fixed') | isequal(typedata,'raw')
                            titleonly = char(sprintf("%sdata\\{%d\\}",typedata,number));
                        elseif isequal(obj.onlytitle,'default') & isequal(typedata,'both')
                            titleonly = char(sprintf("fixeddata & rawdata \\{%d\\}",number));
                        else
                            titleonly = obj.onlytitle;
                        end

                        xlabeltitle = char(sprintf("Tiempo (%s)",obj.xlabel));

                        if isequal(obj.ylabel,'default')
                            ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                        end

                        if isequal(obj.legend,{'default'}) | isequal(obj.legend,obj.defaultlegend) | ~isequal(obj.legend,{}) & length(obj.legend)<length(obj.fixeddata)
                            obj.legend = obj.defaultlegend;
                        end

                        try
                            obj.onlyfig.Visible = 'on';
                        catch
                            obj.onlyfig = figure;
                            obj.onlyax = axes('Parent',obj.onlyfig);
                        end
                        cla(obj.onlyax);
                        hold(obj.onlyax,'on');
                        if isequal(typedata,'fixed')
                            plot(obj.onlyax,obj.fixeddata{number}(1,:),obj.fixeddata{number}(2,:), 'LineWidth', obj.LineWidth);
                            onlylegend = obj.legend{number};
                        elseif isequal(typedata,'raw')
                            plot(obj.onlyax,obj.rawdata{number}(1,:),obj.rawdata{number}(2,:), 'LineWidth', obj.LineWidth);
                            onlylegend = obj.legend{number};
                        elseif isequal(typedata,'both')
                            plot(obj.onlyax,obj.rawdata{number}(1,:),obj.rawdata{number}(2,:), 'LineWidth', obj.LineWidth);
                            plot(obj.onlyax,obj.fixeddata{number}(1,:),obj.fixeddata{number}(2,:), 'LineWidth', obj.LineWidth);
                            onlylegend = {obj.legend{number} 'fixed'};
                        end
                        title(obj.onlyax,titleonly, 'Interpreter', obj.titleInterpreter);
                        if isempty(obj.xlabel)
                            xlabel(obj.onlyax,'off');
                        else
                            xlabel(obj.onlyax,'on');
                            xlabel(obj.onlyax,xlabeltitle,'Interpreter',obj.labelInterpreter);
                        end
                        if isempty(obj.ylabel)
                            ylabel(obj.onlyax,'off');
                        else
                            ylabel(obj.onlyax,'on');
                            ylabel(obj.onlyax,ylabeltitle,'Interpreter',obj.labelInterpreter);
                        end
                        grid(obj.onlyax,obj.grid);
                        if isempty(obj.legend)
                            legend(obj.onlyax,'off');
                        else
                            legend(obj.onlyax,'on');
                            legend(obj.onlyax,onlylegend,'FontSize',obj.legendFontSize,'Location',obj.legendLocation,'Interpreter',obj.legendInterpreter);
                        end
                        hold(obj.onlyax,'off');
                    end % if iseq. (u,0)
                    % end % if notequal typedata fixed, raw, both
                end % if iseq. typedata raw,fixed,both
            else
                disp("Tipo de variable incorrecta. Opciones válidas: 'fixed' | 'raw' | 'both'");
            end % if notequal typedata
        end % func. plotonly

        function obj = plotozonecalc(obj)
            if isempty(obj.fixeddata)
                disp('Variable fixeddata vacía. Ejecute plotfiles primero.');
            else
                % if isequal(obj.ozoneUnits,'g/L')
                %     u = 1000;
                % elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                if isequal(obj.ozoneUnits,'g/L') | isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                    u = 1;
                else
                    u = 0;
                end
                if isequal(u,0)
                    disp('Unidades incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    ozonevars = ["Consumido","Residual","Total"];

                    if isequal(obj.ylabel,'default')
                        ylabeltitle = char(sprintf("Concentración [%s]",obj.ozoneUnits));
                    end
                    for i=1:length(obj.fixeddata)
                        residual = trapz(obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:));% /u;
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
                    for i=1:length(obj.fixeddata)
                        for j=1:3
                            y(i,j) = obj.ozoneresults{i,j}{2};
                        end
                        x{i} = char(obj.legend{i});
                    end

                    try
                        obj.ozonefig.Visible = 'on';
                    catch
                        obj.ozonefig = figure;
                        obj.ozoneax = axes('Parent',obj.ozonefig);
                    end

                    cla(obj.ozoneax)
                    hold(obj.ozoneax,'on');
                    b = bar(obj.ozoneax,categorical(x),y);
                    if isempty(obj.ozonetitle)
                        title(obj.ozoneax,'off');
                    else
                        title(obj.ozoneax,'on');
                        title(obj.ozoneax,obj.ozonetitle,'Interpreter',obj.titleInterpreter);
                    end
                    legend(obj.ozoneax,ozonevars,'Location',"best");
                    if isempty(obj.ylabel)
                        ylabel(obj.ozoneax,'off');
                    else
                        ylabel(obj.ozoneax,'on');
                        ylabel(obj.ozoneax,ylabeltitle,'Interpreter',obj.labelInterpreter);
                    end
                    grid(obj.ozoneax,obj.grid);
                    ylim(obj.ozoneax,[0 max(var(3))*1.1]);
                    xcentr = vertcat(b.XEndPoints)';
                    if isequal(obj.ozoneUnits,'g/m^3') | isequal(obj.ozoneUnits,'g/Nm^3')
                        value = num2str(y(:),'%.1f');
                    else
                        value = num2str(y(:),'%.2f');
                    end
                    text(obj.ozoneax,xcentr(:),y(:),value,'HorizontalAlignment','center','VerticalAlignment','bottom');
                    hold(obj.ozoneax,'off');
                end % if iseq. (u,0)
            end % if isempt. fixeddata
        end % func. plotozonecalc

        function obj = ozonecalc(obj)
            if isempty(obj.fixeddata)
                disp('Variable fixeddata vacía. Ejecute plotfiles primero.');
            else
                % if isequal(obj.ozoneUnits,'g/L')
                %     u = 1000;
                % elseif isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                if isequal(obj.ozoneUnits,'g/L') | isequal(obj.ozoneUnits,'g/Nm^3') | isequal(obj.ozoneUnits,'g/m^3')
                    u = 1;
                else
                    u = 0;
                end
                if isequal(u,0)
                    disp('Unidades incorrectas. Opciones validas: g/L | g/Nm^3 | g/m^3');
                else
                    ozonevars = ["Consumido","Residual","Total"];
                    for i=1:length(obj.fixeddata)
                        residual = trapz(obj.fixeddata{i}(1,:), obj.fixeddata{i}(2,:));% /u;
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
                end % if iseq. (u,0)
            end % if isempt. fixeddata
        end % func. ozonecalc

        function obj = saveplot(obj,name,figaxes)
            if isempty(obj.rawdata)
                disp("No se han cargado archivos aún. Ejecute openfiles primero.");
            elseif isempty(obj.fixeddata)
                disp("No se ha generado ningún gráfico. Ejecute plotfiles primero.");
            else
                if ~exist('figaxes','var')
                    figaxes = 'fixed';
                end
                if isequal(figaxes,'fixed')
                    figobj = obj.fixedfig;
                    axobj = obj.fixedax;
                elseif isequal(figaxes,'ozone')
                    figobj = obj.ozonefig;
                    axobj = obj.ozoneax;
                elseif isequal(figaxes,'raw')
                    figobj = obj.rawfig;
                    axobj = obj.rawax;
                elseif isequal(figaxes,'only')
                    figobj = obj.onlyfig;
                    axobj = obj.onlyax;
                end
                if contains(name,'.pdf')
                    exportgraphics(figobj,name,'ContentType','vector');
                elseif contains(name,'.png') | contains(name,'.jpg') | contains(name,'.jpeg') | contains(name,'.bmp')
                    exportgraphics(figobj,name,'Resolution',obj.imageResolution);
                elseif contains(name,'.fig')
                    savefig(figobj,name);
                elseif contains(name,'.svg') | contains(name,'.eps') | contains(name,'.tif')
                    saveas(figobj,name);
                else
                    disp("Especifica un formato válido: .png, .jpg, .jpeg, .bmp,.pdf, .eps, .svg, .tif, .fig. Ejemplo: 'mifigura.pdf'");
                end
            end % if isempt. rawdata | fixeddata
        end % func. saveplot()

        % function obj = signal(obj)
        %     try
        %         obj.signalfig.Visible = 'off';
        %     catch
        %         obj.signalfig = uifigure('Name','Ozonegraph','Visible','off');
        %         obj.signalfig.Position(3) = obj.signalfig.Position(3)*1.42;
        %         obj.signalax = uiaxes('Parent',obj.signalfig,'Position',[obj.signalfig.Position(3)*0.2818 10 obj.signalfig.Position(3)*0.70425 obj.signalfig.Position(4)-20]);
        %     end
        %     obj.signalax.XGrid = 'on';
        %     obj.signalax.YGrid = 'on';
        %     panel = uipanel('Parent',obj.signalfig,'Position',[obj.signalfig.Position(3)*0.0144 obj.signalfig.Position(3)*0.0144  obj.signalfig.Position(3)*0.255 obj.signalfig.Position(4)-20]);
        %     label = uilabel('Parent',panel,'Text','Puerto:', 'Position',[panel.Position(1) panel.Position(4)*0.93 60 22]);
        %     obj.dropdown = uidropdown('Parent',panel, 'Position',[panel.Position(1) panel.Position(4)*0.87 160 22]);%
        %     obj.startButton = uibutton('state','Parent',panel,'Text','Start','Position',[panel.Position(3)*0.25 panel.Position(4)*0.50 100 22]);
        %     obj.searchButton = uibutton('Parent',panel,'Text','Buscar','Position',[panel.Position(3)*0.25 panel.Position(4)*0.70 100 22]);
        %     obj.startButton.ValueChangedFcn = @(o,e)startsignal(obj.startButton,obj.signalax,obj.dropdown,obj.ports);
        %     obj.searchButton.ButtonPushedFcn = @(o,e)searchports(obj.dropdown);
        %     % obj.gain = uispinner();
        %     cla(obj.signalax);
        %     obj.signalfig.Visible = 'on';
        % end % func. signal()
    end % end of Methods
    % methods (Access = private)
    % end % Methods acces privated
end % end of Class
