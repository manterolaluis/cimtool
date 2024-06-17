clear all; close all; clc;

currentFolder = pwd;
%Archivo donde guardo la ultima direccion
inicFolderFile = strcat(currentFolder,filesep,'luf.wll');
contentConfigFile = fileread(inicFolderFile);
contentConfigFile = strsplit(contentConfigFile,'\n')
inicFolder = contentConfigFile{1};
oldUser = contentConfigFile{2};

[filename,PathName] = uigetfile({'*.mat','All Image Files';},'Open US analysis',inicFolder);
dirMat= strcat(PathName,filename);

load(dirMat);

if not(exist('mmpx','var') == 1)
    mmpx = 0.106;
end

hFig1 = figure('Name','Original US'); imshow(originalUS);
[hRegion, wRegion] = size(originalUSCrop);

%%
%de momento dibujo en cropped
hFig2 = figure('Name','Original US cropped'); imshow(originalUSCrop);
hold on;
plot(xLIAnterior,yLIAnterior,'r');
plot(xLIPosterior,yLIPosterior,'r');
%plot([0 10],[0 10],'r');
hold off;

a = yLIAnterior(round(xDiametroValido(1)));
b = yLIPosterior(round(xDiametroValido(1)));
hold on;
p1 = plot([xDiametroValido(1),xDiametroValido(1)],[a,b],'y');
hold off;

%Draw measurement sector
a = yLIAnterior(round(xDiametroValido(2)));
b = yLIPosterior(round(xDiametroValido(2)));
hold on;
p2 = plot([xDiametroValido(2),xDiametroValido(2)],[a,b],'y');
hold off;

clear a, b;
%%
%Mean among
validoArteria = round(xDiametroValido(1)):1:round(xDiametroValido(2));

interfacePolarAnterior = functionInterfaceToImg( [xLIAnterior',yLIAnterior'] , hRegion, wRegion);
maskAnterior = functionLabelizarPixelPolar( interfacePolarAnterior );

interfacePolarPosterior = functionInterfaceToImg( [xLIPosterior',yLIPosterior'] , hRegion, wRegion);
maskPosterior = functionLabelizarPixelPolar( interfacePolarPosterior );
paredMaskArtery = xor(maskAnterior,maskPosterior);

%From LI to MA
[imtPxMedia1, ~, ~, ~, ~, mediciones1, imtMedia1,...
    ~, ~, ~, ~, medicionesIMTmm1] =...
    functionIMT( xLIAnterior(validoArteria),yLIAnterior(validoArteria),xLIPosterior(validoArteria),yLIPosterior(validoArteria),paredMaskArtery, mmpx );


%From MA to LI
paredMaskArtery2 = flipud(paredMaskArtery);
yLIPosterior2 = (yLIPosterior - ones(size(yLIPosterior)) * hRegion) .* (-1) + ones(size(yLIPosterior));
yLIAnterior2 = (yLIAnterior - ones(size(yLIAnterior)) * hRegion) .* (-1) + ones(size(yLIAnterior));

[imtPxMedia2, ~, ~, ~, ~, mediciones2, imtMedia2,...
    ~, ~, ~, ~, medicionesIMTmm2] =...
    functionIMT(xLIAnterior(validoArteria),yLIPosterior2(validoArteria),xLIPosterior(validoArteria),yLIAnterior2(validoArteria),paredMaskArtery2, mmpx );