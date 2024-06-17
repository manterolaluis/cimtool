close all;
clear all; clc;
SetValuesIVUSChallengeSetB;
MascaraValidosCartesianos;
isCartesiana = false;
folder = 'D:\DOCTORADO\SetB-IJCARS-TrainingValidation';
scalingXImg = true; clasePositiva = 1; cartesiana = false; featureScaling = true;
tipos = char('SombraYSideVessel', 'Ninguno', 'SideVessel', 'Sombra', 'BifurcacionYOtros');

%Imagen testigo
label = 'M';
stringCategory = 'Ninguno';
folderCategory = strcat(folder,'\',stringCategory);

%Lumen
if label=='L'
    nrosFeatures = [59 1 7]; %IJCARS Conclusions
else
    nrosFeatures = [59 58 46 1 3 15]; %IJCARS Conclusions
end
versions=[31];

for v=versions
    archcsv = strcat(folderCategory,'-IJCARS-Training-v',num2str(v),'.csv')
    Lista = csvread(archcsv);
    labelsValidos = functionLevantarLabels( Lista, folderCategory, label, clasePositiva, mascaraValidosCartesianos, ParametersSetB,isCartesiana);
    labelsTraining{v} = labelsValidos;
end

%Levantar features de entrenamiento de la SVM
for v=versions
    %if iterConjunto == inicConjunto %If para no armar conjunto fijo cada vez
    for iterConjuntoFijo = 1:1:length(nrosFeatures) %Levantar features del conjunto
        nroFeatureConjunto = nrosFeatures(iterConjuntoFijo);
        
        %Preallocation
        cantDatosTraining = length(labelsTraining{v});
        vectorFeatureConjuntoAux = zeros(cantDatosTraining,1);
        primerPosicionLibre = 1;
        archcsv = strcat(folderCategory,'-IJCARS-Training-v',num2str(v),'.csv');
        Lista = csvread(archcsv);
        
        %Levantar el conjunto de features hasta el momento
        vectorAuxiliar = functionLevantarFeature( Lista, nroFeatureConjunto, folderCategory, mascaraValidosCartesianos, ParametersSetB,isCartesiana, scalingXImg, featureScaling);
        %Cuantos datos levante?
        cantLeida = length(vectorAuxiliar);
        
        vectorFeatureConjuntoAux(primerPosicionLibre:primerPosicionLibre+cantLeida-1) = vectorAuxiliar;
        primerPosicionLibre = primerPosicionLibre+cantLeida;
        
        %A la salida, junto la columna a las anteriores
        if iterConjuntoFijo==1
            vectorFeatureConjuntoTraining = vectorFeatureConjuntoAux;
        else
            vectorFeatureConjuntoTraining = horzcat(vectorFeatureConjuntoTraining, vectorFeatureConjuntoAux);
        end
        
        clear vectorFeatureConjuntoAux;
        
    end
    
    featuresTraining{v} = vectorFeatureConjuntoTraining;
    
end

%Datos SVM
lambda = 0.0001;
maxIterSVM = 1000000;
perdidaVLFeat = 'L2';
epsilonVLFeat = 0.001;

for v=versions
    %Datos para este k-fold
    vectorFeaturesTraining = featuresTraining{v};
    vectorLabelsTraining = labelsTraining{v};
    %vectorFeaturesSnake = featuresValidation{v};
    %vectorLabelsValidation = labelsValidation{v};
    
    %Entrenar SVM
    %VLFEat SDCA
    [wVLFeatSDCA bVLFeatSDCA info] = vl_svmtrain(vectorFeaturesTraining',...
        vectorLabelsTraining', lambda, 'MaxNumIterations', maxIterSVM,...
        'Epsilon',epsilonVLFeat,'Loss',perdidaVLFeat,'Solver','sdca');
    wSVM=wVLFeatSDCA;
    bSVM=bVLFeatSDCA;
    
end
'genero SVM'
clear('vectorFeaturesTraining','vectorLabelsTraining','vectorFeatureConjuntoTraining','featuresTraining',...
    'cantDatosTraining','labelsTraining','vectorAuxiliar','vectorFeatureConjuntoAux');
%%
%nroImagen = 254;
%nroImagen = 247;
nroImagen = 4;
%nroImagen = 260;
%Labels imagen
labelsValidosImg = functionLevantarLabels( nroImagen, folderCategory, label, 1, mascaraValidosCartesianos, ParametersSetB,isCartesiana);

mapaDeScores = functionGetScoreMap(nrosFeatures, nroImagen, folderCategory,...
    isCartesiana, wSVM, bSVM,ParametersSetB,mascaraValidosCartesianos,featureScaling);

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
set(gca, 'YTick', []);
set(gca, 'XTick', []);
colorbar;
hold off;

%Ahora, la fuerza externas
%Fuerza de inflacion
%Siempre se infla, el modelo orginal de balloon
%inflacionForce = ones(size(mapaDeScores));

%Filtro de mediana en el mapa de scores
g = horzcat(mapaDeScores,mapaDeScores,mapaDeScores);%Para que los bordes sean circulares
for it=1:1:2
    g = medfilt2(g,[7 7],'symmetric');
end
inflacionForce = g(:,widthPolar+1:2*widthPolar);

%figure('Name','inflation force'), imshow(inflacionForce);

%Edge detection

%desviacion standard
NHOOD = ones(3,3);
stdImage = stdfilt(mapaDeScores,NHOOD);
stdImageNorm = (stdImage-min(stdImage(:)))/(max(stdImage(:))-min(stdImage(:)));
%figure('Name','stdImage'), imshow(stdImageNorm);

% %positivos
% positivos = mapaDeScores>0;% figure('Name','positivos'), imshow(positivos);
% negativos = mapaDeScores<=0;% figure('Name','negativos'), imshow(negativos);
% 
% bordePositivoNegativo = positivos & circshift(negativos,[-1 0]);
% figure('Name','bordePositivoNegativo'), imshow(bordePositivoNegativo);
% 
% %difumino gradiente como Eq. A4 de Tsnakes
% borde=-bordePositivoNegativo; %figure('Name','borde'), imshow(borde);
% 
% kernelGaussiano = fspecial('gaussian', [70 70], 5);
% bordeGaussian = imfilter(horzcat(borde,borde,borde),kernelGaussiano,'symmetric','same');
% bordeGaussian = bordeGaussian(:,widthPolar+1:2*widthPolar);
% %figure('Name','bordeGaussian'), imshow(bordeGaussian*(-1));
% 
% %Ecuacion 7 de t-snake, que es derivar ese gradiente
% derivadaBorde = bordeGaussian - circshift(bordeGaussian,[1 0]);
% %Mismo orden que la inflacion
% derivadaBordenOrdenInfl = functionOrdenGradiente(derivadaBorde);

derivadaBordenOrdenInfl = functionGaussianEdgeScores( mapaDeScores,ParametersSetB,50,5 );
% 
% figure('Name','derivadaBorde'), imshow(derivadaBorde);
% derivadaBordeNorm = (derivadaBorde-min(derivadaBorde(:)))/(max(derivadaBorde(:))-min(derivadaBorde(:)));
% %figure('Name','derivadaBordeNorm'), imshow(derivadaBordeNorm);
derivadaBordenOrdenInflNorm = (derivadaBordenOrdenInfl-min(derivadaBordenOrdenInfl(:)))...
    /(max(derivadaBordenOrdenInfl(:))-min(derivadaBordenOrdenInfl(:)));
figure('Name','derivadaBordenOrdenInflNorm'), imshow(derivadaBordenOrdenInflNorm);

%Datos snake
maxIter = 130500;
deltaT = 0.1;
tensionCoef = 0.1;
flexuralCoef = 0;
inflationCoef = 0.07; %La inflacion debe ser la mitad que el gradiente en el mismo orden
gradienteCoef = 0;
nrosVertices = 500;
%inflacionForce = ones(size(mapaDeScores));
inflacionForce = mapaDeScores;

[Xsnake,Ysnake] = functionSnakePolarBalloon(mapaDeScores, inflacionForce, derivadaBordenOrdenInfl,tensionCoef, flexuralCoef, inflationCoef,gradienteCoef, deltaT, maxIter,nrosVertices);

%Graficar

%Interfaz calculada mediante el gradiente de gt, porque no tengo la imagen
trues = labelsValidosImg>0;
gt = vec2mat(trues,ParametersSetB.heightPolar)';
interfaz = bwmorph(gt,'remove');
interfaz = flipud(interfaz);
%Bordes de la imagen que los calcula mal
interfaz(1:1,1:ParametersSetB.widthPolar) = false; interfaz(1:ParametersSetB.heightPolar,1:5) = false;
interfaz(ParametersSetB.heightPolar,1:ParametersSetB.widthPolar) = false; interfaz(1:ParametersSetB.heightPolar,ParametersSetB.widthPolar) = false;
[I,J]=find(interfaz);

%Dibujar figura
nombreColorMap = strcat(label,'-',stringCategory,'-frame-',num2str(nroImagen),'- Color Map Y Snake');
figureColorMap = figure('Name',nombreColorMap);
hold on;
caxis([-1.5,1.5]);
[C,h] = contourf(flipud(mapaDeScores),120);
set(h,'LineColor','none');
set(gca, 'DataAspectRatio', [1 1 1]);
[redColorMap,greenColorMap,blueColorMap] = functionLevantarDivergingMapFromCSV();
colorMap = [redColorMap, greenColorMap, blueColorMap]./256;
colormap(colorMap);
plot(J,I,'k','LineWidth',2);
plot(Xsnake,ones(size(Ysnake)).*double(heightPolar)-Ysnake,'r','LineWidth',2);%Los menos es porque el origen en la figura esta abajo a la izquierda
set(gca, 'YTick', []);
set(gca, 'XTick', []);
colorbar;
hold off;

derivadaBordenOrdenInflNorm = (derivadaBordenOrdenInfl-min(derivadaBordenOrdenInfl(:)))...
    /(max(derivadaBordenOrdenInfl(:))-min(derivadaBordenOrdenInfl(:)));

figure('Name','gradientForce y Snake'), imshow(derivadaBordenOrdenInflNorm);
hold on;
plot(Xsnake,Ysnake,'r','LineWidth',2);%Los menos es porque el origen en la figura esta abajo a la izquierda
hold off;

%%

[vectorFeature1,imgPolarOriginal] = functionLevantarFeature(nroImagen, 1, folderCategory, mascaraValidosCartesianos, ParametersSetB, isCartesiana, false, false);
imgPolarOriginal = double(imgPolarOriginal)/255;

figure('Name','En cartesiana');
subplot(3,2,1); imshow(imgPolarOriginal); title('Polar');

%To cartesian
cartesiana = ToCartesian(imgPolarOriginal, ParametersSetB);
subplot(3,2,2); imshow(cartesiana); title('Cartesiana');

[ YCart, XCart ] = functionPolarContourToCartesian( Ysnake, ParametersSetB );
idx = int32(sub2ind(size(cartesiana), XCart, YCart));

cartesianaR=cartesiana;cartesianaG=cartesiana;cartesianaB=cartesiana;
%cartesianaR(int32(YCart), int32(XCart))= 1;
%cartesianaG(int32(YCart), int32(XCart))= 0;
%cartesianaB(int32(YCart), int32(XCart))= 0;
YCart = int32(YCart);
XCart = int32(XCart);
borde = false(size(cartesiana));

for i=1:length(YCart)
    borde(YCart(i),XCart(i))=true;
end

cartesianaR(borde)= 1;
cartesianaG(borde)= 0;
cartesianaB(borde)= 0;

subplot(3,2,3); imshow(borde);

imgCartRGB = cat(3,cartesianaR,cartesianaG,cartesianaB);
subplot(3,2,4); imshow(imgCartRGB); title('Snake en Cartesiana');

subplot(3,2,5); plot(YCart,XCart,'g'); title('SnakeCart');









