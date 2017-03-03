global dirImg originalUS originalUSCrop parteUtilDeLaImagen;
global rectZoom zoomPared zoomParedNormalized paredMask;
global xLIAnteriorManual yLIAnteriorManual xLIPosteriorManual yLIPosteriorManual;
global xLIAnterior yLIAnterior xLIPosterior yLIPosterior;
global xLIManual yLIManual xMAManual yMAManual xLI yLI xMA yMA;
global imtPxMedia imtPxMedian imtPxStd imtPxMin imtPxMax mediciones GSM;
global xIntima yIntima xIntimaManual yIntimaManual isIntimaVisible;
global MNGs MNGxLonja canalR canalG canalB isHomogenea isHeterogenea Craiem2009;
global elapsedLIPoints elapsedMAPoints elapsedLIAnteriorPoints elapsedLIPosteriorPoints;
global elapsedIntimaPoints;
global timeAutoSegmentationLI timeAutoSegmentationMA timeAutoSegmentationIntima;
global activeUser nroFrameSelected xIntimaValida filename isImage xDiametroValido;
global diametroPxMedia diametroPxMedian diametroPxStd diametroPxMin diametroPxMax;
global medicionesDiametro xDiametroValido diametroMedia diametroMedian diametroStd;
global inicFolderFile PathName;

[hRegion, wRegion] = size(zoomPared);
interfacePolarLI = functionInterfaceToImg( [xLI',yLI'] , hRegion, wRegion);
maskLI = functionLabelizarPixelPolar( interfacePolarLI );

interfacePolarMA = functionInterfaceToImg( [xMA',yMA'] , hRegion, wRegion);
maskMA = functionLabelizarPixelPolar( interfacePolarMA );
paredMask = xor(maskLI,maskMA);

grayLumen = 0/255;
grayAdventitia = 190/255;
zoomParedNormalized = functionUSNormalization(zoomPared, maskLI, not(maskMA),...
    grayLumen, grayAdventitia);

placa = zoomParedNormalized(paredMask);
[hPlaca,wPlaca]=size(maskMA);

[ MNGs, MNGxLonja ] = functionCraiem2009PlacaIrregular( zoomParedNormalized, paredMask );
Craiem2009 = MNGxLonja;

dirImg = strcat(dirImg,'_user_',get(handles.editUser, 'String'));

%Sztajzel 2005
[ canalR,canalG,canalB, isHomogenea, isHeterogenea ] = functionSztajzel2005( zoomParedNormalized, paredMask );
%subplot(1,4,4),imshow(cat(3,canalR,canalG,canalB));title('Sztajzel 2005');
imwrite(cat(3,canalR,canalG,canalB),strcat(dirImg,'_Sztajzel.png'))
%export_fig();

%Medicion diametro arterial, movido aqui para que funcione m�s rapido
[hRegion,wRegion] = size(originalUSCrop);

interfacePolarAnterior = functionInterfaceToImg( [xLIAnterior',yLIAnterior'] , hRegion, wRegion);
maskAnterior = functionLabelizarPixelPolar( interfacePolarAnterior );

interfacePolarPosterior = functionInterfaceToImg( [xLIPosterior',yLIPosterior'] , hRegion, wRegion);
maskPosterior = functionLabelizarPixelPolar( interfacePolarPosterior );
paredMaskArtery = xor(maskAnterior,maskPosterior);

%Tengo que tomar solo en cuenta los segmentos de inicio y fin validos
validoArteria = round(xDiametroValido(1)):1:round(xDiametroValido(2));
[diametroPxMedia, diametroPxMedian, diametroPxStd, diametroPxMin, diametroPxMax, medicionesDiametro,...
    diametroMedia, diametroMedian, diametroStd, diametroMin, diametroMax] =...
    functionIMT( xLIAnterior(validoArteria),yLIAnterior(validoArteria),xLIPosterior(validoArteria),...
    yLIPosterior(validoArteria),paredMaskArtery );

clc;
[imtPxMedia, imtPxMedian, imtPxStd, imtPxMin, imtPxMax, mediciones, imtMedia,...
    imtMedian, imtStd, imtMin, imtMax] =...
    functionIMT( xLI,yLI,xMA,yMA,paredMask );

