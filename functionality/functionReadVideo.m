function [ frames ] = functionReadVideo( dirVideo )
try
    video = mmread(dirVideo);
    [pepe,numImgs,channels] = size(video.frames);       %[height X width X 3] uint8 matricies
    [h,w,channels] = size(video.frames(1).cdata);
    frames = double(zeros(h,w,channels,numImgs));
    
    for i=1:numImgs
        frames(:,:,:,i) = double(video.frames(i).cdata)/255;
    end
catch
    frames=[];
    'No pudo abrir avi'
end

end

