clear all; close all; clc;
global datpath;
datpath = '/home/christian/Dropbox/Cern2018Experiment/spectre/';

Em = 0.511;
Na = 6.022*10^23;
alpha = 1/137;
r0 = 2.8*10^-15;
di_density = 3.520*10^6;
di_m = 12.0107;
di_Z = 6;
di_d = 3.57; % Å
e2 = 14.4; % e² i eVÅ

crit_angle_20 = sqrt(4 * di_Z * e2 / (20000 * di_d * 1e-6)) % se Allan's NIMB artikel
crit_angle_40 = crit_angle_20 * sqrt(1/2)
crit_angle_80 = crit_angle_20 * sqrt(1/4)

E20 = linspace(0,20,20);
E40 = linspace(0,40,40);
E80 = linspace(0,80,60);

fprintf('Loading data\n')
%% 20 GeV data+sim
% DATA 1mm
counts_dat_20GeV_bg_norm_tot = spectrum('energy_', '.txt', [105:108, 110, 111]);
data_bg_20GeV_1mm = hist(counts_dat_20GeV_bg_norm_tot(counts_dat_20GeV_bg_norm_tot < max(E20) & counts_dat_20GeV_bg_norm_tot > min(E20)), E20);
counts_dat_20GeV_amorph_norm_tot = spectrum('energy_', '.txt', [109,115]);

counts_dat_20GeV_aligned_norm_tot = spectrum('energy_','.txt',[103, 104, 112:114]);
data_align_20GeV_1mm = hist(counts_dat_20GeV_aligned_norm_tot(counts_dat_20GeV_aligned_norm_tot < max(E20) & counts_dat_20GeV_aligned_norm_tot > min(E20)), E20);
data_align_20GeV_1mm_err = E20 .* sqrt(data_align_20GeV_1mm/(876217+467348+286232+258194+74259)^2 + data_bg_20GeV_1mm/(324000+590172+624602+734446+1415716+1224254)^2);
data_align_20GeV_1mm = E20 .* (data_align_20GeV_1mm/(876217+467348+286232+258194+74259) - data_bg_20GeV_1mm/(324000+590172+624602+734446+1415716+1224254));

% % DATA 1.5mm
counts_dat_20GeV_bg_1_5mm_norm_tot = spectrum('energy_', '.txt', [60,65] );
data_bg_20GeV_1_5mm = hist(counts_dat_20GeV_bg_1_5mm_norm_tot(counts_dat_20GeV_bg_1_5mm_norm_tot < max(E20) & counts_dat_20GeV_bg_1_5mm_norm_tot > min(E20)), E20);
counts_dat_20GeV_amorph_1_5mm_norm_tot = spectrum('energy_', '.txt', 66:69 );

counts_dat_20GeV_aligned_norm_tot_1_5mm = spectrum('energy_', '.txt',61:64);
data_align_20GeV_1_5mm = hist(counts_dat_20GeV_aligned_norm_tot_1_5mm(counts_dat_20GeV_aligned_norm_tot_1_5mm < max(E20) & counts_dat_20GeV_aligned_norm_tot_1_5mm > min(E20)), E20);
data_align_20GeV_1_5mm_err = E20 .* sqrt(data_align_20GeV_1_5mm/(174257+474970+876508+792574)^2 + data_bg_20GeV_1_5mm/(812417 + 2530699)^2);
data_align_20GeV_1_5mm = E20 .* (data_align_20GeV_1_5mm/(174257+474970+876508+792574) - data_bg_20GeV_1_5mm/(812417 + 2530699));
fprintf('\t 20 GeV CERN data loaded\n')

% % SIM 1mm
counts_sim_20GeV_bg_norm = spectrum('energy_sim_background', '_20GeV.txt', []);
sim_bg_20GeV_1mm = hist(counts_sim_20GeV_bg_norm(counts_sim_20GeV_bg_norm < max(E20) & counts_sim_20GeV_bg_norm > min(E20)), E20);
counts_sim_20GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_20GeV.txt', []);

counts_sim_20GeV_aligned_RR = spectrum('energy_sim_aligned', '_20GeV_test.txt',  []);
sim_align_20GeV_1mm_RR = hist(counts_sim_20GeV_aligned_RR(counts_sim_20GeV_aligned_RR < max(E20) & counts_sim_20GeV_aligned_RR > min(E20)), E20);
sim_align_20GeV_1mm_RR = E20 .* (sim_align_20GeV_1mm_RR / 5e6 - sim_bg_20GeV_1mm / 1e8);
% 
% % SIM 1.5mm
counts_sim_20GeV_bg_norm_1_5mm = spectrum('energy_sim_background', '_20GeV_1.5mm.txt', []);
sim_bg_20GeV_1_5mm = hist(counts_sim_20GeV_bg_norm_1_5mm(counts_sim_20GeV_bg_norm_1_5mm < max(E20) & counts_sim_20GeV_bg_norm_1_5mm > min(E20)), E20);
counts_sim_20GeV_amorph_bg_norm_1_5mm = spectrum('energy_sim_amorphous', '_20GeV_1.5mm.txt', []);

counts_sim_20GeV_aligned_RR_1_5mm = spectrum('energy_sim_aligned', '_20GeV_1.5mm_test.txt',  []);
sim_align_20GeV_1_5mm_RR = hist(counts_sim_20GeV_aligned_RR_1_5mm(counts_sim_20GeV_aligned_RR_1_5mm < max(E20) & counts_sim_20GeV_aligned_RR_1_5mm > min(E20)), E20);
sim_align_20GeV_1_5mm_RR = E20 .* (sim_align_20GeV_1_5mm_RR / 5e6 - sim_bg_20GeV_1_5mm / 1e8);

