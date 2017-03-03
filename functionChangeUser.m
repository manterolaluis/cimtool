function userName = functionChangeUser( oldUser )

figName={'Usuario'};
length(figName)
title = 'Usuario';
defaultans = {oldUser};
options.Interpreter = 'tex';
userName = inputdlg(figName,title,[1 50],defaultans,options);
userName = userName{1}

end
