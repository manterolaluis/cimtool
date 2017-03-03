set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxLI, 'Value',1);
set(handles.checkboxLI, 'FontWeight', 'normal');
set(handles.checkboxLI, 'FontAngle', 'normal');
set(handles.checkboxMA, 'FontWeight', 'bold');
set(handles.checkboxMA, 'FontAngle', 'italic');

global xMAManual yMAManual xMA yMA zoomPared elapsedMAPoints timeAutoSegmentationMA hPlotActual;
global language;

axes(handles.axes1);
%imshow(zoomPared,'InitialMagnification','fit');

title('Seleccionar puntos de MA y presionar Enter');
set(handles.textDetails,'String',language.explanationMA);
xMAManual = [];
while isempty(xMAManual)
    tic;

[xMAManual, yMAManual] = getpts(handles.axes1);
elapsedMAPoints = toc;
end
dibujar = false;
tic;
[xMA,yMA,GsmoothAbs] = functionSegmentEdgeCarotid( xMAManual, yMAManual, zoomPared, dibujar );
timeAutoSegmentationMA = toc;
hold on; hPlotActual = plot(xMA,yMA,'r'); hold off;

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);