% counts_sim_20GeV_aligned_1_5mm_norm_woshot = spectrum(E20, 'energy_sim_aligned', '_20GeV_woshot_1.5mm.txt', [], 25e7,datpath);
% counts_sim_20GeV_aligned_1_5mm_norm_worr = spectrum(E20, 'energy_sim_aligned', '_20GeV_worr_1.5mm.txt', [], 25e7,datpath);
% counts_sim_20GeV_aligned_1_5mm_norm = spectrum(E20, 'energy_sim_aligned', '_20GeV_1.5mm.txt', [], 25e7,datpath);
fprintf('\t 20 GeV SIM data loaded\n')

%% 40 GeV data+sim
% DATA 1mm
counts_dat_40GeV_bg_norm = spectrum('energy_', '.txt', 74);
data_bg_40GeV_1mm = hist(counts_dat_40GeV_bg_norm(counts_dat_40GeV_bg_norm < max(E40) & counts_dat_40GeV_bg_norm > min(E40)), E40);
counts_dat_40GeV_amorph_norm_tot = spectrum('energy_', '.txt', [73 75:78]);

counts_dat_40GeV_aligned_norm_tot = spectrum('energy_', '.txt', [71 72 79:81]);
data_align_40GeV_1mm = hist(counts_dat_40GeV_aligned_norm_tot(counts_dat_40GeV_aligned_norm_tot < max(E40) & counts_dat_40GeV_aligned_norm_tot > min(E40)), E40);
data_align_40GeV_1mm_err = E40 .* sqrt(data_align_40GeV_1mm/(142959+473324+460625+1288624+1275493)^2 + data_bg_40GeV_1mm/(3029506)^2);
data_align_40GeV_1mm = E40 .* (data_align_40GeV_1mm / (142959 + 473324 + 460625 + 1288624 + 1275493) - data_bg_40GeV_1mm/3029506);

% DATA 1.5mm
counts_dat_40GeV_amorph_norm_tot_1_5mm = spectrum('energy_', '.txt', [32:34 39:41 43]);
counts_dat_40GeV_bg_norm_1_5mm = spectrum('energy_', '.txt', 31);
data_bg_40GeV_1_5mm = hist(counts_dat_40GeV_bg_norm_1_5mm(counts_dat_40GeV_bg_norm_1_5mm < max(E40) & counts_dat_40GeV_bg_norm_1_5mm > min(E40)), E40);

counts_dat_40GeV_aligned_norm_tot_1_5mm = spectrum('energy_', '.txt', [30 35:38]);
data_align_40GeV_1_5mm = hist(counts_dat_40GeV_aligned_norm_tot_1_5mm(counts_dat_40GeV_aligned_norm_tot_1_5mm < max(E40) & counts_dat_40GeV_aligned_norm_tot_1_5mm > min(E40)), E40);
data_align_40GeV_1_5mm_err = E40 .* sqrt(data_align_40GeV_1_5mm/(172307+435890+538900+363630+209144)^2 + data_bg_40GeV_1_5mm/(2771773)^2);
data_align_40GeV_1_5mm = E40 .* (data_align_40GeV_1_5mm / (172307+435890+538900+363630+209144)  - data_bg_40GeV_1_5mm/2771773);
fprintf('\t 40 GeV CERN data loaded\n')

% SIM 1mm
counts_sim_40GeV_bg_norm = spectrum('energy_sim_background', '_40GeV.txt', []);
sim_bg_40GeV_1mm = hist(counts_sim_40GeV_bg_norm(counts_sim_40GeV_bg_norm < max(E40) & counts_sim_40GeV_bg_norm > min(E40)), E40);
counts_sim_40GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_40GeV.txt', []);

counts_sim_40GeV_aligned_norm_woshot = spectrum('energy_sim_aligned', '_40GeV_woshot_test.txt', []);
counts_sim_40GeV_aligned_norm_worr = spectrum('energy_sim_aligned', '_40GeV_worr_test.txt', []);
counts_sim_40GeV_aligned_norm = spectrum('energy_sim_aligned', '_40GeV_test.txt', []);
sim_align_40GeV_1mm_RR = hist(counts_sim_40GeV_aligned_norm(counts_sim_40GeV_aligned_norm < max(E40) & counts_sim_40GeV_aligned_norm > min(E40)), E40);
sim_align_40GeV_1mm_RR = E40 .* (sim_align_40GeV_1mm_RR / 5e6 - sim_bg_40GeV_1mm / 1e8);
sim_align_40GeV_1mm_noRR = hist(counts_sim_40GeV_aligned_norm_worr(counts_sim_40GeV_aligned_norm_worr < max(E40) & counts_sim_40GeV_aligned_norm_worr > min(E40)), E40);
sim_align_40GeV_1mm_noRR = E40 .* (sim_align_40GeV_1mm_noRR / 5e6 - sim_bg_40GeV_1mm / 1e8);
sim_align_40GeV_1mm_noSH = hist(counts_sim_40GeV_aligned_norm_woshot(counts_sim_40GeV_aligned_norm_woshot < max(E40) & counts_sim_40GeV_aligned_norm_woshot > min(E40)), E40);
sim_align_40GeV_1mm_noSH = E40 .* (sim_align_40GeV_1mm_noSH / 5e6 - sim_bg_40GeV_1mm / 1e8);

