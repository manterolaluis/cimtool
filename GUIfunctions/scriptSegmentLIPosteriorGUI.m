set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxLIAnterior, 'FontWeight', 'normal');
set(handles.checkboxLIAnterior, 'FontAngle', 'normal');
set(handles.checkboxLIAnterior, 'Value',1);
set(handles.checkboxLIPosterior, 'FontWeight', 'bold');
set(handles.checkboxLIPosterior, 'FontAngle', 'italic');
global xLIAnterior yLIAnterior;
global language;
axes(handles.axes1);
title('Seleccionar puntos de LI posterior y presionar Enter');
set(handles.textDetails,'String',language.explanationLIPosterior);
hold on;
plot(xLIAnterior,yLIAnterior,'r');
xLIPosteriorManual = [];
while isempty(xLIPosteriorManual)
    tic;
[xLIPosteriorManual, yLIPosteriorManual] = getpts(handles.axes1);
elapsedLIPosteriorPoints = toc;
hold off;
end
tic;
global originalUSCrop xLIPosterior yLIPosterior;
[xLIPosterior,yLIPosterior,GsmoothAbs] = functionSegmentEdgeCarotid( xLIPosteriorManual, yLIPosteriorManual,...
    originalUSCrop, false );
timeAutoSegmentationLIPosterior = toc;
hold on;
global hPlotActual;
hPlotActual = plot(xLIPosterior,yLIPosterior,'r');
hold off;
%scriptQuestionMessage;
%if rehacer
%    delete(hPlotActual);
%end
set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);