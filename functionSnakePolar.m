function [Xsnake,Ysnake] = functionSnakePolar( externalForceSVMScores, tensionForce, flexuralForce, inflationForce, deltaT, maxIter, nrosVertices)
%FUNCTIONSNAKEPOLAR Summary of this function goes here
%   Detailed explanation goes here

[sm,sn] = size(externalForceSVMScores);
%Ysnake = ones(1,sn);
Ysnake = ones(1,nrosVertices);
xs = sn / nrosVertices;
Xsnake = int32(1:xs:xs*(nrosVertices));
radio = 1;

for iter = 1:1:maxIter
    
    %Ecuacion 2 de T-Snakes FUERZA DE TENSION
    tensileForces = 2 * Ysnake - circshift(Ysnake,radio) - circshift(Ysnake,-radio);
    
    %Ecuacion 3 de T-Snakes FUERZA DE FLEXION
    flexuralForces = 2 * tensileForces - circshift(tensileForces,radio) - circshift(tensileForces,-radio);
    
    %Ecuacion 4 FUERZA DE INFLACION
    indexes = sub2ind(size(externalForceSVMScores), int32(Ysnake), int32(Xsnake));
    inflationForces = externalForceSVMScores(indexes);
    
    %Ecuacion 8 de T-Snakes sin fuerza de gradiente
    Ysnake = Ysnake - deltaT * (tensileForces * tensionForce + flexuralForces * flexuralForce - inflationForces * inflationForce);
    
    %Controlo el rango de los puntos
    Ysnake(Ysnake<1)=1;
    Ysnake(Ysnake>sm)=sm;
    
end


end