% SIM 1.5mm
counts_sim_40GeV_bg_norm_1_5mm = spectrum('energy_sim_background', '_40GeV_1.5mm.txt', []);
sim_bg_40GeV_1_5mm = hist(counts_sim_40GeV_bg_norm_1_5mm(counts_sim_40GeV_bg_norm_1_5mm < max(E40) & counts_sim_40GeV_bg_norm_1_5mm > min(E40)), E40);
counts_sim_40GeV_amorph_bg_norm_1_5mm = spectrum('energy_sim_amorphous', '_40GeV_1.5mm.txt', []);

counts_sim_40GeV_aligned_1_5mm_norm = spectrum('energy_sim_aligned', '_40GeV_1.5mm_test.txt', []);
sim_align_40GeV_1_5mm_RR = hist(counts_sim_40GeV_aligned_1_5mm_norm(counts_sim_40GeV_aligned_1_5mm_norm < max(E40) & counts_sim_40GeV_aligned_1_5mm_norm > min(E40)), E40);
sim_align_40GeV_1_5mm_RR = E40 .* (sim_align_40GeV_1_5mm_RR / 5e6 - sim_bg_40GeV_1_5mm / 1e8);

% counts_sim_40GeV_aligned_1_5mm_norm_woshot = spectrum(E40, 'energy_sim_aligned', '_40GeV_woshot_1.5mm.txt',  [], 25e7);
% counts_sim_40GeV_aligned_1_5mm_norm_worr = spectrum(E40, 'energy_sim_aligned', '_40GeV_worr_1.5mm.txt', [], 25e7);
fprintf('\t 40 GeV SIM data loaded\n')

%% 80 GeV data+sim
% DAT 1mm
counts_dat_80GeV_bg_norm = spectrum('energy_', '.txt', [85 90 91]);
data_bg_80GeV_1mm = hist(counts_dat_80GeV_bg_norm(counts_dat_80GeV_bg_norm < max(E80) & counts_dat_80GeV_bg_norm > min(E80)), E80);
counts_dat_80GeV_amorph_norm_tot = spectrum('energy_', '.txt', 86:89);

counts_dat_80GeV_aligned_norm_tot = spectrum('energy_', '.txt', [84 92:95]);
data_align_80GeV_1mm = hist(counts_dat_80GeV_aligned_norm_tot(counts_dat_80GeV_aligned_norm_tot < max(E80) & counts_dat_80GeV_aligned_norm_tot > min(E80)), E80);
data_align_80GeV_1mm_err = E80 .* sqrt(data_align_80GeV_1mm/(1134032+462880+943921+1833415+35424)^2 + data_bg_80GeV_1mm/(1911215+1892132+1219189)^2);
data_align_80GeV_1mm = E80 .* (data_align_80GeV_1mm / (1134032 + 462880 + 943921 + 1833415 + 35424) - data_bg_80GeV_1mm/(1911215+1892132+1219189));

% DATA 1.5mm
counts_dat_80GeV_bg_norm_1_5mm_tot = spectrum('energy_', '.txt', [48 54 55]);
data_bg_80GeV_1_5mm = hist(counts_dat_80GeV_bg_norm_1_5mm_tot(counts_dat_80GeV_bg_norm_1_5mm_tot < max(E80) & counts_dat_80GeV_bg_norm_1_5mm_tot > min(E80)), E80);
counts_dat_80GeV_amorph_norm_1_5mm_tot = spectrum('energy_', '.txt', [49:53 56 57]);

counts_dat_80GeV_aligned_norm_1_5mm_tot = spectrum('energy_', '.txt', [46, 47]);
data_align_80GeV_1_5mm = hist(counts_dat_80GeV_aligned_norm_1_5mm_tot(counts_dat_80GeV_aligned_norm_1_5mm_tot < max(E80) & counts_dat_80GeV_aligned_norm_1_5mm_tot > min(E80)), E80);
data_align_80GeV_1_5mm_err = E80 .* sqrt(data_align_80GeV_1_5mm/(431667+942149)^2 + data_bg_80GeV_1_5mm/(2497897 + 312302 + 216860)^2);
data_align_80GeV_1_5mm = E80 .* (data_align_80GeV_1_5mm / (431667+942149) - data_bg_80GeV_1_5mm/(2497897 + 312302 + 216860));
fprintf('\t 80 GeV CERN data loaded\n')

% SIM 1mm
counts_sim_80GeV_bg_norm = spectrum('energy_sim_background', '_80GeV.txt', []);
sim_bg_80GeV_1mm = hist(counts_sim_80GeV_bg_norm(counts_sim_80GeV_bg_norm < max(E80) & counts_sim_80GeV_bg_norm > min(E80)), E80);
counts_sim_80GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_80GeV.txt', []);

counts_sim_80GeV_aligned_noSH = spectrum('energy_sim_aligned', '_80GeV_woshot_test.txt', []);
sim_align_80GeV_1mm_noSH = hist(counts_sim_80GeV_aligned_noSH(counts_sim_80GeV_aligned_noSH < max(E80) & counts_sim_80GeV_aligned_noSH > min(E80)), E80);
sim_align_80GeV_1mm_noSH = E80 .* (sim_align_80GeV_1mm_noSH / 5e6 - sim_bg_80GeV_1mm / 1e8);
counts_sim_80GeV_aligned_noRR = spectrum('energy_sim_aligned', '_80GeV_worr_test.txt',  []);
sim_align_80GeV_1mm_noRR = hist(counts_sim_80GeV_aligned_noRR(counts_sim_80GeV_aligned_noRR < max(E80) & counts_sim_80GeV_aligned_noRR > min(E80)), E80);
sim_align_80GeV_1mm_noRR = E80 .* (sim_align_80GeV_1mm_noRR / 5e6 - sim_bg_80GeV_1mm / 1e8);
counts_sim_80GeV_aligned_RR = spectrum('energy_sim_aligned', '_80GeV_test.txt',  []);
sim_align_80GeV_1mm_RR = hist(counts_sim_80GeV_aligned_RR(counts_sim_80GeV_aligned_RR < max(E80) & counts_sim_80GeV_aligned_RR > min(E80)), E80);
sim_align_80GeV_1mm_RR = E80 .* (sim_align_80GeV_1mm_RR / 5e6 - sim_bg_80GeV_1mm / 1e8);

