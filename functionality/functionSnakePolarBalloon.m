function [Xsnake,Ysnake] = functionSnakePolarBalloon(mapaDeScores, balloonForcesScore, gradientForces, tensionCoef, flexuralCoef, inflationCoef, gradientCoef, deltaT, maxIter, nrosVertices, Xsnake, Ysnake)
%FUNCTIONSNAKEPOLAR Summary of this function goes here
%   Detailed explanation goes here
plotear = false;
[sm,sn] = size(mapaDeScores);

if length(Xsnake)<2
    %Ysnake = ones(1,sn);
    Ysnake = ones(1,nrosVertices) * 15;
    xs = sn / nrosVertices;
    Xsnake = int32(1:xs:xs*(nrosVertices));
end
radio = 1;

%Para mostrar
if plotear
    [redColorMap,greenColorMap,blueColorMap] = functionLevantarDivergingMapFromCSV();
    colorMap = [redColorMap, greenColorMap, blueColorMap]./256;
    h = figure('Name','Snake balloon');
    hold on;
    caxis([-2,2]);
    [C,h1] = contourf(flipud(mapaDeScores),120);
    set(h1,'LineColor','none');
    set(gca, 'DataAspectRatio', [1 1 1]);
    colormap(colorMap);
    
    plot(Xsnake,sm-Ysnake,'g');
end

iter=1;
converge = false;
YsnakeOld = ones(size(Ysnake))*(sm-2); %Inicializa con cualquier cosa, es para la convergencia
while not(converge) && (iter<maxIter)
    
    %Ecuacion 2 de T-Snakes FUERZA DE TENSION
    tensileForcesY = 2 * Ysnake - circshift(Ysnake,[0 radio]) - circshift(Ysnake,[0 -radio]);
    tensileForces = tensileForcesY;
    
    %Ecuacion 3 de T-Snakes FUERZA DE FLEXION
    flexuralForces = 2 * tensileForces - circshift(tensileForces,[0 radio]) - circshift(tensileForces,[0 -radio]);
    
    %Ecuacion 4 FUERZA DE INFLACION
    indexes = sub2ind(size(balloonForcesScore), int32(Ysnake), int32(Xsnake));
    %indexes(150:3:170)
    %inflationForces = externalForceSVMScores(indexes);
    
    %Ecuacion en pag 215 de balloon force Cohen 1991
    vectorGradienteForce = gradientForces(indexes);
    vectorInflation = balloonForcesScore(indexes);
    %vectorGradienteForce(150:3:170)
    %vectorInflation(150:3:170)
    F =  vectorInflation * inflationCoef +  vectorGradienteForce * gradientCoef;
    
    %Ecuacion 8 de T-Snakes sin fuerza de gradiente
    Ysnake = Ysnake - deltaT * (tensileForces * tensionCoef + flexuralForces * flexuralCoef - F);
    %max(tensileForces)
    %min(tensileForces)
    
    %Controlo el rango de los puntos
    Ysnake(Ysnake<1)=1;
    Ysnake(Ysnake>sm)=sm;
    
    %Mostrarlo por pantalla
    if mod(iter,1000)==0
        converge = ((sum((YsnakeOld-Ysnake).^2))/nrosVertices)<0.001;
        YsnakeOld = Ysnake;
        if plotear
            %Ysnake(floor(length(Ysnake)/3))
            plot(Xsnake,sm-Ysnake,'b');
        end
    end
    iter = iter+1;
    
end

if plotear
    plot(Xsnake,sm-Ysnake,'r');
    hold off;
end


end

