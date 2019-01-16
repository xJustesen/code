clear all; close all; clear all;
datpath = '/home/christian/Documents/cern2018/simdata/';

runs_dat = 44;
sim = 1:1;
angles = linspace(-2e-3, 2e-3, 200);
angx_tot = [];
angy_tot = [];
angx_tot_sim = [];
angy_tot_sim = [];
posx_tot = [];
posy_tot = [];

for i = runs_dat
    % Load data
    field = strcat('run_',num2str(i));
    filepath = strcat(datpath,'beam_divergence_',num2str(i),'.txt');
    dat = load(filepath);
    
    angx = dat(:,1);
    angy = dat(:,2);
    
    % Save angles and positions in matrix
    angx_tot = [angx_tot; angx];
    angy_tot = [angy_tot; angy];
end

for i = sim
    filepath = strcat(datpath,['beam_divergence_sim_amorphous1_80GeV_04012019.txt']);
    datsim = load(filepath);
    
    angxsim = datsim(:,1);
    angysim = datsim(:,2);
    
    % Save angles and positions in matrix
    angx_tot_sim = [angx_tot_sim; angxsim];
    angy_tot_sim = [angy_tot_sim; angysim];
end


% fakerun = load(strcat(datpath,'angles_M1M2_',num2str(4),'.txt'));

% Make histogram for combined runs
[ang_counts_x_tot, ~] = hist(angx_tot(angx_tot > angles(1) & angx_tot < angles(end)), angles);
[ang_counts_y_tot, ~] = hist(angy_tot(angy_tot > angles(1) & angy_tot < angles(end)), angles);
ang_counts_x_tot = ang_counts_x_tot.';
ang_counts_y_tot = ang_counts_y_tot.';

[ang_counts_x_tot_sim, ~] = hist(angx_tot_sim(angx_tot_sim > angles(1) & angx_tot_sim < angles(end)), angles);
[ang_counts_y_tot_sim, ~] = hist(angy_tot_sim(angy_tot_sim > angles(1) & angy_tot_sim < angles(end)), angles);
ang_counts_x_tot_sim = ang_counts_x_tot_sim.';
ang_counts_y_tot_sim = ang_counts_y_tot_sim.';

angles = angles.';

% 

yfit_fakes = fit(angles(ang_counts_y_tot < 1.5 * median(sort(ang_counts_y_tot))), ang_counts_y_tot(ang_counts_y_tot < 1.5 * median(sort(ang_counts_y_tot))),'poly2');
xfit_fakes = fit(angles(ang_counts_x_tot < 1.5 * median(sort(ang_counts_x_tot))), ang_counts_x_tot(ang_counts_x_tot < 1.5 * median(sort(ang_counts_x_tot))),'poly2');

xfit = fit(angles, ang_counts_x_tot - xfit_fakes(angles), 'gauss1');
yfit = fit(angles, ang_counts_y_tot - yfit_fakes(angles), 'gauss1');
    
x = linspace(min(angles), max(angles), 1000);
counts_x_interp = interp1(angles, ang_counts_x_tot, x);
% Find the half max value.
halfMax = (min(xfit(x)) + max(xfit(x))) / 2;
% Find where the data first drops below half the max.
xl = x(find(xfit(x) >= halfMax, 1, 'first'));
xr = x(find(xfit(x) >= halfMax, 1, 'last'));
fwhmx = xr - xl;
    
y = linspace(min(angles), max(angles), 1000);
counts_y_interp = interp1(angles, ang_counts_y_tot, y);
halfMax = (min(yfit(y)) + max(yfit(y))) / 2;
% Find where the data first drops below half the max.
yl = y(find(yfit(y) >= halfMax, 1, 'first'));
yr = y(find(yfit(y) >= halfMax, 1, 'last'));
fwhmy = yr - yl;

norm_cumsum_x = cumsum(counts_x_interp)/max(cumsum(counts_x_interp));
lb_x = max(x(norm_cumsum_x < 0.25));
ub_x = min(x(norm_cumsum_x > 0.75));

norm_cumsum_y = cumsum(counts_y_interp)/max(cumsum(counts_y_interp));
lb_y = max(y(norm_cumsum_y < 0.25));
ub_y = min(y(norm_cumsum_y > 0.75));

insideCountsx = sum(counts_x_interp(x > lb_x & x < ub_x));
outsideCountsx = sum(counts_x_interp(x < lb_x)) + sum(counts_x_interp(x > ub_x));

insideCountsy = sum(counts_y_interp(y > lb_y & y < ub_y));
outsideCountsy = sum(counts_y_interp(y < lb_y)) + sum(counts_y_interp(y > ub_y));