% SIM 1.5mm
counts_sim_80GeV_amorph_bg_1_5mm_norm = spectrum('energy_sim_amorphous', '_80GeV_1.5mm.txt', []);
counts_sim_80GeV_bg_1_5mm_norm = spectrum('energy_sim_background', '_80GeV_1.5mm.txt', []);
counts_sim_80GeV_aligned_RR_1_5mm = spectrum('energy_sim_aligned', '_80GeV_1.5mm_test.txt',  []);
sim_bg_80GeV_1_5mm = hist(counts_sim_80GeV_bg_1_5mm_norm(counts_sim_80GeV_bg_1_5mm_norm < max(E80) & counts_sim_80GeV_bg_1_5mm_norm > min(E80)), E80);
sim_align_80GeV_1_5mm_RR = hist(counts_sim_80GeV_aligned_RR_1_5mm(counts_sim_80GeV_aligned_RR_1_5mm < max(E80) & counts_sim_80GeV_aligned_RR_1_5mm > min(E80)), E80);
sim_align_80GeV_1_5mm_RR = E80 .* (sim_align_80GeV_1_5mm_RR / 5e6 - sim_bg_80GeV_1_5mm / 1e8);

% counts_sim_80GeV_aligned_1_5mm_norm_woshot = spectrum(E80, 'energy_sim_aligned', '_80GeV_woshot_1.5mm.txt',  [], 25e7,altpath);
% counts_sim_80GeV_aligned_1_5mm_norm_worr = spectrum(E80, 'energy_sim_aligned', '_80GeV_worr_1.5mm.txt', [], 25e7,altpath);
% counts_sim_80GeV_aligned_1_5mm_norm = spectrum(E80, 'energy_sim_aligned', '_80GeV_1.5mm.txt',  [], 25e7,altpath);
fprintf('\t 80 GeV SIM data loaded\n')

%% Kalibering 
fprintf('Calculating callibration factors\n')
% 20 GeV
%1mm
[eff_20, ~, ~, ~, data_amorph_20GeV_1mm, sim_amorph_20GeV_1mm, data_amorph_20GeV_1mm_err] = calibrate(E20,...
                    counts_sim_20GeV_amorph_bg_norm,counts_sim_20GeV_bg_norm,...
                    counts_dat_20GeV_amorph_norm_tot, counts_dat_20GeV_bg_norm_tot,...
                    1e8, 2764454 + 82089, 324000 + 590172 + 624602 + 734446 + 1415716 + 1224254);

%1.5mm
[eff_20_1_5mm, ~, ~, ~, data_amorph_20GeV_1_5mm, sim_amorph_20GeV_1_5mm, data_amorph_20GeV_1_5mm_err] = calibrate(E20,...
                          counts_sim_20GeV_amorph_bg_norm_1_5mm,counts_sim_20GeV_bg_norm_1_5mm,...
                          counts_dat_20GeV_amorph_1_5mm_norm_tot,counts_dat_20GeV_bg_1_5mm_norm_tot,...
                          1e8, 1197107 + 432597 + 634614 + 386867, 812417 + 2530699);

% 40 GeV
%1mm
[eff_40, ~, ~, ~, data_amorph_40GeV_1mm, sim_amorph_40GeV_1mm, data_amorph_40GeV_1mm_err] = calibrate(E40,...
                          counts_sim_40GeV_amorph_bg_norm,counts_sim_40GeV_bg_norm,...
                          counts_dat_40GeV_amorph_norm_tot,counts_dat_40GeV_bg_norm,...
                          1e8, 1290988 + 1361162 + 1447462 + 715126 + 1456319, 3029506);

%1.5mm
[eff_40_1_5mm, ~, ~, ~, data_amorph_40GeV_1_5mm, sim_amorph_40GeV_1_5mm, data_amorph_40GeV_1_5mm_err] = calibrate(E40,...
                          counts_sim_40GeV_amorph_bg_norm_1_5mm,counts_sim_40GeV_bg_norm_1_5mm,...
                          counts_dat_40GeV_amorph_norm_tot_1_5mm,counts_dat_40GeV_bg_norm_1_5mm,...
                          1e8, 1449257 + 529097 + 724698 + 134167 + 692475 + 1694966 + 496471, 2771767);

% 80 GeV
%1mm
[eff_80, ~, ~, ~, data_amorph_80GeV_1mm, sim_amorph_80GeV_1mm, data_amorph_80GeV_1mm_err] = calibrate(E80,...
                          counts_sim_80GeV_amorph_bg_norm,counts_sim_80GeV_bg_norm,...
                          counts_dat_80GeV_amorph_norm_tot,counts_dat_80GeV_bg_norm,...
                          1e8, 1719461 + 1172521 + 1210722 + 538281, 1911215 + 1892132 + 1219189);

