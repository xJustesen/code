clear all; close all
datpath = '/home/christian/Dropbox/speciale/data/';

%% AVG INTENSITY SPECTRUM
I_80_woschot = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles80GeV_1.5mm_full_peak_alt_woshot.txt');
I_80_worr    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles80GeV_1.5mm_full_peak_alt_worr.txt');
I_80_full    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles80GeV_1.5mm_full_peak_alt.txt');
I_80_worr_new    = load('/home/christian/Dropbox/Cern2018Experiment/spectre/sum_angles1.5mm80GeVbaiernoRR.txt');


I_40_woschot = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles40GeV_1.5mm_full_peak_alt_woshot.txt');
I_40_worr    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles40GeV_1.5mm_full_peak_alt_worr.txt');
I_40_full    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles40GeV_1.5mm_full_peak_alt.txt');
I_40_worr_new    = load('/home/christian/Dropbox/Cern2018Experiment/spectre/sum_angles1.5mm40GeVbaiernoRR.txt');

I_20_woschot = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles20GeV_1.5mm_full_peak_alt_woshot.txt');
I_20_worr    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles20GeV_1.5mm_full_peak_alt_worr.txt');
I_20_full    = load('/home/christian/Dropbox/speciale/code/crystalSimulations/sum_angles20GeV_1.5mm_full_peak_alt.txt');
I_20_worr_new    = load('/home/christian/Dropbox/Cern2018Experiment/spectre/sum_angles1.5mm20GeVbaiernoRR.txt');
% avg_I_sim = load([datpath,'photon_energy_sim.txt']);

% avg_I = load('sum_angles1mm40GeVelec.txt');
I_80_woschot(1:5) = [];
I_80_worr(1:5) = [];
I_80_full(1:5) = [];

I_40_woschot(1:5) = [];
I_40_worr(1:5) = [];
I_40_full(1:5) = [];

I_20_woschot(1:5) = [];
I_20_worr(1:5) = [];
I_20_full(1:5) = [];


E_80 = linspace(0, 80, length(I_80_woschot))';
E_40 = linspace(0, 40, length(I_40_woschot))';
E_20 = linspace(0, 20, length(I_20_woschot))';

colors =    [       0    0.4470    0.7410
                0.8500    0.3250    0.0980
                0.9290    0.6940    0.1250
                0.4940    0.1840    0.5560
                0.4660    0.6740    0.1880
                0.3010    0.7450    0.9330
                0.6350    0.0780    0.1840
            ];

f = figure;
subplot(3,1,1)
title('a)','fontsize',14,'interpreter','latex')
hold on
plot(E_20, I_20_full/1.5,'-','linewidth',2.5)
plot(E_20, I_20_woschot/1.5,'--','linewidth',2.5)
plot(E_20, I_20_worr/1.5,':','linewidth',2.5)
box on
grid on
subplot(3,1,2)
title('b)','fontsize',14,'interpreter','latex')
hold on
plot(E_40, I_40_full/1.5,'-','linewidth',2.5)
plot(E_40, I_40_woschot/1.5,'--','linewidth',2.5)
plot(E_40, I_40_worr/1.5,':','linewidth',2.5)
ylabel('$dP/d\hbar\omega$','fontsize',22,'interpreter','latex')
box on
grid on
subplot(3,1,3)
title('c)','fontsize',14,'interpreter','latex')
hold on
plot(E_80, I_80_full/1.5,'-','linewidth',2.5)
plot(E_80, I_80_woschot/1.5,'--','linewidth',2.5)
plot(E_80, I_80_worr/1.5,':','linewidth',2.5)
xlabel('E [GeV]','fontsize',22,'interpreter','latex')
box on
grid on

figure
hold on
plot(E_20, I_20_worr/1.5,'-','linewidth',2.5)
plot(E_40, I_40_worr/1.5,'-','linewidth',2.5)
plot(E_80, I_80_worr/1.5,'-','linewidth',2.5)
plot(I_20_worr_new(:,1), I_20_worr_new(:,2)/1.5,'-x','linewidth',2.5,'color',colors(1,:))
plot(I_40_worr_new(:,1), I_40_worr_new(:,2)/1.5,'-x','linewidth',2.5,'color',colors(2,:))
plot(I_80_worr_new(:,1), I_80_worr_new(:,2)/1.5,'-x','linewidth',2.5,'color',colors(3,:))


% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 12],'PaperPosition',[0, 0, 18, 12],'Position',[0 0 18 12])
% print('/home/christian/Dropbox/Cern2018Experiment/figures/theory_compare', '-dpdf','-r600','-painters')


%% ENERGY vs ANGLE SPECTRUM
dat = load('../crystalSimulations/sum_initials40GeV_full_peak.txt');
datsim = load('/media/christian/Elements/DataAnalysis/radiation/spectres/sum_initials80GeV_1.5mm_full_peak_alt_woshot.txt');
datsim = datsim';

angles = dat(4:5, :)';

dat(1:5, :) = [];
dat = dat';

% i = dat(:,3); a1 = angles(1:100,1); a2 = a1; isim = datsim(:,3);
% i = reshape(i, 100, 100); isim = reshape(isim, 100, 100);
% 
% datsim2 = load('/home/christian/Dropbox/speciale/data/photon_angles.txt');
% N = hist3(datsim2,'Nbins',[100,100]);
% 
% f = figure;
% imagesc(dat)
% 
% f = figure;
% spy(i-isim)
% 
% 
% [A1, A2] = meshgrid(a1, a2);
% 
% f = figure
% hold on
% contourf(A1, A2, i, 1000, 'edgecolor','none');
% colorbar
% xlabel('$\theta\quad [\mathrm{rad}]$','fontsize',15,'interpreter','latex')
% ylabel('$\phi\quad [\mathrm{rad}]$','fontsize',15,'interpreter','latex')
% title('DATA (specific energy)','fontsize',25,'interpreter','latex')
% axis equal
% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 12],'PaperPosition',[0, 0, 18, 12],'Position',[0 0 18 12])
% print('../../figures/angle_spec.pdf', '-dpdf','-r600','-painters')
% 
% f = figure
% hold on
% contourf(A1, A2, N, 1000, 'edgecolor','none');
% colorbar
% xlabel('$\theta\quad [\mathrm{rad}]$','fontsize',15,'interpreter','latex')
% ylabel('$\phi\quad [\mathrm{rad}]$','fontsize',15,'interpreter','latex')
% title('SIMULATION (across all energies)','fontsize',25,'interpreter','latex')
% axis equal
% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 12],'PaperPosition',[0, 0, 18, 12],'Position',[0 0 18 12])
% % print('../../figures/angle_spec.pdf', '-dpdf','-r600','-painters')

