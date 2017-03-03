global language;
set(handles.textDetails,'FontSize',12);
set(handles.textDetails,'String','');

spanish.user = 'Usuario';
spanish.stage = 'Etapa';
spanish.segmentation = 'Segmentacion';
spanish.ready = 'Listo';
spanish.redo = 'Rehacer';
spanish.export = 'Exportar';

spanish.openFile = 'Abrir archivo';
spanish.errorFile = 'Archivo no soportado';
spanish.checkLIAnterior = 'LI Anterior';
spanish.checkLIPosterior = 'LI Posterior';
spanish.checkDiameterLimits = 'Diametro Arterial';
spanish.checkIMTZoom = 'Zoom para IMT';
spanish.WarningMeditions = 'INSUFICIENTES MEDICIONES';
spanish.checkLI = 'Lumen-intima';
spanish.checkMA = 'Media-adventicia';
spanish.checkVisibleIntima = 'Intima visible';
spanish.checkEdgeIntima = 'Intima';

spanish.explanationLIAnterior = 'Clickee los puntos entre el borde anterior de la arteria y el lumen. Luego, presione Enter';
spanish.explanationLIPosterior = 'Clickee los puntos entre el borde posterior de la arteria y el lumen. Luego, presione Enter';
spanish.explanationDiameterLimits = 'Clickee inicio y fin del sector a medir el diametro arterial';
spanish.explanationZoomWall = 'Clickee y arrastre el mouse para hacer zoom en la pared posterior. Luego, presione enter';
spanish.explanationLI = 'Clickee los puntos entre el lumen y la intima. Luego, presione Enter';
spanish.explanationMA = 'Clickee los puntos entre la media y la adventitia. Luego, presione Enter';
spanish.explanationIntimaLimits = 'Clickee inicio y fin del sector donde sea visible la intima';
spanish.explanationIntima = 'Clickee los puntos entre la intima y la media. Luego, presione Enter';

language = spanish;

%Set descriptions

set(handles.text2, 'String', language.user);
set(handles.text1, 'String', language.segmentation);
set(handles.pushbuttonAbrir, 'String', language.openFile);
set(handles.text4, 'String', language.stage);
set(handles.checkboxLIAnterior, 'String', language.checkLIAnterior);
set(handles.checkboxLIPosterior, 'String', language.checkLIPosterior);
set(handles.checkboxDiamLimits, 'String', language.checkDiameterLimits);
set(handles.checkboxZoom, 'String', language.checkIMTZoom);
set(handles.checkboxLI, 'String', language.checkLI);
set(handles.checkboxMA, 'String', language.checkMA);
set(handles.checkboxLimitsIntima, 'String', language.checkVisibleIntima);
set(handles.checkboxEdgeIntima, 'String', language.checkEdgeIntima);
set(handles.pushbuttonRedo, 'String', language.redo);
set(handles.pushbuttonExport, 'String', language.export);