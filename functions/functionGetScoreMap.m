function mapaDeScores = functionGetScoreMap(vectorNroFeatures, nroImagen, folderCategory, isCartesiana, wSVM, bSVM, ParametersSetB, mascaraValidosCartesianos, featureScaling)
%FUNCTIONGETSCOREMAP Summary of this function goes here
%   Detailed explanation goes here
%MascaraValidosCartesianos;

Lista = [nroImagen];

%Levantar features
finFeaturesConjunto = length(vectorNroFeatures);
for itf = 1:1:finFeaturesConjunto
    nroFeature = vectorNroFeatures(itf);
    [vectorFeaturesAuxiliar,matrizFeature] = functionLevantarFeature(Lista, nroFeature,...
        folderCategory, mascaraValidosCartesianos, ParametersSetB, isCartesiana, true, featureScaling);
    
    %Imprimir a una imagen este feature
    %datosFeature = strcat('Frame-',num2str(nroImagen),'-Feature-',num2str(nroFeature),'-Number of Feature-',num2str(itf));
    %grayScaleFeature = (matrizFeature-min(matrizFeature(:)) ) / (max(matrizFeature(:))-min(matrizFeature(:)));
    %imwrite(grayScaleFeature,strcat(datosFeature,'.png'));
    clear grayScaleFeature;
    
    if itf==1
        vectorFeaturesTestigo = vectorFeaturesAuxiliar(:);
    else
        vectorFeaturesTestigo = horzcat(vectorFeaturesTestigo, vectorFeaturesAuxiliar(:));
    end
    
    clear vectorFeaturesAuxiliar;
end

%Scores de la imagen
 %tamW = size(wSVM)
 %tamVectorFeatures = size(vectorFeaturesTestigo')
 %tamB = size(bSVM)
scores = wSVM'*vectorFeaturesTestigo' + bSVM;
%Mapa de calor
mapaDeScores = vec2mat(scores,ParametersSetB.heightPolar)';

end

