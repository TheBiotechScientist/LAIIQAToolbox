function data = openfile()

  [file, pathfile] = uigetfile({'*.mat'},'Seleccionar archivo', 'MultiSelect', 'off');

  data = importdata(fullfile(pathfile, file));

  plot(data(1,:),data(2,:))

end
