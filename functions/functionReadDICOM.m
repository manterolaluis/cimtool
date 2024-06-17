function [ frames,parteUtilDeLaImagen, mmpx ] = functionReadDICOM( dirDICOM )
frames = [];
mmpx = 0;
parteUtilDeLaImagen = [];
try
    info = dicominfo(dirDICOM)
    %Voy a seguir si es un archivo de imagen y no un directorio
    info.SequenceOfUltrasoundRegions.Item_1
    physicalDeltaX = info.SequenceOfUltrasoundRegions.Item_1.PhysicalDeltaX
    if physicalDeltaX > 0
        frames= dicomread(info);
        frames = double(frames)./255;
        'DICOM image read'
        parteUtilDeLaImagen = [250 85 450 450];
        mmpx = double(physicalDeltaX).*10;%porque esta en cm/px, lo paso a mm/px
    end
catch
    'Not a DICOM File'
end

end

