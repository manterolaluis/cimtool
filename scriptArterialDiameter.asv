rehacer = true;

while rehacer
    
    title('Select start and end of segment of interest');
    [xInicDiameter, yInicDiameter]= ginput(1);
    a = yLIAnterior(round(xInicDiameter));
    b = yLIPosterior(round(xInicDiameter));
    hold on;
    p1 = plot([xInicDiameter,xInicDiameter],[a,b],'y');
    hold off;
    
    [xFinDiameter, yFinDiameter]= ginput(1);
    a = yLIAnterior(round(xFinDiameter));
    b = yLIPosterior(round(xFinDiameter));
    hold on;
    p2 = plot([xFinDiameter,xFinDiameter],[a,b],'y');
    hold off;
    xDiametroValido = sort([xInicDiameter,xFinDiameter]);
    
    choice = MFquestdlg([0.3 0.3],'Is it ok?', ...
        'Segment of interest', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            rehacer = false;
        case 'No'
            rehacer = true;
            delete(p1);delete(p2);
    end
    
end