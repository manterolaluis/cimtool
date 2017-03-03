
set(handles.checkboxLimitsIntima, 'FontWeight', 'bold');
set(handles.checkboxLimitsIntima, 'FontAngle', 'italic');

xIntima = []; yIntima = []; xIntimaManual = []; yIntimaManual=[];
elapsedIntimaPoints = -1; timeAutoSegmentationIntima=-1;
axes(handles.axes1);
title('Seleccionar inicio y fin del segmento valido');
global language;
set(handles.textDetails,'String',language.explanationIntimaLimits);
xInicIntima = [];
while isempty(xInicIntima)
[xInicIntima, yInicIntima]= ginput(1);
end
global yLI yMA xIntimaValida p1 p2;
a = yLI(round(xInicIntima));
b = yMA(round(xInicIntima));
hold on;
p1 = plot([xInicIntima,xInicIntima],[a,b],'y');
hold off;

xFinIntima = [];
while isempty(xFinIntima)
[xFinIntima, yFinIntima]= ginput(1);
end
a = yLI(round(xFinIntima));
b = yMA(round(xFinIntima));
hold on;
p2 = plot([xFinIntima,xFinIntima],[a,b],'y');
hold off;
xIntimaValida = sort([xInicIntima,xFinIntima]);

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);