%1.5mm
[eff_80_1_5mm, ~, ~, ~, data_amorph_80GeV_1_5mm, sim_amorph_80GeV_1_5mm, data_amorph_80GeV_1_5mm_err] = calibrate(E80,...
                          counts_sim_80GeV_amorph_bg_1_5mm_norm,counts_sim_80GeV_bg_1_5mm_norm,...
                          counts_dat_80GeV_amorph_norm_1_5mm_tot,counts_dat_80GeV_bg_norm_1_5mm_tot,...
                          1e8, 873246 + 434680 + 847524 + 182889 + 18846 + 392613 + 495068, 2497897 + 312302 + 216860);
                      
fprintf('\n\t20 GeV\t40 GeV\t80 GeV\n%1.1fmm \t%1.3f \t%1.3f \t%1.3f\n%1.1fmm \t%1.3f \t%1.3f \t%1.3f\n',1, eff_20,eff_40,eff_80,1.5, eff_20_1_5mm,eff_40_1_5mm,eff_80_1_5mm);

%% Enhancement 
% 40 GeV
E = 40000;  
% 1mm
I_40_RR_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles40GeV1mmRR.txt'));
I_40_noSH_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles40GeV1mmnoSH.txt'));
I_40_noRR_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles40GeV1mmnoRR.txt'));
bremstrahlung_40GeV_1mm_RR = 1.00*1e-3*alpha*16/3*r0^2*(1-I_40_RR_1mm(:,1)./(E)+(I_40_RR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
bremstrahlung_40GeV_1mm_noRRnoSH = 1.00*1e-3*alpha*16/3*r0^2*(1-I_40_noRR_1mm(:,1)./(E)+(I_40_noRR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_40GeV_1mm = (data_align_40GeV_1mm)./(data_amorph_40GeV_1mm);
enhance_err_40GeV_1mm = abs(enhance_dat_40GeV_1mm) .* sqrt ((data_align_40GeV_1mm_err ./ data_align_40GeV_1mm).^2 +  (data_amorph_40GeV_1mm_err ./ data_amorph_40GeV_1mm).^2);

%1.5mm
I_40_RR_1_5mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles40GeV1_5mmRR.txt'));
bremstrahlung_40GeV_1_5mm_RR = 1.50*1e-3*alpha*16/3*r0^2*(1-I_40_RR_1_5mm(:,1)./(E)+(I_40_RR_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_40GeV_1_5mm = (data_align_40GeV_1_5mm)./(data_amorph_40GeV_1_5mm);
enhance_err_40GeV_1_5mm = abs(enhance_dat_40GeV_1_5mm) .* sqrt ((data_align_40GeV_1_5mm_err ./ data_align_40GeV_1_5mm).^2 +  (data_amorph_40GeV_1_5mm_err ./ data_amorph_40GeV_1_5mm).^2);

% 20 GeV
E = 20000;
% 1mm
I_20_RR_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles20GeV1mmRR.txt'));
bremstrahlung_20GeV_1mm = 1.00*1e-3*alpha*16/3*r0^2*(1-I_20_RR_1mm(:,1)./(E)+(I_20_RR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_20GeV_1mm = (data_align_20GeV_1mm)./(data_amorph_20GeV_1mm);
enhance_err_20GeV_1mm = abs(enhance_dat_20GeV_1mm) .* sqrt ((data_align_20GeV_1mm_err ./ data_align_20GeV_1mm).^2 +  (data_amorph_20GeV_1mm_err ./ data_amorph_20GeV_1mm).^2);

%1.5mm
I_20_RR_1_5mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles20GeV1_5mmRR.txt'));
bremstrahlung_20GeV_1_5mm_RR = 1.50*1e-3*alpha*16/3*r0^2*(1-I_20_RR_1_5mm(:,1)./(E)+(I_20_RR_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_20GeV_1_5mm = (data_align_20GeV_1_5mm)./(data_amorph_20GeV_1_5mm);
enhance_err_20GeV_1_5mm = abs(enhance_dat_20GeV_1_5mm) .* sqrt ((data_align_20GeV_1_5mm_err ./ data_align_20GeV_1_5mm).^2 +  (data_amorph_20GeV_1_5mm_err ./ data_amorph_20GeV_1_5mm).^2);

% 80 GeV
E = 80000;
%1mm
I_80_RR_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles80GeV1mmRR.txt'));
I_80_noSH_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles80GeV1mmnoSH.txt'));
I_80_noRR_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles80GeV1mmnoRR.txt'));
bremstrahlung_80GeV_1mm = 1.00*1e-3*alpha*16/3*r0^2*(1-I_80_RR_1mm(:,1)./(E)+(I_80_RR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_80GeV_1mm = (data_align_80GeV_1mm)./(data_amorph_80GeV_1mm);
enhance_err_80GeV_1mm = abs(enhance_dat_80GeV_1mm) .* sqrt ((data_align_80GeV_1mm_err ./ data_align_80GeV_1mm).^2 +  (data_amorph_80GeV_1mm_err ./ data_amorph_80GeV_1mm).^2);

%1.5mm
I_80_RR_1_5mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles80GeV1_5mmRR.txt'));
bremstrahlung_80GeV_1_5mm_RR = 1.50*1e-3*alpha*16/3*r0^2*(1-I_80_RR_1_5mm(:,1)./(E)+(I_80_RR_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_80GeV_1_5mm = (data_align_80GeV_1_5mm)./(data_amorph_80GeV_1_5mm);
enhance_err_80GeV_1_5mm = abs(enhance_dat_80GeV_1_5mm) .* sqrt ((data_align_80GeV_1_5mm_err ./ data_align_80GeV_1_5mm).^2 +  (data_amorph_80GeV_1_5mm_err ./ data_amorph_80GeV_1_5mm).^2);

fprintf('Finished calculating enhancement\n')

%% Amorph residual
% 20 GeV
residuals_20GeV_1mm = (data_amorph_20GeV_1mm - eff_20 * sim_amorph_20GeV_1mm);
residuals_20GeV_1_5mm = (data_amorph_20GeV_1_5mm - eff_20_1_5mm * sim_amorph_20GeV_1_5mm);

% 40 GeV
residuals_40GeV_1mm = (data_amorph_40GeV_1mm - eff_40 * sim_amorph_40GeV_1mm);
residuals_40GeV_1_5mm = (data_amorph_40GeV_1_5mm - eff_40_1_5mm * sim_amorph_40GeV_1_5mm);

% 80 GeV
residuals_80GeV_1mm = (data_amorph_80GeV_1mm - eff_80 * sim_amorph_80GeV_1mm);
residuals_80GeV_1_5mm = (data_amorph_80GeV_1_5mm  -eff_80_1_5mm * sim_amorph_80GeV_1_5mm);

%% farver til plot
fprintf('Plotting data\n');
colors = [        0    0.4470    0.7410
             0.8500    0.3250    0.0980
             0.9290    0.6940    0.1250
             0.4940    0.1840    0.5560
             0.4660    0.6740    0.1880
             0.3010    0.7450    0.9330
             0.6350    0.0780    0.1840
         ];
     
%% amorph plot 1mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);

axes(ha(1));
hold on
box on
title('20GeV e- ; 1.0mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E20, data_amorph_20GeV_1mm,data_amorph_20GeV_1mm_err,'s','MarkerFaceColor','auto')
plot(E20, eff_20 * sim_amorph_20GeV_1mm, '-','linewidth',2.5,'color',colors(2,:))
ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex')
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
ylim([0, 0.4e-3])

axes(ha(2));
hold on
box on
title('40GeV e- ; 1.0mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E40, data_amorph_40GeV_1mm,data_amorph_40GeV_1mm_err,'s','MarkerFaceColor','auto')
plot(E40, eff_40*sim_amorph_40GeV_1mm,'-','linewidth',2.5,'color',colors(2,:))
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex')
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
ylim([0, 0.5e-3])

axes(ha(3));
hold on
box on
title('80GeV e- ; 1.0mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E80, data_amorph_80GeV_1mm,data_amorph_80GeV_1mm_err,'s','MarkerFaceColor','auto')
plot(E80, eff_80* sim_amorph_80GeV_1mm,'-','linewidth',2.5,'color',colors(2,:))
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex')
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
ylim([0, 0.7e-3])

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

%% amorph plot 1.5mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);

axes(ha(1));
hold on
box on
title('20GeV e- ; 1.5mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E20, data_amorph_20GeV_1_5mm,data_amorph_20GeV_1_5mm_err,'s','MarkerFaceColor','auto')
plot(E20, eff_20_1_5mm * sim_amorph_20GeV_1_5mm, '-','linewidth',2.5,'color',colors(2,:))
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex');
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;

axes(ha(2));
hold on
box on
title('40GeV e- ; 1.5mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E40, data_amorph_40GeV_1_5mm,data_amorph_40GeV_1_5mm_err,'s','MarkerFaceColor','auto')
plot(E40, eff_40_1_5mm * sim_amorph_40GeV_1_5mm, '-','linewidth',2.5,'color',colors(2,:))
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex');
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;

axes(ha(3));
hold on
box on
title('80GeV e- ; 1.5mm amorphous C','fontsize',22,'interpreter','latex')
errorbar(E80, data_amorph_80GeV_1_5mm,data_amorph_80GeV_1_5mm_err,'s','MarkerFaceColor','auto')
plot(E80, eff_80_1_5mm * sim_amorph_80GeV_1_5mm, '-','linewidth',2.5,'color',colors(2,:))
legend({'Data','Sim'},'fontsize',18,'interpreter','latex')
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex');
xticklabels('auto'); yticklabels('auto')
grid on
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

%% amorph residual plot
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1))
hold on
plot(E20, residuals_20GeV_1mm,'o','MarkerFaceColor','b')
plot(E20, zeros(size(E20)),'--','linewidth',1.5)
grid on
box on
xticklabels('auto'); yticklabels('auto')
title('Residual 20GeV 1mm')
xlabel('E');ylabel('dat - sim')

axes(ha(2))
hold on
plot(E40, residuals_40GeV_1mm,'o','MarkerFaceColor','b')
plot(E40, zeros(size(E40)),'--','linewidth',1.5)

grid on
box on
xlabel('E'); ylabel('dat - sim')
xticklabels('auto'); yticklabels('auto')
title('Residual 40GeV 1mm')

axes(ha(3))
hold on
plot(E80, residuals_80GeV_1mm,'o','MarkerFaceColor','b')
plot(E80, zeros(size(E80)),'--','linewidth',1.5)

grid on
box on
xticklabels('auto'); yticklabels('auto')
title('Residual 80GeV 1mm')
xlabel('E');ylabel('dat - sim')

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

% f = figure;
% [ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
% axes(ha(1))
% hold on
% plot(E20, residuals_20GeV_1_5mm,'o','MarkerFaceColor','b')
% plot(E20, zeros(size(E20)),'--','linewidth',1.5)
% 
% grid on
% box on
% xticklabels('auto'); yticklabels('auto')
% xlabel('E');ylabel('dat - sim')
% title('Residual 20GeV 1.5mm')
% 
% axes(ha(2))
% hold on
% plot(E40, residuals_40GeV_1_5mm,'o','MarkerFaceColor','b')
% plot(E40, zeros(size(E40)),'--','linewidth',1.5)
% 
% grid on
% box on
% xticklabels('auto'); yticklabels('auto')
% xlabel('E');ylabel('dat - sim')
% title('Residual 40GeV 1.5mm')
% 
% axes(ha(3))
% hold on
% plot(E80, residuals_80GeV_1_5mm,'o','MarkerFaceColor','b')
% plot(E80, zeros(size(E80)),'--','linewidth',1.5)
% grid on
% box on
% xticklabels('auto'); yticklabels('auto')
% xlabel('E');ylabel('dat - sim')
% title('Residual 80GeV 1.5mm')
% 
% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

%% aligned plot 1mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1));
title('a)','Interpreter','latex')
hold on
box on
errorbar(E20, data_align_20GeV_1mm,data_align_20GeV_1mm_err,'o','MarkerFaceColor','auto')
plot(E20, eff_20 * sim_align_20GeV_1mm_RR,'-','linewidth',2.5)
% plot(E20, -eff_20 * counts_sim_20GeV_bg_norm + eff_20 * counts_sim_20GeV_aligned_norm,'-','linewidth',2.5)
% plot(E20, -eff_20 * counts_sim_20GeV_bg_norm + eff_20 * counts_sim_20GeV_aligned_norm_woshot,'--','linewidth',2.5)
% plot(E20, -eff_20 * counts_sim_20GeV_bg_norm + eff_20 * counts_sim_20GeV_aligned_norm_worr,':','linewidth',2.5)
ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex');xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
set(gca, 'FontSize', 18)
xticklabels('auto'); yticklabels('auto')
grid on
ax = gca;
ax.YAxis.Exponent = -3;
legend('Data','LL')

axes(ha(2));
hold on
box on
title('b)','Interpreter','latex')
errorbar(E40, data_align_40GeV_1mm,data_align_40GeV_1mm_err,'o','MarkerFaceColor','auto')
plot(E40, eff_40 * sim_align_40GeV_1mm_RR,'-','linewidth',2.5)
plot(E40, eff_40 * sim_align_40GeV_1mm_noRR,'-','linewidth',2.5)
plot(E40, eff_40 * sim_align_40GeV_1mm_noSH,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
axpos = get(gca,'Position');
% legend({'Data','BKC','BKCnoSchott','BKCnoRR'},'Interpreter','latex','location','northoutside','orientation','horizontal')
set(gca, 'Position', axpos)
set(gca, 'FontSize', 18)
ax = gca;
ax.FontSize = 18;
ax.YAxis.Exponent = -3;
xticklabels('auto'); yticklabels('auto')
grid on
legend('Data','LL','noRR','noSH')

axes(ha(3));
% figure
hold on
box on
title('c)','Interpreter','latex')
errorbar(E80, data_align_80GeV_1mm,data_align_80GeV_1mm_err,'o','MarkerFaceColor','auto')
plot(E80, eff_80 * sim_align_80GeV_1mm_RR,'-','linewidth',2.5)
plot(E80, eff_80 * sim_align_80GeV_1mm_noSH,'-','linewidth',2.5)
plot(E80, eff_80 * sim_align_80GeV_1mm_noRR,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
grid on
legend('Data','LL','noRR','noSH')

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

%% aligned plot 1.5mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);

axes(ha(1));
title('a)','Interpreter','latex')
hold on
box on
errorbar(E20, data_align_20GeV_1_5mm,data_align_20GeV_1_5mm_err,'^','MarkerFaceColor','auto')
plot(E20, eff_20_1_5mm * sim_align_20GeV_1_5mm_RR,'-','linewidth',2.5)
ylabel('dP/dE [1/mm]','fontsize',22,'interpreter','latex');xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
set(gca, 'FontSize', 18)
xticklabels('auto'); yticklabels('auto')
grid on
ax = gca;
ax.YAxis.Exponent = -3;

axes(ha(2));
hold on
box on
title('b)','Interpreter','latex')
errorbar(E40, data_align_40GeV_1_5mm,data_align_40GeV_1_5mm_err,'^','MarkerFaceColor','auto')
plot(E40, eff_40_1_5mm * sim_align_40GeV_1_5mm_RR,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
ax = gca;
ax.FontSize = 18;
ax.YAxis.Exponent = -3;
xticklabels('auto'); yticklabels('auto')
grid on

axes(ha(3));
hold on
box on
title('c)','Interpreter','latex')
errorbar(E80, data_align_80GeV_1_5mm,data_align_80GeV_1_5mm_err,'^','MarkerFaceColor','auto')
plot(E80, eff_80_1_5mm * sim_align_80GeV_1_5mm_RR,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
grid on

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18 36],'PaperPosition',[0, 0, 18 36],'Position',[0 0 18 36])

%% enhancement plot
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1))
hold on
errorbar(E20, enhance_dat_20GeV_1mm,enhance_err_20GeV_1mm,'o','MarkerFaceColor','auto')
plot(I_20_RR_1mm(:,1),  I_20_RR_1mm(:,2) ./ bremstrahlung_20GeV_1mm,':','linewidth',1.5)
plot(E20, sim_align_20GeV_1mm_RR ./ sim_amorph_20GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
legend('Data','LL')
xticklabels('auto'); yticklabels('auto')
xlim([0, 20])
ylim([0, 100]);
grid on
box on
title('enhancement 20GeV 1mm')

axes(ha(2))
hold on
errorbar(E40, enhance_dat_40GeV_1mm,enhance_err_40GeV_1mm,'o','MarkerFaceColor','auto')
plot(I_40_RR_1mm(:,1),  I_40_RR_1mm(:,2) ./ bremstrahlung_40GeV_1mm_RR,':','linewidth',1.5)
plot(I_40_noRR_1mm(:,1),  I_40_noRR_1mm(:,2) ./ bremstrahlung_40GeV_1mm_noRRnoSH,':','linewidth',1.5)
plot(I_40_noSH_1mm(:,1),  I_40_noSH_1mm(:,2) ./ bremstrahlung_40GeV_1mm_noRRnoSH,':','linewidth',1.5)
plot(E40, sim_align_40GeV_1mm_RR./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E40, sim_align_40GeV_1mm_noRR./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E40, sim_align_40GeV_1mm_noSH./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','LL','noRR','noSH')
xticklabels('auto'); yticklabels('auto')
xlim([0, 40])
ylim([0, 100]);
grid on
box on
title('enhancement 40GeV 1mm')

axes(ha(3))
hold on
errorbar(E80, enhance_dat_80GeV_1mm,enhance_err_80GeV_1mm,'o','MarkerFaceColor','auto')
plot(I_80_RR_1mm(:,1), I_80_RR_1mm(:,2) ./ bremstrahlung_80GeV_1mm,':','linewidth',1.5)
plot(I_80_noRR_1mm(:,1), I_80_noRR_1mm(:,2) ./ bremstrahlung_80GeV_1mm,':','linewidth',1.5)
plot(I_80_noSH_1mm(:,1), I_80_noSH_1mm(:,2) ./ bremstrahlung_80GeV_1mm,':','linewidth',1.5)
plot(E80, sim_align_80GeV_1mm_RR./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E80, sim_align_80GeV_1mm_noRR./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E80, sim_align_80GeV_1mm_noSH./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','LL','noRR','noSH')
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
ylim([0, 100]);
grid on
box on
title('enhancement 80GeV 1mm')
set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1))
hold on
errorbar(E20, enhance_dat_20GeV_1_5mm,enhance_err_20GeV_1_5mm,'o','MarkerFaceColor','auto')
plot(I_20_RR_1_5mm(:,1),  I_20_RR_1_5mm(:,2) ./ bremstrahlung_20GeV_1_5mm_RR,':','linewidth',1.5)
plot(E20, sim_align_20GeV_1_5mm_RR ./ sim_amorph_20GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
legend('Data','LL')
xticklabels('auto'); yticklabels('auto')
xlim([0, 20])
ylim([0, 100]);
grid on
box on
title('enhancement 20GeV 1.5mm')

axes(ha(2))
hold on
errorbar(E40, enhance_dat_40GeV_1_5mm,enhance_err_40GeV_1_5mm,'o','MarkerFaceColor','auto')
plot(I_40_RR_1_5mm(:,1),  I_40_RR_1_5mm(:,2) ./ bremstrahlung_40GeV_1_5mm_RR,':','linewidth',1.5)
plot(E40, sim_align_40GeV_1_5mm_RR./sim_amorph_40GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
legend('Data','LL')
xticklabels('auto'); yticklabels('auto')
xlim([0, 40])
ylim([0, 100]);
grid on
box on
title('enhancement 40GeV 1.5mm')

axes(ha(3))
hold on
errorbar(E80, enhance_dat_80GeV_1_5mm,enhance_err_80GeV_1_5mm,'o','MarkerFaceColor','auto')
plot(I_80_RR_1_5mm(:,1), I_80_RR_1_5mm(:,2) ./ bremstrahlung_80GeV_1_5mm_RR,':','linewidth',1.5)
plot(E80, sim_align_80GeV_1_5mm_RR./sim_amorph_80GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
legend('Data','LL')
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
ylim([0, 100]);
grid on
box on
title('enhancement 80GeV 1.5mm')
set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])

%% FUNKTIONER
function [minimum,val, k, f, dat, sim, dat_err] = calibrate(E, amorphsim, bgsim, amorphdat, bgdat, Nsim, Ndat1, Ndat2)
    amorph = hist(amorphsim(amorphsim < max(E) & amorphsim > min(E)), E);
    bg = hist(bgsim(bgsim < max(E) & bgsim > min(E)), E);
    sim = E .* (amorph - bg)/Nsim;
    sim_err = E .* sqrt(amorph + bg)/Nsim;
    
    amorph = hist(amorphdat(amorphdat < max(E) & amorphdat > min(E)), E);
    bg = hist(bgdat(bgdat < max(E) & bgdat > min(E)), E);
    dat = E .* (amorph/Ndat1 - bg/Ndat2);
    dat_err = E .* sqrt(amorph/Ndat1^2 + bg/Ndat2^2);

%     chi2 = @(eff) sum(((dat(dat > 0) - eff .* sim(dat > 0)).^2)./(sim_err(dat > 0).^2 + dat_err(dat > 0).^2)); % chi-squared wo error
    chi2 = @(eff) norm(dat - eff .* sim);
%     chi2 = @(eff) trapz(E, dat - eff .* sim);

    f = zeros(100,1);
    k = linspace(0,2,100);
    for i = 1:100
        f(i) = chi2(k(i));
    end

    minimum = fminsearch(chi2, 0.9); % fast, local
%     minimum = fzero(chi2, 0.9); % fast, local
    val = chi2(minimum);    
end

function s = spectrum(filePrefix, fileSuffix, fileNum)
    global datpath;
    s = [];

    if isempty(fileNum)
        file = strcat(datpath, filePrefix,fileSuffix);
        s = load(file) * 6.2415091E9;
    else
        for i = fileNum
            file = strcat(datpath, filePrefix,num2str(i),fileSuffix);
            nrg = load(file) * 6.2415091E9;
            s = [s; nrg];
        end
    end
end