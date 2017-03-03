
%Apertura del archivo
clear all; close all; clc;
currentFolder = pwd;
%Archivo donde guardo la ultima direccion
inicFolderFile = strcat(currentFolder,'\lastUsedFolder.txt');
contentConfigFile = fileread(inicFolderFile);
contentConfigFile = strsplit(contentConfigFile,'\n')
inicFolder = contentConfigFile{1};
oldUser = contentConfigFile{2};
cantidadTejidos = 1;

close all; clc;
nroFrameSelected = -1;

[filename,PathName] = uigetfile({'*','All Image Files'},'Abrir US Carotida',inicFolder);
dirImg= strcat(PathName,filename);
isImage = strendswith(dirImg, '.jpg') || strendswith(dirImg, '.tif') ||...
    strendswith(dirImg, '.png') || strendswith(dirImg, '.bmp') || strendswith(dirImg, '.gif');

parteUtilDeLaImagen = [246 125 460 485];
minSizeImg = [parteUtilDeLaImagen(1) + parteUtilDeLaImagen(3),...
    parteUtilDeLaImagen(2) + parteUtilDeLaImagen(4)];
if isImage
    scriptUSParameters;%Fijemoslo para imgs
    imgRGB = imread(dirImg);
    originalUS = double(imgRGB(:,:,1))/255;
else
    isAVI = strendswith(dirImg, '.avi');
    if isAVI
        scriptUSParameters;%Fijemoslo para videos
        frames = functionReadVideo( dirImg );
    else
        global mmpx;
        [frames,parteUtilDeLaImagen, mmpx] = functionReadDICOM( dirImg );
    end
    if not(isempty(frames))
        [ frameSelected, nroFrameSelected ] = functionVideoBrowser( frames,dirImg );
        originalUS = frameSelected(:,:,1);
        dirImg = strcat(dirImg,'_frame_',num2str(nroFrameSelected));
    else
        originalUS = zeros(1,1); %Cualquier cosa la imagen
    end
end

minSizeImg = [parteUtilDeLaImagen(1) + parteUtilDeLaImagen(3),...
    parteUtilDeLaImagen(2) + parteUtilDeLaImagen(4)];
[h,w] = size(originalUS)

if w>minSizeImg(1) && h>minSizeImg(2)
'paso el if'
%Guardar en lastUsedFolder asi lo vuelve a abrir
fid=fopen(inicFolderFile,'w');
fprintf(fid,'%s\n%s',PathName,'Tool Fantomas');
fclose(fid);

%dejar solo la parte util de la imagen
originalUSCrop = imcrop(originalUS, parteUtilDeLaImagen);

hFig1 = figure('Name','Seleccionar regiones tejido 1'); imshow(originalUSCrop);
title('Para terminar, hacer un rect chiquito');

for j=1:cantidadTejidos
    title(strcat('Tissue---',num2str(j),'---Para terminar, hacer un rect chiquito'));
    seleccionar = true; i=1;
    while seleccionar
        rect = imrect;
        rectZoom = wait(rect);
        seleccionar = rectZoom(3)> 25;
        if seleccionar
            rectZoom = [rectZoom(1) rectZoom(2) 40 40]; %Cuadros del mismo tamaño
            rect_1 = imcrop(originalUSCrop, rectZoom);
            unCompressedImage = exp(rect_1);
            cellMedian{i} = median(rect_1(:));
            cellStd{i} = std(rect_1(:));
            cellMean{i} = mean(rect_1(:));
            cellMeanUncompressed{i} = mean(unCompressedImage(:));
            cellSpeckleIndex{i}=std(unCompressedImage(:)) / cellMeanUncompressed{i};
            i = i+1;
        end
    end
    cellTissuesMedian{j} = median(cell2mat(cellMedian));
    cellSpeckleIndexTissues{j} = cell2mat(cellSpeckleIndex);
    
end
close(hFig1);

%Mediana y media de speckle index
tissuesSpeckleIndexMedian = zeros(1,cantidadTejidos);
tissuesSpeckleIndexMean = zeros(1,cantidadTejidos);
tissuesSpeckleIndexStd = zeros(1,cantidadTejidos);
for i=1:cantidadTejidos
    tissuesSpeckleIndexMedian(i) = median(cellSpeckleIndexTissues{i});
    tissuesSpeckleIndexMean(i) = mean(cellSpeckleIndexTissues{i});
    tissuesSpeckleIndexStd(i) = std(cellSpeckleIndexTissues{i});
end

%Graficar Median
figure('Name','Medians');
plot(cell2mat(cellTissuesMedian),'*r');
axis([0 cantidadTejidos+1 0 1]);
xlabel('Tissue'); ylabel('Median gray');
set(gca,'XTick',1:cantidadTejidos);

%Graficar speckle index
figure('Name','Speckle index mean');
hold on; plot(tissuesSpeckleIndexMedian,'*g', 'LineWidth',2,'MarkerSize',10); hold off;
%hold on; plot(tissuesSpeckleIndexMean,'*b'); hold off;
axis([0 cantidadTejidos+1 min(tissuesSpeckleIndexMedian)-5 max(tissuesSpeckleIndexMedian)+5 ]);
xlabel('Tissue'); ylabel('Median speckle index');
set(gca,'XTick',1:cantidadTejidos);

muestras = []; grouping = [];
for i=1:cantidadTejidos
    muestras = horzcat(muestras, cellSpeckleIndexTissues{i});
    grouping = horzcat(grouping,ones(1,length(cellSpeckleIndexTissues{i}))*i);
end
muestras
grouping

figure('Name','Speckle index BoxPlots');
boxplot(muestras, grouping);



%Guardar en excel directamente, para sobrepasar el tema de los puntos y las comas
header = {'SpeckleIndex',...
    'Median',...
    'Mean','StdCompressed'};

            %cellMedian{i} = median(rect_1(:));
            %cellMeanUncompressed{i} = mean(unCompressedImage(:));
            %cellSpeckleIndex{i}=std(unCompressedImage(:)) / cellMeanUncompressed{i};
            
            %cell2mat(cellMedian)
            %cell2mat(cellMedian)

data = [muestras',cell2mat(cellMedian)',cell2mat(cellMean)',cell2mat(cellStd)'];

filenameXLSEng = strcat(dirImg,'-statistics.xls');
try
    xlswrite(filenameXLSEng, header, 'Hoja1') % by defualt starts from A1
    xlswrite(filenameXLSEng, data, 'Hoja1','A2') % array under the header.
catch
    
    hMsg = errordlg({'No pudo exportar xls. Esta abierto por otro programa?',...
        'Cierrelo y vuelva a ejecutar.'},'Estadisticas');
end

end

'salio del if'