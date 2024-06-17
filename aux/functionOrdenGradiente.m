function nuevoValorGradiente = functionOrdenGradiente( gradienteGaussianoOrig )
%FUNCTIONORDENGRADIENTE Summary of this function goes here
%   Detailed explanation goes here

minimoGradiente = min(gradienteGaussianoOrig(:));
maximoGradiente = max(gradienteGaussianoOrig(:));

maskNegativos = gradienteGaussianoOrig<0;
maskPositivos = gradienteGaussianoOrig>0;

nuevoValorGradiente = gradienteGaussianoOrig;

nuevoValorGradiente(maskNegativos) = -(nuevoValorGradiente(maskNegativos)/minimoGradiente);
nuevoValorGradiente(maskPositivos) = nuevoValorGradiente(maskPositivos)/maximoGradiente;

end

