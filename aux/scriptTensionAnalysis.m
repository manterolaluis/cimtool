 
%Utilizo el load Phantom para abrir los 
scriptLoadPhantomMat;
meanIMTGoldStandard = diametroMedia;
meanIMTPxGoldStandard = diametroPxMedia;
%vectorTensionCoef = [0 0.0001 0.0005 0.001 0.005 0.01 0.05 0.1 0.2 0.3 0.5 0.7 1 2 4 8 10];
vectorTensionCoef = [0 0.0001 0.001 0.01 0.1 0.15 0.5 0.7 1];
%vectorTensionCoef = [0 0.1 0.15 1];
vectorIMTDiff = zeros(size(vectorTensionCoef));
vectorPxDiff = zeros(size(vectorTensionCoef));
vectorAnteriorDiffPx = zeros(size(vectorTensionCoef));
vectorPosteriorDiffPx = zeros(size(vectorTensionCoef));
	
for i=1:length(vectorTensionCoef)
    tensionCoef = vectorTensionCoef(i);
    [XLI1,YLI1,~] =...
        functionSegmentEdge( xLIAnteriorManual, yLIAnteriorManual, originalUSCrop, false, tensionCoef );
    [XLI2,YLI2,~] =...
        functionSegmentEdge( xLIPosteriorManual, yLIPosteriorManual, originalUSCrop, false, tensionCoef );

    [ meanIMT, stdIMT, meanPx, stdPx] = functionIMT2( XLI1,YLI1,XLI2,YLI2, validoArteria,paredMaskArtery, mmpx );
	    
    %Difference of IMT
    vectorIMTDiff(i) = abs(meanIMTGoldStandard-meanIMT);
    vectorPxDiff(i) = abs(meanIMTPxGoldStandard-meanPx);
    
    [ diffAnteriorPxAnt, diffAnteriorMMAnt ] =...
        functionCompareTwoContours( xLIAnterior,yLIAnterior, XLI1,YLI1, validoArteria, hRegion, wRegion, mmpx);
    [ diffAnteriorPxPos, diffAnteriorMMPos ] =...
        functionCompareTwoContours( xLIPosterior,yLIPosterior, XLI2,YLI2, validoArteria, hRegion, wRegion, mmpx);
	    
    vectorAnteriorDiffPx(i) = diffAnteriorPxAnt;
    vectorPosteriorDiffPx(i) = diffAnteriorPxPos;

    hFig2 = figure('Name','Original US cropped'); imshow(originalUSCrop);
    hold on;
    plot(XLI1,YLI1,'r');
    plot(XLI2,YLI2,'g');
	    
    a = yLIAnterior(round(xDiametroValido(1))); b = yLIPosterior(round(xDiametroValido(1)));
    plot([xDiametroValido(1),xDiametroValido(1)],[a,b],'y');
    a = yLIAnterior(round(xDiametroValido(2))); b = yLIPosterior(round(xDiametroValido(2)));
    plot([xDiametroValido(2),xDiametroValido(2)],[a,b],'y');
    hold off;
    
    clear a b;
    
    export_fig(strcat(dirMat,'-tension-',num2str(tensionCoef),'.png'));
    close all;
	end
	
	labelsX = cellstr(num2str(vectorTensionCoef(:)));
	tickX = 1:length(vectorTensionCoef);
	
	% figure('Name','Diff IMT Snake vs. OK');
	% plot(vectorIMTDiff,'r');
	
	% set(gca,'XTick',tickX,... %# Change the axes tick marks
    %     'XTickLabel',labelsX);
	% 
	% figure('Name','Diff PX IMT Snake vs. OK');
	% plot(vectorPxDiff,'b');
	% set(gca,'XTick',tickX,... %# Change the axes tick marks
	%     'XTickLabel',labelsX);

    figure('Name','Diff PX Anterior Snake vs. OK');
	plot(vectorAnteriorDiffPx,'g');
	set(gca,'XTick',tickX,... %# Change the axes tick marks
	    'XTickLabel',labelsX);
	
	figure('Name','Diff PX Posterior Snake vs. OK');
	plot(vectorPosteriorDiffPx,'g');
	set(gca,'XTick',tickX,... %# Change the axes tick marks
	    'XTickLabel',labelsX);
	
	    save(strcat(dirMat,'_tensionAnalysis.mat'), 'mmpx', 'vectorPosteriorDiffPx',...
	        'vectorAnteriorDiffPx', 'vectorTensionCoef', 'vectorIMTDiff', 'vectorPxDiff',...
	        'mmpx', 'meanIMTGoldStandard', 'meanIMTPxGoldStandard');
