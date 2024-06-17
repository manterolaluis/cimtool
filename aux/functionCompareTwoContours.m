function [ meanPx, meanIMT ] =...
    functionCompareTwoContours( X1,Y1, X2,Y2, validoArteria, hRegion, wRegion, mmpx )

if not(isrow(X1))
    X1 = X1';
    X2 = X2';
    Y1 = Y1';
    Y2 = Y2';
end


vecSup = min([Y1; Y2]);
vecInf = max([Y1; Y2]);

interfaceSup = functionInterfaceToImg( [X1',vecSup'] , hRegion, wRegion);
maskSup = functionLabelizarPixelPolar( interfaceSup );

interfaceInf = functionInterfaceToImg( [X1',vecInf'] , hRegion, wRegion);
maskInf = functionLabelizarPixelPolar( interfaceInf );

pared = xor(maskSup,maskInf);

%figure, imshow(pared);

[ meanIMT, ~, meanPx, ~] =...
    functionIMT2(X1, vecSup, X1, vecInf, validoArteria,...
    pared, mmpx);


end

