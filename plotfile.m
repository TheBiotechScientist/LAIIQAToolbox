%% LAIIQA Toolbox
% Script para el análisis y graficado de archivos de ozonograma y espectros UV.
% 03/11/2022
% Autor: F. Javier Morales Mtz.
%%
% TODO: Crear clase laiiqatoolbox:

% classdef laiiqatoolbox
%   properties
%     file
%     path
%%
function plotfile(data,x0,xf,units)
%   arguments
%     data
%     x0 = 1
%     xf = 0
%     units = 'min'
%   end
  if isempty(data)
    disp('No hay datos para graficar. Abra un archivo primero.')
  else
    time = data(1,:);
    conc = data(2,:);

    if units=='min'
      time = time/60;
    elseif units=='h'
      time = time/60;
    elseif units=='seg'
      time = time/10;
    end

    if xf==0
      xf = max(time);
    end

    from = find(time==x0)
    to = find(time==xf)

    plot(time(from:to), conc(from:to))
  end
end
