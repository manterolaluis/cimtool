function [ MNGs, MNGxLonja ] = functionCraiem2009PlacaIrregular( imgGray, placaBinary )

%itero erosionando, de la diferencia tengo la lonja
erosiones = 3; %Tomando como ejemplo Molinari2010 Pag 203 Fig. 2
MNGs = ones(size(imgGray)) * -1;
[h,w] = size(placaBinary);

MNGxLonja = [];
while sum(placaBinary(:))>0
    binaryAux = placaBinary;
    
    %for erosion=1:erosiones
    %    binaryAux = imerode(binaryAux, [1 1 1;1 1 1;0 0 0]);
    %end
    for i=1:w
        col = binaryAux(:,i);
        primero = find(col,1);
        fin = primero+erosiones;
        if fin > h ; fin = h; end
        binaryAux(primero:fin,i) = false;
    end
    
    lonjaBinary = xor(binaryAux,placaBinary);
    
    lonjaGray = imgGray(lonjaBinary);
    MNG = median(lonjaGray);
    MNGxLonja = vertcat(MNGxLonja,MNG);
    MNGs(lonjaBinary) = MNG;
    
    placaBinary = binaryAux;
end

