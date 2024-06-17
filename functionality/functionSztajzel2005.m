function [ canalR,canalG,canalB, isHomogenea, isHeterogenea ] = functionSztajzel2005( paredNormalizada, paredMask  )

%Sztajzel 2005
%Con el metodo functionUSNormalization ya esta normalizado
THLow = 50/255; %lowest gray-scale values (50 mapped in red)
THInter = 80/255; %intermediate values (between 50 and 80 mapped in yellow) reemplazo x azul
%Mayores a 80 en verde

%Primero analizo todo el zoom a la pared

canalR = double(paredNormalizada<THLow & paredNormalizada>0);
canalB = double(paredNormalizada>=THLow & paredNormalizada<THInter);
canalG = double(paredNormalizada>=THInter);

%Para hacer el calculo de homogeneidad, tomo los que estan en pared mask

enPlacaR = canalR(paredMask);
enPlacaG = canalG(paredMask);
enPlacaB = canalB(paredMask);


%The plaque was considered homogeneous when only 1 predominant color was present on at least two thirds of
%the lesion and heterogeneous when at least 2 different colors were equally present. All color mappings of the plaques were evaluated by
%2 independent investigators (I.M. and R.S.).

umbral = 2/3;
totalR = sum(enPlacaR(:));
totalG = sum(enPlacaG(:));
totalB = sum(enPlacaB(:));
total = totalR+totalG+totalB;
isHomogenea = (totalR > umbral*total) || (totalG > umbral*total) || (totalB > umbral*total)
isHeterogenea = ((totalR + totalG > umbral*total) || (totalB + totalG > umbral*total) || (totalR + totalB > umbral*total))& not(isHomogenea)

%Los autores no usaron azul sino amarillo para los intermedios, asi que
%debo modificar los canales
%R y G hay que cambiarlos

canalR(canalB>0) = 1;
canalG(canalB>0) = 1;
canalB = zeros(size(canalB));

%Restauro en lo que no es pared el valor de gris
canalR(not(paredMask)) = paredNormalizada(not(paredMask));
canalG(not(paredMask)) = paredNormalizada(not(paredMask));
canalB(not(paredMask)) = paredNormalizada(not(paredMask));


end

