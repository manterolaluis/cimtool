function resultado = functionBordesEnCero(img)

aux = img;
[sm, sn] = size(aux);

aux(1:sm,1)=0;
aux(1:sm,sn)=0;
aux(1,1:sn)=0;
aux(sm,1:sn)=0;

resultado = aux;

end

