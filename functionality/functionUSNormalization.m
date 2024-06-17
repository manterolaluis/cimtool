function zoomParedNormalized = functionUSNormalization(zoomPared, maskLumen, maskBackground,...
    grayLumen, grayAdventitia)

medianLumenActual = median(zoomPared(maskLumen));

restado = zoomPared - ones(size(zoomPared)) * medianLumenActual;
restado(restado<0)=0;

%Tomo las primeras lonjas del background, que corresponde a la adventitia
%Reutilizo la funcion de Craiem2009, tomo la primer lonja del background
[ MNGs, MNGxLonja ] = functionCraiem2009PlacaIrregular( restado, maskBackground );
medianAdventitiaActual = MNGxLonja(1);

restado(restado>medianAdventitiaActual)=medianAdventitiaActual;

restadoNorm = restado./medianAdventitiaActual;

zoomParedNormalized = restadoNorm * (grayAdventitia-grayLumen) + grayLumen;


%Para chequear como quedo al final
medianaLumenFinal = median(zoomParedNormalized(maskLumen)) * 255;
[ MNGs, MNGxLonja ] = functionCraiem2009PlacaIrregular( zoomParedNormalized, maskBackground );
medianaAdventitiaFinal = MNGxLonja(1) * 255;

end

