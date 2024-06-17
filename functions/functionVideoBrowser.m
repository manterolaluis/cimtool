function [ frameSelected, nroFrameSelected ] = functionVideoBrowser( frames,dirVideo )

nroFrameSelected = 1;
frameSelected = frames(:,:,1,nroFrameSelected);
[h,w,channels,numImgs] = size(frames);

if numImgs > 1

hFig = figure('Name',dirVideo);
hImage = imshow( frameSelected);
hsl = uicontrol('Style','slider','Min',1,'Max',numImgs,...
    'SliderStep',[1 1]./(numImgs-1),'Value',1,...
    'Position',[80 20 w 20]);
set(hsl,'Callback',@slider_callback);
[v d] = version; %Sacar la version de matlab
is2013 = findstr(d, '2013');

if not(isempty(is2013)) %Version 2013
    hListener = addlistener(hsl,'Value','PostSet',@slider_move2013);
else
    %Digamos que es MATLAB 2015
    hsl.UserData.lastValue = 1; % initialise the property
    hFig.WindowButtonMotionFcn = @(obj,event)slider_move2015(obj,hsl);
end
titulo = strcat('Current frame:',num2str(nroFrameSelected),'. Close the window to continue');
title(titulo);
uiwait;

end

    function slider_callback(hObject,eventdata)
        nroFrameSelected = round(get(hObject,'Value'));
        frameSelected = frames(:,:,1,nroFrameSelected);
        set(hImage,'CData',frameSelected);
        %set(hImage,'Name',num2str(nroFrameSelected));
        titulo = strcat('Current frame:',num2str(nroFrameSelected),'. Close the window to continue');
        title(titulo);
    end

    function slider_move2013(hObject,eventdata)
        %get(hObject,'Value')
        %get(hObject)
        algo = get(eventdata);
        nroFrameSelected = round(algo.NewValue);
        frameSelected = frames(:,:,1,nroFrameSelected);
        set(hImage,'CData',frameSelected);
        %set(hImage,'Name',num2str(nroFrameSelected));
        titulo = strcat('Current frame:',num2str(nroFrameSelected),'. Close the window to continue');
        title(titulo);
    end

    function slider_move2015(hObject,eventdata)
        %algo = get(eventdata);
        if eventdata.UserData.lastValue ~= eventdata.Value
            nroFrameSelected = round(eventdata.Value);
            eventdata.UserData.lastValue = eventdata.Value;
            frameSelected = frames(:,:,1,nroFrameSelected);
            set(hImage,'CData',frameSelected);
            %set(hImage,'Name',num2str(nroFrameSelected));
            titulo = strcat('Current frame:',num2str(nroFrameSelected),'. Close the window to continue');
            title(titulo);
        end
    end

end

