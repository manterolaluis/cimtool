function mascara = functionInterfaceToImg( interface , heightStandard, widthStandard)
%FUNCTIONINTERFACETOIMG Summary of this function goes here
%   Detailed explanation goes here

    X = floor(interface(:,1));
    Y = floor(interface(:,2));
    X(X<=1)=1;
    X(X>=widthStandard)=widthStandard;
    Y(Y<=1)=1;
    Y(Y>=heightStandard)=heightStandard;

    mascara = zeros([heightStandard widthStandard],'uint8');
    %y = line(coordsLumen(:,1),coordsLumen(:,2));
    %Ponerlos en una matriz
    indexes = sub2ind(size(mascara), Y, X); cantPuntos = size(indexes);
    valores = uint8(ones(cantPuntos(1),1) * 200);
    mascara(indexes) = valores;
end

