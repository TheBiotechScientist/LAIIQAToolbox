function untitled
fig = uifigure;
ax = uiaxes('Parent',fig,...
            'Units','pixels',...
            'Position', [104, 123, 300, 201], 'Visible', 'off');
btn1 = uibutton(fig,'push',...
               'Position',[420, 218, 100, 22],...
               'ButtonPushedFcn', @(btn,event) plotfiles(btn,ax),...
               'Text','Seleccionar');
end

% Create the function for the ButtonPushedFcn callback
function plotfiles(btn1,ax)
        [file,pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
        ax.Visible = 'on';
        for i=1:length(file)
        data = importdata(fullfile(pathfile, file{i}));
        x = data(1,:);
        y = data(2,:);
        hold(ax,'on');
        plot(ax,x,y);
        hold(ax,'off');
        end
end