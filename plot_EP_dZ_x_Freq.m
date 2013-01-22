% $$$ Freq = [475, 375, 1225, 825, 1575, 1775, 1125, 1875, 875,...
% $$$         425, 1425, 1975, 575, 725, 525, 225, 1725, 1625,...
% $$$         1075, 1825, 325, 1325, 1025, 1325, 1025, 1275, 1475,...
% $$$         1925, 675];
% $$$ nFreq = length(Freq);
%%%

nFreq = 29;
Freq = zeros(nFreq,1);

EP_peak = zeros(nFreq,1);
dZ_pos_peak = zeros(nFreq,1);
dZ_neg_peak = zeros(nFreq,1);

Fs = 16384;
T = 1e3*((1:Fs/2)/Fs-.15);    

iRat = 32;
iElec = 14;

for iEIT=1:nFreq
    load(sprintf('Rat_%03i_EIT_%03i.mat',iRat,iEIT),'EP','dZ','info')
    Freq(iEIT) = info.Fc;
    EP = mean(EP{iElec},2);
    dZ = mean(dZ{iElec},2);
    EP_peak(iEIT) = max(EP(T>0 & T<20));
    dZ_pos_peak(iEIT) = max(dZ(T>0 & T<20));
    dZ_neg_peak(iEIT) = min(dZ(T>0 & T<20));
end

sel = EP_peak>800;

[r,p] = corrcoef(Freq(sel),EP_peak(sel))

figure
plot(Freq(sel),EP_peak(sel),'o')
xlim([0,2200])
ylim([0,2e3])
xlabel('Fc (Hz)')
ylabel('EP amplitude (uV)')
title(sprintf('Rat %03i: r=%.2f, p=%.2g',iRat,r(2,1),p(2,1)))
saveas(gcf,sprintf('Rat_%03i_EP_x_Freq.png',iRat))

sel2 = sel & Freq>1100;
[r1,p1] = corrcoef(Freq(sel2),dZ_pos_peak(sel2));
[r2,p2] = corrcoef(Freq(sel2),dZ_neg_peak(sel2));

figure('Position',[1000,200,560,850])
subplot(2,1,1)
plot(Freq(sel),dZ_pos_peak(sel),'o')
xlim([0,2200])
xlabel('Fc (Hz)')
ylabel('Pos. dZ peak (uV)')
title(sprintf('Rat %03i: r=%.2f, p=%.2g',iRat,r1(2,1),p1(2,1)))
subplot(2,1,2)
plot(Freq(sel),dZ_neg_peak(sel),'o')
xlim([0,2200])
ylim([-10,0])
xlabel('Fc (Hz)')
ylabel('Neg. dZ peak (uV)')
title(sprintf('Rat %03i: r=%.2f, p=%.2g',iRat,r2(2,1),p2(2,1)))
saveas(gcf,sprintf('Rat_%03i_dZ_x_Freq.png',iRat))

    