function test_gui
fig = uifigure('Name','Ozonograma','Position',[350 240 700 420]);
ax = uiaxes('Parent',fig,'Position',[10 50 500 350], 'Visible','off');
pnl1 = uipanel(fig, 'Position',[100 200 350 40]);
pnl2 = uipanel(fig, 'Position',[550 50 130 350]);
lbl = uilabel(pnl1, 'Text','Seleccionar archivos.');
lbl.Position = [100 11 400 22];
btn1 = uibutton(fig,'Position', [50 20 100 20],...
    'Text','Seleccionar',...
    'ButtonPushedFcn', @(btn1,event) openfiles(btn1,ax,pnl1,lbl));
btn2 = uibutton(fig,'Position', [550 20 100 20],'Text','Guardar', 'Enable','off');

end

function openfiles(btn1,ax,pnl1,lbl)
ax.Visible = 'on';
pnl1.Visible = 'on';
[file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'on');
if isempty(file)
    lbl.Text = 'No se ha seleccionado ningún archivo';
    ax.Visible = 'off';
else
    pnl1.Visible = 'off';
%     lbl.Visible = 'off';
    ax.Visible = 'on';
    for i=1:length(file)
        data = importdata(fullfile(pathfile, file{i}));
        hold(ax,'on');
        plot(ax,data(1,:),data(2,:));
        hold(ax,'off');
    end
end
end
