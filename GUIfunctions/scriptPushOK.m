%stepPipe = 1;
global stepPipe isIntimaVisible;
stepPipe
switch stepPipe
    case 1 %LI Anterior bien, paso al siguiente
        stepPipe = 2;
        scriptSegmentLIPosteriorGUI;
        stepPipe
    case 2 %LI Anterior bien, paso al siguiente
        stepPipe = 3;
        scriptDefineLimitsDiameterGUI;
        stepPipe
    case 3 %LI Anterior bien, paso al siguiente
        stepPipe = 4;
        scriptZoomIMTGUI;
        stepPipe
    case 4
        stepPipe = 5;
        scriptSegmentLIIMTGUI;
    case 5
        stepPipe = 6;
        scriptSegmentMAIMTGUI;
    case 6
        set(handles.pushbuttonRedo, 'Enable', 'off');
        set(handles.pushbuttonOK, 'Enable', 'off');
        set(handles.checkboxMA, 'FontWeight', 'normal');
        set(handles.checkboxMA, 'FontAngle', 'normal');
        set(handles.checkboxMA, 'Value',1);
        choice = MFquestdlg([0.3 0.3],'¿Segmentar intima?', ...
            'Segmentar intima', ...
            'Sí, continuar','No es posible segmentar','No es posible segmentar');
        % Handle response
        switch choice
            case 'Sí, continuar'
                stepPipe = 7;
                isIntimaVisible = true;
                scriptVisibleIntima;
            case 'No es posible segmentar'
                stepPipe = 8;
                set(handles.checkboxLimitsIntima, 'Value',0);
                set(handles.checkboxEdgeIntima, 'Value',0);
                set(handles.pushbuttonExport, 'Enable', 'on');
                uicontrol(handles.pushbuttonExport);
                isIntimaVisible = false;
        end
    case 7
        stepPipe = 8;
        scriptSegmentIntimaGUI;
    case 8
        scriptDisableAllButtons;
        set(handles.pushbuttonExport, 'Enable', 'on');
        uicontrol(handles.pushbuttonExport);
    otherwise
        'otra cosaaa'
end