meanPlaca = mean(placa(:)); stdPlaca = std(placa(:)); GSM = median(placa(:));

strHomogenea = 'No';
if isHomogenea
    strHomogenea = 'S�';
end

strHeterogenea = 'No';
if isHeterogenea
    strHeterogenea = 'S�';
end

strEstadisticas = {strcat('GSM:', num2str(GSM)),...
    strcat('Sztajzel - Homogenea:',strHomogenea),...
    strcat('Sztajzel - Heterogenea:',strHeterogenea),...
    strcat('IMT px Media:',num2str(imtPxMedia)),...
    strcat('IMT px Std:',num2str(imtPxStd)),...
    strcat('IMT px Median:',num2str(imtPxMedian)),...
    strcat('IMT px Min:',num2str(imtPxMin)),...
    strcat('IMT px Max:',num2str(imtPxMax)),...
    strcat('IMT Media:',num2str(imtMedia),'mm'),...
    strcat('IMT Std:',num2str(imtStd)),...
    strcat('IMT Median:',num2str(imtMedian),'mm'),...
    strcat('IMT Min:',num2str(imtMin),'mm'),...
    strcat('IMT Max:',num2str(imtMax),'mm'),...
    strcat('Nro mediciones:',num2str(mediciones)),...
    strcat('Diametro px Media:',num2str(diametroPxMedia)),...
    strcat('Diametro px Std:',num2str(diametroPxStd)),...
    strcat('Diametro px Median:',num2str(diametroPxMedian))...
    strcat('Diametro Media:',num2str(diametroMedia),'mm'),...
    strcat('Diametro Std:',num2str(diametroStd)),...
    strcat('Diametro Median:',num2str(diametroMedian),'mm'),...
    strcat('-----------------------------'),...
    strcat('Time Select Points LI (s):',num2str(elapsedLIPoints)),...
    strcat('Time Select Points MA (s):',num2str(elapsedMAPoints)),...
    };

conSaltoDeLinea = strjoin(strEstadisticas,'\n');

fid=fopen(strcat(dirImg,'_estadisticas.txt'),'w');
fprintf(fid, [conSaltoDeLinea]);
%fprintf(fid, '%f %f \n', [A B]');
fclose(fid);

%guardar variables workspace

save(strcat(dirImg,'_features.mat'),'originalUS','originalUSCrop','parteUtilDeLaImagen',...
    'rectZoom','zoomPared','zoomParedNormalized','paredMask',...
    'xLIAnteriorManual', 'yLIAnteriorManual','xLIPosteriorManual', 'yLIPosteriorManual',...
    'xLIAnterior','yLIAnterior','xLIPosterior','yLIPosterior',...
    'xLIManual','yLIManual','xMAManual','yMAManual','xLI','yLI','xMA','yMA',...
    'imtPxMedia','imtPxMedian','imtPxStd','imtPxMin','imtPxMax','mediciones','GSM',...
    'xIntima','yIntima','xIntimaManual','yIntimaManual','isIntimaVisible',...
    'MNGs', 'MNGxLonja','canalR','canalG','canalB', 'isHomogenea', 'isHeterogenea','Craiem2009',...
    'elapsedLIPoints','elapsedMAPoints','elapsedLIAnteriorPoints','elapsedLIPosteriorPoints',...
    'elapsedIntimaPoints',...
    'timeAutoSegmentationLI','timeAutoSegmentationMA','timeAutoSegmentationIntima',...
    'activeUser','nroFrameSelected','xIntimaValida','filename','isImage','xDiametroValido',...
    'diametroPxMedia', 'diametroPxMedian', 'diametroPxStd', 'diametroPxMin', 'diametroPxMax',...
    'medicionesDiametro','xDiametroValido','diametroMedia','diametroMedian','diametroStd');

%Guardar en lastUsedFolder
fid=fopen(inicFolderFile,'w');
fprintf(fid,'%s\n%s',PathName,get(handles.editUser, 'String'));
fclose(fid);

colwidth = 15;
strAux={PathName};
%outstring1 = textwrap(handles.text8,strAux,colwidth);
%set(handles.text8, 'String',outstring1 );
set(handles.text8, 'String',strAux );
