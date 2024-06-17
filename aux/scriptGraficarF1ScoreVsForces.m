clear all; close all;
graficoSnake = true;
label = 'L';%'L';
mediana = false;

if graficoSnake
    labelY = 'Tension coef'; %Recordar que matlab la primer dim es Y
    labelX = 'Inflation coef';
    labelSalida = 'Snake';
    if label=='L'
        %Lumen
        if mediana
            labelSalida = strcat(labelSalida,'-Mediana');
            load('D:\Dropbox\IVUS\2015\Marzo\Resultados preliminares\Snakes\MedianaUmbralada\SegmSnake-Mediana-BestFeatures-FINAL-L.mat');
        else
            %Temp
            labelSalida = strcat(labelSalida,'-Score');
            %load('D:\Dropbox\IVUS\2015\Marzo\Resultados preliminares\Snakes\ScoreAsForce\SegmSnake-InflScoreNoGr-BestFeatures-FINAL-L.mat');
            load('D:\DOCTORADO\workspace\trunk\Matlab\snake\Results\SegmSnake-InflScoreNoGr-BestFeatures-59-1-7-L-140.mat');
        end
        zmin = 0.92;%Que es el F1 score del pixel labelling de CARS
    else
        %Media
        if mediana
            %Temp
            labelSalida = strcat(labelSalida,'-Mediana');
            load('D:\Dropbox\IVUS\2015\Marzo\Resultados preliminares\Snakes\MedianaUmbralada\temp\SegmSnake-Mediana-MasCoefs-M-35.mat');
        else
            labelSalida = strcat(labelSalida,'-Score');
            load('D:\Dropbox\IVUS\2015\Marzo\Resultados preliminares\Snakes\ScoreAsForce\SegmSnake-InflScoreNoGr-BestFeatures-FINAL-M-108.mat');
        end
        zmin = 0.94;%Que es el F1 score del pixel labelling de CARS
    end
else
    labelY = 'Arco horizontal';
    labelX = 'Arco diagonal';
    labelSalida = 'GraphCut';
    if label=='L'
        load('D:\Dropbox\IVUS\2015\Marzo\Resultados preliminares\GraphCut\SegmGraphCut-BestFeatures-FINAL-L-F1-52.mat');
        zmin = 0.92;%Que es el F1 score del pixel labelling de CARS
    else
        zmin = 0.94;%Que es el F1 score del pixel labelling de CARS
    end
end
matrizF1scores(isnan(matrizF1scores))=0;
%zmax= max(matrizF1scores(:));
zmax = 0.96;

%%

if exist('pesosArcos','var')==0
    pesos = 0.1:0.1:2.5;
else
    pesos = pesosArcos;
end

if exist('listaInflationCoef','var')~=0
    pesosX = listaInflationCoef;
    pesosY = listaTensionCoef;
end

xmin = 1;
xmax = length(pesosX);
ymin = 1;
ymax = length(pesosY);

%submatriz
submatriz = matrizF1scores;
%submatriz(submatriz==0) = 1;
%Media
%submatriz = submatriz(5:length(pesosArcos),:);
%Lumen
%submatriz = submatriz(10:length(pesosArcos),:);

labelsX = cellstr(num2str(pesosX(:)));
labelsY = cellstr(num2str(pesosY(:)));
tickX = 1:length(pesosX);
tickY = 1:length(pesosY);


%Grafico 3D surf
figure('Name','F1 vs arcos en 3d');
surf(submatriz); %surf(Z) creates a three-dimensional
%shaded surface from the z components in matrix Z, using x = 1:n and y = 1:m, where [m,n] = size(Z).
hold on;

xlabel(labelX); %Por algun motivo estan intercambiados
ylabel(labelY);
zlabel('F1score');

axis([xmin xmax ymin ymax zmin zmax]);

set(gca,'XTick',tickX,... %# Change the axes tick marks
    'XTickLabel',labelsX,...  %#   and tick labels
    'YTick',tickY,...
    'YTickLabel',labelsY,...
    'TickLength',[0 0]);

caxis([zmin,zmax]);
[redColorMap,greenColorMap,blueColorMap] = functionLevantarDivergingMapFromCSV();
colorMap = [redColorMap, greenColorMap, blueColorMap]./256;
colormap(colorMap);

colorbar;

hold off;

%Grafico 2D
figurePosition = figure('Name','F1 vs arcos en 2D');
set(gcf, 'Color', 'w');
[C,h] = contourf(submatriz,255);
set(h,'LineColor','none');
set(gca, 'DataAspectRatio', [1 1 1]);
caxis([zmin,zmax]);
[redColorMap,greenColorMap,blueColorMap] = functionLevantarDivergingMapFromCSV();
colorMap = [redColorMap, greenColorMap, blueColorMap]./256;
colormap(colorMap);
set(figurePosition, 'Position', [100 100 1600 800]);
set(gca,'XTick',tickX,... %# Change the axes tick marks
    'XTickLabel',labelsX,...  %#   and tick labels
    'YTick',tickY,...
    'YTickLabel',labelsY,...
    'TickLength',[0 0]);
colorbar;

xlabel(labelX); %Por algun motivo estan intercambiados
ylabel(labelY);
export_fig(strcat('snake/Results/',labelSalida,'-',label,'.png'));
export_fig(strcat('snake/Results/',labelSalida,'-',label,'.eps'));