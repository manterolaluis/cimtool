function gradientForce = functionGradientForce( mapaDeScores )
%FUNCTIONGRADIENTFORCE Summary of this function goes here
%   Detailed explanation goes here

%El gradiente es norte-sur solamente

movido = circshift(mapaDeScores,-1,1);

movido(40:43,40:43)
mapaDeScores(40:43,40:43)

gradiente = mapaDeScores-movido;

positivoMapa = mapaDeScores>0;
positivoMovido = movido>0;

cambioDeSigno = xor(positivoMapa,positivoMovido);

cambioDeSigno(40:43,40:43)

gradientes = zeros(size(mapaDeScores));
gradientes(cambioDeSigno) = gradiente;

%para filtrar

parafiltro = horzcat(gradientes,gradientes,gradientes);
h = fspecial('gaussian', 71, sigma);
g = imfilter(parafiltro,h,'same');    
gradientForce = g(:,widthPolar+1:2*widthPolar);

end

