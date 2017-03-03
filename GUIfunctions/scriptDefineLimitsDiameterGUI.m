set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxLIPosterior, 'Value',1);
set(handles.checkboxLIPosterior, 'FontWeight', 'normal');
set(handles.checkboxLIPosterior, 'FontAngle', 'normal');

set(handles.checkboxDiamLimits, 'FontWeight', 'bold');
set(handles.checkboxDiamLimits, 'FontAngle', 'italic');

global  yLIAnterior yLIPosterior p1 p2;
global language;
title('Seleccionar inicio y fin diametro arterial');
set(handles.textDetails,'String',language.explanationDiameterLimits);
xInicDiameter = [];
while isempty(xInicDiameter)
[xInicDiameter, yInicDiameter]= ginput(1);
end
a = yLIAnterior(round(xInicDiameter));
b = yLIPosterior(round(xInicDiameter));
hold on;
p1 = plot([xInicDiameter,xInicDiameter],[a,b],'y');
hold off;

xFinDiameter = [];
while isempty(xFinDiameter)
[xFinDiameter, yFinDiameter]= ginput(1);
end
a = yLIAnterior(round(xFinDiameter));
b = yLIPosterior(round(xFinDiameter));
hold on;
p2 = plot([xFinDiameter,xFinDiameter],[a,b],'y');
hold off;
global xDiametroValido;
xDiametroValido = sort([xInicDiameter,xFinDiameter]);

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);