
%Apertura del archivo
clear all; close all; clc;
currentFolder = pwd;
%Archivo donde guardo la ultima direccion
inicFolderFile = strcat(currentFolder,filesep,'luf.wll');
contentConfigFile = fileread(inicFolderFile);
contentConfigFile = strsplit(contentConfigFile,'\n')
inicFolder = contentConfigFile{1};
oldUser = contentConfigFile{2};

%Ingresar nombre de usuario
activeUser = functionChangeUser( oldUser );

segmentarStudies = true;

while segmentarStudies
    clearvars -except currentFolder inicFolderFile contentConfigFile contentConfigFile inicFolder oldUser segmentarStudies activeUser;

    close all; clc;
    nroFrameSelected = -1;
    
[filename,PathName] = uigetfile({'*','All Image Files'},'Open US Carotid',inicFolder);
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
    
    %dejar solo la parte util de la imagen
    parteUtilDeLaImagen = [246 125 460 485];
    originalUSCrop = imcrop(originalUS, parteUtilDeLaImagen);
    
    %%
    %PUNTOS DE LUMEN INTIMA ANTERIOR
    rehacer = true;
    close all;
    hFig1 = figure('Name','Artery'); imshow(originalUSCrop);
    set(hFig1, 'MenuBar', 'none');
    set(hFig1, 'ToolBar', 'none');
    set(hFig1, 'NumberTitle', 'off');
    title('Select points over near interface and then press Enter');
    while rehacer
        tic;
        [xLIAnteriorManual, yLIAnteriorManual] = getpts(hFig1);
        elapsedLIAnteriorPoints = toc;
        dibujar = false;
        zoomPared = medfilt2(originalUSCrop, [7 7],'symmetric');
        tic;
        [xLIAnterior,yLIAnterior,GsmoothAbs] = functionSegmentEdgeCarotid( xLIAnteriorManual, yLIAnteriorManual,...
            zoomPared, dibujar );
        timeAutoSegmentationLIAnterior = toc;
        figure(hFig1);
        hold on;
        hPlotActual = plot(xLIAnterior,yLIAnterior,'r');
        hold off;
        scriptQuestionMessage;
        if rehacer
            delete(hPlotActual);
        end
    end
    %functionDrawGradientMap( xLIAnteriorManual,yLIAnteriorManual,xLIAnterior,yLIAnterior,zoomPared,GsmoothAbs );
    
    %%
    %PUNTOS DE LUMEN INTIMA POSTERIOR
    rehacer = true;
    figure(hFig1);
    set(hFig1, 'MenuBar', 'none');
    set(hFig1, 'ToolBar', 'none');
    set(hFig1, 'NumberTitle', 'off');
    while rehacer
        title('Select points over far interface and then press Enter');
        hold on;
        plot(xLIAnterior,yLIAnterior,'r');
        tic;
        [xLIPosteriorManual, yLIPosteriorManual] = getpts(hFig1);
        elapsedLIPosteriorPoints = toc;
        hold off;
        tic;
        [xLIPosterior,yLIPosterior,GsmoothAbs] = functionSegmentEdgeCarotid( xLIPosteriorManual, yLIPosteriorManual,...
            originalUSCrop, dibujar );
        timeAutoSegmentationLIPosterior = toc;
        figure(hFig1);
        hold on;
        hPlotActual = plot(xLIPosterior,yLIPosterior,'r');
        hold off;
        scriptQuestionMessage;
        if rehacer
            delete(hPlotActual);
        end
    end
         
    %Medicion diametro arterial
    figure(hFig1);
    set(hFig1, 'MenuBar', 'none');
    set(hFig1, 'ToolBar', 'none');
    set(hFig1, 'NumberTitle', 'off');
    scriptArterialDiameter;
