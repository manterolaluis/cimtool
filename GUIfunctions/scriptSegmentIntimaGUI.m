set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxLimitsIntima, 'Value',1);
set(handles.checkboxLimitsIntima, 'FontWeight', 'normal');
set(handles.checkboxLimitsIntima, 'FontAngle', 'normal');
set(handles.checkboxEdgeIntima, 'FontWeight', 'bold');
set(handles.checkboxEdgeIntima, 'FontAngle', 'italic');

axes(handles.axes1);
global language;
set(handles.textDetails,'String',language.explanationIntima);
title('Seleccionar puntos en el borde de la Intima y presionar enter');
xIntimaManual = [];
while isempty(xIntimaManual)
tic;
[xIntimaManual, yIntimaManual] = getpts(handles.axes1);
elapsedIntimaPoints = toc;
end
global zoomPared xIntima yIntima xIntimaValida timeAutoSegmentationIntima hPlotActual;
tic
[xIntima,yIntima,GsmoothAbs] = functionSegmentLMCarotid( xIntimaManual, yIntimaManual, zoomPared, false );
timeAutoSegmentationIntima = toc;
'pasoo1'
axes(handles.axes1);
hold on; hPlotActual=plot(xIntima(round(xIntimaValida(1):xIntimaValida(2))),...
    yIntima(round(xIntimaValida(1):xIntimaValida(2))),'g'); hold off;
'pasoo2'

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);