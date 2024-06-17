function [Xsnake,Ysnake,GsmoothAbs] = functionSegmentEdgeCarotid( xInic, yInic, imgGray, dibujar )
[hOrig,wOrig]=size(imgGray);
%Pongo negro del lado derecho, luego lo saco
zerosToAdd = 50;
%imgGray = horzcat(imgGray,zeros(hOrig,zerosToAdd));
imgGray = padarray(imgGray,[0 zerosToAdd],'symmetric','pre');
imgGray = padarray(imgGray,[0 zerosToAdd],'symmetric','post');

[h,w]=size(imgGray);
%Completar curva inicial
snakeY = ones(1,w)*yInic(1);
snakeY(floor(length(snakeY)/2):end) = yInic(end);
for i=2:length(xInic)
    x1 = zerosToAdd+xInic(i-1);
    x2 = zerosToAdd+xInic(i);
    xs = linspace(x1,x2,100);
    y1 = yInic(i-1);
    y2 = yInic(i);
    ys = linspace(y1,y2,100);
    for j=1:length(xs)%Generar la snake
        posx=floor(xs(j));
        if posx<1
            posx=1;
        end
        snakeY(posx)=ys(j);
    end
end

%Quitar ruido
imgFiltered = medfilt2(imgGray, [3 3],'symmetric');
%Suavizar imagen
kernelGauss = fspecial('gaussian',[10 10], 0.3); imgFiltered = conv2(imgFiltered,kernelGauss,'same');
%Restaurar imagen
%imgFiltered = imgFiltered(:,(w+1):(2*w));


%Bordes mediante el metodo de gradiente suavizado de Unal
dx = 5;
dy = 3;%impar
%Gsmooth = functionSmoothedGradient( imgGray, dx, dy );
[pepe, Gsmooth] = imgradientxy(imgFiltered, 'CentralDifference'); Gsmooth(1,:)=0; Gsmooth(end,:)=0;

GsmoothAbs = abs(Gsmooth);

if dibujar
    hFigCarotidaSeg = figure('Name','Carotid detection','Position',[100 100 1500 900]);
    subplot(3,3,1);imshow(imgGray);title('Carotid square');
    subplot(3,3,2);imshow(imgFiltered);title('Filtering');hold on; plot(1:w,snakeY,'r'); hold off;
    subplot(3,3,4);imshow((Gsmooth - min(Gsmooth(:)))/(max(Gsmooth(:)) - min(Gsmooth(:))));title('Derivada');
    hold on; plot(1:w,snakeY,'r'); hold off;
    subplot(3,3,5);imshow((GsmoothAbs - min(GsmoothAbs(:)))/(max(GsmoothAbs(:)) - min(GsmoothAbs(:))));
    title('Absolute derivative');hold on; plot(1:w,snakeY,'r'); hold off;
    
end

[pepe, Derivada2] = imgradientxy(GsmoothAbs, 'CentralDifference'); Derivada2(1,:)=0; Derivada2(end,:)=0;

if dibujar
    figure(hFigCarotidaSeg);
    subplot(3,3,6);imshow((Derivada2 - min(Derivada2(:)))/(max(Derivada2(:)) - min(Derivada2(:))));
    title('Second derivative');hold on; plot(1:w,snakeY,'r'); hold off;
end

borde = 0;

balloonForcesScore = Derivada2;
gradientForces = Derivada2; %basura, para pasarle algo, el coef esta en 0
%tensionCoef = 0.0001;
tensionCoef = 0.15;
flexuralCoef = 0;
inflationCoef = 1;
gradientCoef = 0;
deltaT = 0.1;
maxIter = 1000;
nrosVertices = w;

snakeX = 1:nrosVertices;
if dibujar
    subplot(3,3,7); imshow(Derivada2>0);title('derivada2 th inic');
    hold on; plot(snakeX,snakeY,'g'); hold off;
end
[Xsnake,Ysnake] = functionSnakePolarBalloon(imgGray, balloonForcesScore, gradientForces, tensionCoef, flexuralCoef, inflationCoef,gradientCoef, deltaT, maxIter, nrosVertices, snakeX, snakeY);
%[Xsnake,Ysnake] = functionSnakePolarBalloon(mapaDeS, balloonForcesScore, gradientForces, tensionCoef, flexuralCoef, inflationCoef, gradientCoef, deltaT, maxIter, nrosVertices, Xsnake, Ysnake)
if dibujar
    figure(hFigCarotidaSeg);
    subplot(3,3,8); imshow(Derivada2>0);title('derivada2 th snake');
    hold on; plot(Xsnake,Ysnake,'g'); hold off;
    subplot(3,3,9); imshow(imgGray);title('resultado snake');
    hold on; plot(Xsnake,Ysnake,'g'); hold off;
end

%Me quedo con la parte original

Xsnake = Xsnake(1:end-2*zerosToAdd);
Ysnake = Ysnake(zerosToAdd+1:end-zerosToAdd);
GsmoothAbs = GsmoothAbs(:,1:end-zerosToAdd);

end

