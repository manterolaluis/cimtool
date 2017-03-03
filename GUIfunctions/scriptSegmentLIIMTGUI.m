set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxZoom, 'Value',1);
set(handles.checkboxZoom, 'FontWeight', 'normal');
set(handles.checkboxZoom, 'FontAngle', 'normal');
set(handles.checkboxLI, 'FontWeight', 'bold');
set(handles.checkboxLI, 'FontAngle', 'italic');

global xLIManual yLIManual xLI yLI zoomPared elapsedLIPoints timeAutoSegmentationLI hPlotActual;
axes(handles.axes1);
imshow(zoomPared,'InitialMagnification','fit');

title('Seleccionar puntos de LI y presionar Enter');
global language;
set(handles.textDetails,'String',language.explanationLI);


xLIManual = [];
while isempty(xLIManual)
    tic;
[xLIManual, yLIManual] = getpts(handles.axes1);
elapsedLIPoints = toc;
end
dibujar = false;
tic;
[xLI,yLI,GsmoothAbs] = functionSegmentEdgeCarotid( xLIManual, yLIManual, zoomPared, dibujar );
timeAutoSegmentationLI = toc;
hold on; hPlotActual = plot(xLI,yLI,'r'); hold off;

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);