%stepPipe = 1;
global stepPipe hPlotActual p1 p2;
stepPipe
switch stepPipe
    case 1 %LI Anterior no le gustó, vuelve
        delete(hPlotActual);
        scriptSegmentLIAnteriorGUI;
    case 2 %LI Posterior no le gustó, vuelve
        delete(hPlotActual);
        scriptSegmentLIPosteriorGUI;
    case 3 %LI Posterior no le gustó, vuelve
        delete(p1);delete(p2);
        scriptDefineLimitsDiameterGUI;
    case 4
        'redo'
        delete(hPlotActual);
        scriptZoomIMTGUI;
        stepPipe
    case 5
        'redo'
        delete(hPlotActual);
        scriptSegmentLIIMTGUI;
        stepPipe
    case 6
        'redo'
        delete(hPlotActual);
        scriptSegmentMAIMTGUI;
        stepPipe
    case 7
        'redo'
        delete(p1); delete(p2);
        scriptVisibleIntima;
        stepPipe
    case 8
        'redo'
        delete(hPlotActual);
        scriptSegmentIntimaGUI;
        stepPipe
    otherwise
        'otra cosaaa'
end