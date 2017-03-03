choice = MFquestdlg([0.3 0.3],'Is the detection satisfactory?', ...
    'Validacion segmentacion', ...
    'Yes','No, redo','No, redo');
% Handle response
switch choice
    case 'Yes'
        rehacer = false;
    case 'No, redo'
        rehacer = true;
end
