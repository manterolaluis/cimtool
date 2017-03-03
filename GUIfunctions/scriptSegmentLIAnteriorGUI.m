global stepPipe;
global language;
stepPipe = 1;
set(handles.checkboxLIAnterior, 'FontWeight', 'bold');
set(handles.checkboxLIAnterior, 'FontAngle', 'italic');

set(handles.textDetails,'String',language.explanationLIAnterior);

axes(handles.axes1);
xLIAnteriorManual = [];
while isempty(xLIAnteriorManual)
    tic;
[xLIAnteriorManual, yLIAnteriorManual] = getpts(handles.axes1);
elapsedLIAnteriorPoints = toc;
end

tic;
global originalUSCrop xLIAnterior yLIAnterior hPlotActual;
[xLIAnterior,yLIAnterior,GsmoothAbs] = functionSegmentEdgeCarotid( xLIAnteriorManual, yLIAnteriorManual,...
    originalUSCrop, false );
timeAutoSegmentationLIAnterior = toc;
hold on;
hPlotActual = plot(xLIAnterior,yLIAnterior,'r');
hold off;

%scriptQuestionMessage;
%if rehacer
%    delete(hPlotActual);
%end
set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);