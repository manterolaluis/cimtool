set(handles.pushbuttonRedo, 'Enable', 'off');
set(handles.pushbuttonOK, 'Enable', 'off');
set(handles.checkboxDiamLimits, 'Value',1);
set(handles.checkboxDiamLimits, 'FontWeight', 'normal');
set(handles.checkboxDiamLimits, 'FontAngle', 'normal');
set(handles.checkboxZoom, 'FontWeight', 'bold');
set(handles.checkboxZoom, 'FontAngle', 'italic');

enoughMeditions = false;
minMeditions = 170;
title('Seleccionar region a ampliar para IMT y doble click');
global language;
set(handles.textDetails,'String',language.explanationZoomWall);

global rectZoom originalUSCrop zoomPared hPlotActual;
axes(handles.axes1);
while not(enoughMeditions)
    rect = imrect;
    rectZoom = wait(rect);
    
    if not(isempty(rectZoom)) && rectZoom(3)>minMeditions
        enoughMeditions = true;
    else
        title(language.WarningMeditions);
    end
    delete(rect);
end
hold on;
% Then, from the help:
hPlotActual = rectangle('Position',rectZoom,...
    'LineWidth',2,'EdgeColor','g');
hold off;
zoomPared = imcrop(originalUSCrop,rectZoom);
%Agrando la imagen proporcionalmente a sus dimensiones, que no la reescale
[hRegion, wRegion] = size(zoomPared);

set(handles.pushbuttonRedo, 'Enable', 'on');
set(handles.pushbuttonOK, 'Enable', 'on');
uicontrol(handles.pushbuttonOK);