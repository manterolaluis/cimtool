SetValuesIVUSChallengeSetB;
MascaraValidosCartesianos;
isCartesiana = false;
folder = 'D:\DOCTORADO\SetB-TrainingValidation';
tipos = char('SombraYSideVessel', 'Ninguno', 'SideVessel', 'Sombra', 'BifurcacionYOtros');

%Imagen testigo
label = 'M';
stringCategory = 'SideVessel';
folderCategory = strcat(folder,'\',stringCategory);
nroImagen = 207;
%Labels imagen
labelsValidos = functionLevantarLabels( nroImagen, folderCategory, label, 1, mascaraValidosCartesianos, ParametersSetB,isCartesiana);

%Datos SVM
%vectorNroFeatures = [58 59 10 46]; %MSideVessel v7 LIBLINEAR
%wSVM = [-0.3566 -0.35912 0.0899 0.002812];
%bSVM = 0;
%lambda = 0.000001;

vectorNroFeatures = [58 59]; %MSideVessel v7 LIBLINEAR
wSVM = [-0.3743 -0.33742];
bSVM = 0;
lambda = 0.000001;

%Datos snake
maxIter = 2000;
deltaT = 0.1;
tensionForce = 1000;
flexuralForce = 0;
inflationForce = 1;

mapaDeScores = functionGetScoreMap(vectorNroFeatures, nroImagen, folderCategory,...
    isCartesiana, wSVM, bSVM,ParametersSetB,mascaraValidosCartesianos);

[Xsnake,Ysnake] = functionSnakePolar( mapaDeScores, tensionForce, flexuralForce, inflationForce, deltaT, maxIter,20);


%Graficar

%Interfaz calculada mediante el gradiente de gt, porque no tengo la imagen
trues = labelsValidos>0;
gt = vec2mat(trues,ParametersSetB.heightPolar)';
interfaz = bwmorph(gt,'remove');
interfaz = flipud(interfaz);
%Bordes de la imagen que los calcula mal
interfaz(1:1,1:ParametersSetB.widthPolar) = false; interfaz(1:ParametersSetB.heightPolar,1:5) = false;
interfaz(ParametersSetB.heightPolar,1:ParametersSetB.widthPolar) = false; interfaz(1:ParametersSetB.heightPolar,ParametersSetB.widthPolar) = false;
[I,J]=find(interfaz);

%Dibujar figura
nombreColorMap = strcat(label,'-',stringCategory,'-frame-',num2str(nroImagen),'- Color Map');
figureColorMap = figure('Name',nombreColorMap);
hold on;
caxis([-2,2]);
[C,h] = contourf(flipud(mapaDeScores),120);
set(h,'LineColor','none');
set(gca, 'DataAspectRatio', [1 1 1]);
[redColorMap,greenColorMap,blueColorMap] = functionLevantarDivergingMapFromCSV();
colorMap = [redColorMap, greenColorMap, blueColorMap]./256;
colormap(colorMap);
plot(J,I,'k','LineWidth',2);
plot(Xsnake,ones(size(Ysnake)).*double(heightPolar)-Ysnake,'g','LineWidth',2);%Los menos es porque el origen en la figura esta abajo a la izquierda
set(gca, 'YTick', []);
set(gca, 'XTick', []);
colorbar;
hold off;