disp(['xmean = ',num2str(x(xfit(x) == max(xfit(x)))),' ; fwhmx = ', num2str(fwhmx), ' ; stddev = ', num2str(fwhmx/(2*sqrt(2*log(2))))]);
disp(['inside counts = ',num2str(insideCountsx),' ; outside counts = ',num2str(outsideCountsx),' ; inside/outside = ', num2str(insideCountsx/outsideCountsx)]);
disp(['left limit = ',num2str(lb_x),' ; right limit = ',num2str(ub_x)]);
disp(['relative left limit = ', num2str(abs(lb_x - x(xfit(x) == max(xfit(x))))),' ; relative right limit = ', num2str(abs(ub_x - x(xfit(x) == max(xfit(x)))))])

disp(newline)
disp(['ymean = ',num2str(y(yfit(y) == max(yfit(y)))),' ; fwhmy = ', num2str(fwhmy), ' ; stddev = ', num2str(fwhmy/(2*sqrt(2*log(2))))]);
disp(['inside counts = ',num2str(insideCountsy),' ; outside counts = ',num2str(outsideCountsy),' ; inside/outside = ', num2str(insideCountsy/outsideCountsy)]);
disp(['left limit = ',num2str(lb_y),' ; right limit = ',num2str(ub_y)]);
disp(['relative left limit = ', num2str(abs(lb_y - y(yfit(y) == max(yfit(y))))),' ; relative right limit = ', num2str(abs(ub_y - y(yfit(y) == max(yfit(y)))))])

f = figure;
subplot(2,1,1)
hold on
box on
grid on
plot(angles, ang_counts_x_tot/max(ang_counts_x_tot),'-','linewidth',2.5);
plot(angles, ang_counts_y_tot/max(ang_counts_x_tot),'-','linewidth',2.5);
plot(angles, (ang_counts_x_tot_sim - xfit_fakes(angles))/max((ang_counts_x_tot_sim - xfit_fakes(angles))),'-','linewidth',2.5);
plot(angles, (ang_counts_y_tot_sim - yfit_fakes(angles))/max((ang_counts_x_tot_sim - xfit_fakes(angles))),'-','linewidth',2.5);
set(gca, 'FontSize', 24)
xlabel('Angle [rad]','fontsize',36,'interpreter','latex');ylabel('Normalized counts','fontsize',36,'interpreter','latex');
legend({'x','y'},'interpreter','latex','fontsize',36);
ax = gca;
ax.XAxis.Exponent = -6;
title('a) incl. fakes','fontsize',36,'interpreter','latex');

subplot(2,1,2)
hold on
box on
grid on
plot(angles, (ang_counts_x_tot - xfit_fakes(angles))/max((ang_counts_x_tot - xfit_fakes(angles))),'-','linewidth',2.5);
plot(angles, (ang_counts_y_tot - yfit_fakes(angles))/max((ang_counts_x_tot - xfit_fakes(angles))),'-','linewidth',2.5);
plot(angles, (ang_counts_x_tot_sim - xfit_fakes(angles))/max((ang_counts_x_tot_sim - xfit_fakes(angles))),'-','linewidth',2.5);
plot(angles, (ang_counts_y_tot_sim - yfit_fakes(angles))/max((ang_counts_x_tot_sim - xfit_fakes(angles))),'-','linewidth',2.5);
set(gca, 'FontSize', 24)
xlabel('Angle [rad]','fontsize',36,'interpreter','latex'); ylabel('Normalized counts','fontsize',36,'interpreter','latex');
legend({'x','y'},'interpreter','latex','fontsize',36);
ylim([0, 2]);
ax = gca;
ax.XAxis.Exponent = -6;
title('b) excl. fakes','fontsize',36,'interpreter','latex');

% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 12],'PaperPosition',[0, 0, 18, 12],'Position',[0 0 18 12])
% print(f, '../../figures/div_80GeV_1.5mm_nofakes.pdf', '-dpdf','-r600','-painters')

set(f,'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[24, 36],'PaperPosition',[0, 0, 24, 36],'Position',[0 0 24 36])
% print(f, '../../presentation/figures/div_80GeV.svg', '-dsvg','-r600','-painters')

xw = (ang_counts_x_tot - xfit_fakes(angles))/max((ang_counts_x_tot - xfit_fakes(angles)));
yw = (ang_counts_y_tot - yfit_fakes(angles))/max((ang_counts_x_tot - xfit_fakes(angles)));

xw(xw < 1e-03) = 0;
yw(yw < 1e-03) = 0;

% save('../beamParameters/angle_xweight_80GeV_beam_params.txt', 'xw','-ascii');
% save('../beamParameters/angle_yweight_80GeV_beam_params.txt', 'yw','-ascii');
% save('../beamParameters/angles.txt', 'angles','-ascii');