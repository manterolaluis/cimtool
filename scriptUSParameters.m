%Perfil 
profileUS(2).frequence = 10;
profileUS(2).P = 2;
profileUS(2).mmpx = 0.042;
profileUS(2).gain = 82;

profileUS(3).frequence = 10;
profileUS(3).P = 3;
profileUS(3).mmpx = 0.063;
profileUS(3).gain = 82;

profileUS(4).frequence = 10;
profileUS(4).P = 4;
profileUS(4).mmpx = 0.084912;
%(0018,602C)	PhysicalDeltaX	0.0084912076271186443
profileUS(4).gain = 82;

profileUS(5).frequence = 10;
profileUS(5).P = 5;
profileUS(5).mmpx = 0.105956;
%(0018,602C)	PhysicalDeltaX	0.010595656779661016
profileUS(5).gain = 43;

% figure('Name','mmpx vs P');
% hold on
% for i=1:5
%     plot(profileUS(i).P,profileUS(i).mmpx,'*');
% end
% hold off;
% axis([1 profileUS(5).P+1 0 profileUS(5).mmpx+0.05]);
% xlabel('P'); ylabel('mmpx');

global mmpx
P = 4;
frequence = profileUS(P).frequence;
mmpx = profileUS(P).mmpx;
gain = profileUS(P).gain;