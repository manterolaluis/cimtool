stepPipe = 1;

global originalUS dirImg originalUSCrop nroFrameSelected PathName activeUser inicFolder inicFolderFile;

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
fprintf(fid,'%s\n%s',PathName,get(handles.editUser, 'String'));
fclose(fid);

%dejar solo la parte util de la imagen
originalUSCrop = imcrop(originalUS, parteUtilDeLaImagen);

axes(handles.axes1);
imshow(originalUSCrop);
title('Segmentar anterior');

scriptDisableAllButtons;
set(handles.text8, 'String', '');
scriptSegmentLIAnteriorGUI;
else
    'error de dimensiones'
    global language;
    set(handles.text8,'String',language.errorFile);
end

'salio del if'