%    export_fig(strcat(dirImg,'_segmentacionFANTOMA.png'))
    
        %%
    %Medicion diametro arterial, movido aqui para que funcione más rapido
    [hRegion,wRegion] = size(originalUSCrop);
    
    interfacePolarAnterior = functionInterfaceToImg( [xLIAnterior',yLIAnterior'] , hRegion, wRegion);
    maskAnterior = functionLabelizarPixelPolar( interfacePolarAnterior );
    
    interfacePolarPosterior = functionInterfaceToImg( [xLIPosterior',yLIPosterior'] , hRegion, wRegion);
    maskPosterior = functionLabelizarPixelPolar( interfacePolarPosterior );
    paredMaskArtery = xor(maskAnterior,maskPosterior);
    
    validoArteria = round(xDiametroValido(1)):1:round(xDiametroValido(2));
    [diametroPxMedia, diametroPxMedian, diametroPxStd, diametroPxMin, diametroPxMax, medicionesDiametro,...
        diametroMedia, diametroMedian, diametroStd, diametroMin, diametroMax, vectorMediciones] =...
        functionIMT( xLIAnterior(validoArteria),yLIAnterior(validoArteria),xLIPosterior,...
        yLIPosterior(validoArteria),paredMaskArtery );
    
    
    strEstadisticas = {...
        strcat('Diametro px Media:',num2str(diametroPxMedia)),...
        strcat('Diametro px Std:',num2str(diametroPxStd)),...
        strcat('Diametro px Median:',num2str(diametroPxMedian))...
        strcat('Mean Diameter:',num2str(diametroMedia),'mm'),...
        strcat('Stdev Diameter:',num2str(diametroStd)),...
        strcat('Median Diameter:',num2str(diametroMedian),'mm'),...
        strcat('Min Diameter:',num2str(diametroMin)),...
        strcat('Max Diameter:',num2str(diametroMax),'mm'),...
        strcat('#Nodes:',num2str(medicionesDiametro)),...
        };
    
    conSaltoDeLinea = strjoin(strEstadisticas,'\n');
    
    %char(10) is \n, which somehow didn't work for this approach
    text_to_legend = ...
        strcat(strcat({'Mean Diameter:'}  ,{' '},{num2str(diametroMedia)} ,{' '},{'mm'},{char(10)}),...
               strcat({'Stdev Diameter:'} ,{' '},{num2str(diametroStd)}   ,{' '},{'mm'},{char(10)}),...
               strcat({'Median Diameter:'},{' '},{num2str(diametroMedian)},{' '},{'mm'},{char(10)}),...
               strcat({'Min Diameter:'}   ,{' '},{num2str(diametroMin)}   ,{' '},{'mm'},{char(10)}),...
               strcat({'Max Diameter:'}   ,{' '},{num2str(diametroMax)}   ,{' '},{'mm'},{char(10)})...
              );
          
    textborder(0,0.9,text_to_legend,'white','black','Units','normalized', 'FontWeight','bold', 'HorizontalAlignment','Left');

% REMEMBER TO DELETE hMsg IF YOU UNCOMMENT THIS    
%     hMsg = msgbox(strEstadisticas,'Statistics');
%     set(hMsg, 'position', [200 400 200 300]);
%     pause(1);
%     

%     insertText(hFig1,[100,100],conSaltoDeLinea);
    fid = fopen(strcat(dirImg,'_statistics.txt'),'w');
    fprintf(fid, conSaltoDeLinea);
    %fprintf(fid, '%f %f \n', [A B]');
    fclose(fid);
    
    %guardar variables workspace
    save(strcat(dirImg,'_features.mat'),'originalUS','originalUSCrop','parteUtilDeLaImagen',...
        'xLIAnteriorManual', 'yLIAnteriorManual','xLIPosteriorManual', 'yLIPosteriorManual',...
        'xLIAnterior','yLIAnterior','xLIPosterior','yLIPosterior',...
        'activeUser','nroFrameSelected','filename','isImage','xDiametroValido',...
        'diametroPxMedia', 'diametroPxMedian', 'diametroPxStd', 'diametroPxMin', 'diametroPxMax',...
        'medicionesDiametro','xDiametroValido','diametroMedia','diametroMedian','diametroStd',...
        'vectorMediciones');
    
    %Iterar en mas estudios
    choice = MFquestdlg([0.3 0.3],'Open another study?', ...
        'Open another study', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
           segmentarStudies = true;
        case 'No'
            segmentarStudies = false;
    end
%    delete(hMsg);
end

clear; close all; clc;