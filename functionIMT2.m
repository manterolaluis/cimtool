function [ meanIMT, stdIMT, meanPx, stdPx] = functionIMT2( xLI,yLI,xMA,yMA, validoArteria, paredMask, mmpx )

[hRegion, wRegion] = size(paredMask);

[imtPxMedia1, ~, ~, ~, ~, ~, imtMedia1,...
    ~, ~, ~, ~, medicionesIMTmm1] =...
    functionIMT( xLI(validoArteria),yLI(validoArteria),xMA(validoArteria),yMA(validoArteria),paredMask, mmpx );

%Inversion para calcular desde la otra interfaz

paredMaskArtery2 = flipud(paredMask);
yPosterior2 = (yMA - ones(size(yMA)) * hRegion) .* (-1) + ones(size(yMA));
yAnterior2 = (yLI - ones(size(yLI)) * hRegion) .* (-1) + ones(size(yLI));

[imtPxMedia2, ~, ~, ~, ~, ~, imtMedia2,...
    ~, ~, ~, ~, medicionesIMTmm2] =...
    functionIMT(xLI(validoArteria),yPosterior2(validoArteria),xLI(validoArteria),yAnterior2(validoArteria),paredMaskArtery2, mmpx );

valuesIMT = [imtMedia1 imtMedia2];
meanIMT = mean(valuesIMT);
stdIMT = std(valuesIMT);

valuesPx = [imtPxMedia1 imtPxMedia2];
meanPx = mean(valuesPx);
stdPx = std(valuesPx);

end