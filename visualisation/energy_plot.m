clear all; close all; clc;
global datpath simpath;
simpath = '/home/christian/Dropbox/Cern2018Experiment/spectre/';
datpath = '/home/christian/Documents/cern2018/spectre/cuts95/';
simpath =  '/home/christian/Documents/cern2018/spectre/cuts95/';

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
events_20GeV_1mm = zeros(1,3); % [aligned, amorph, bg]
events_20GeV_1mm(1) = load(strcat(datpath, 'events_dat_aligned_20GeV_1.0mm.txt'));
events_20GeV_1mm(2) = load(strcat(datpath, 'events_dat_amorph_20GeV_1.0mm.txt'));
events_20GeV_1mm(3) = load(strcat(datpath, 'events_dat_bg_20GeV_1.0mm.txt'));

counts_dat_20GeV_bg_norm_tot = spectrum('energy_dat_bg_20GeV_1.0mm','.txt',[]);
data_bg_20GeV_1mm = hist(counts_dat_20GeV_bg_norm_tot(counts_dat_20GeV_bg_norm_tot < max(E20) & counts_dat_20GeV_bg_norm_tot > min(E20)), E20);
counts_dat_20GeV_amorph_norm_tot = spectrum('energy_dat_amorph_20GeV_1.0mm', '.txt', []);

counts_dat_20GeV_aligned_norm_tot = spectrum('energy_dat_aligned_20GeV_1.0mm', '.txt', []);
data_align_20GeV_1mm = hist(counts_dat_20GeV_aligned_norm_tot(counts_dat_20GeV_aligned_norm_tot < max(E20) & counts_dat_20GeV_aligned_norm_tot > min(E20)), E20);
data_align_20GeV_1mm_err = E20 .* sqrt(data_align_20GeV_1mm/events_20GeV_1mm(1)^2 + data_bg_20GeV_1mm/events_20GeV_1mm(3)^2);
data_align_20GeV_1mm = E20 .* (data_align_20GeV_1mm/events_20GeV_1mm(1)^2 - data_bg_20GeV_1mm/events_20GeV_1mm(3)^2);

% % DATA 1.5mm
events_20GeV_1_5mm = zeros(1,3); % [aligned, amorph, bg]
events_20GeV_1_5mm(1) = load(strcat(datpath, 'events_dat_aligned_20GeV_1.5mm.txt'));
events_20GeV_1_5mm(2) = load(strcat(datpath, 'events_dat_amorph_20GeV_1.5mm.txt'));
events_20GeV_1_5mm(3) = load(strcat(datpath, 'events_dat_bg_20GeV_1.5mm.txt'));

counts_dat_20GeV_bg_1_5mm_norm_tot = spectrum('energy_dat_bg_20GeV_1.5mm','.txt',[]);
data_bg_20GeV_1_5mm = hist(counts_dat_20GeV_bg_1_5mm_norm_tot(counts_dat_20GeV_bg_1_5mm_norm_tot < max(E20) & counts_dat_20GeV_bg_1_5mm_norm_tot > min(E20)), E20);
counts_dat_20GeV_amorph_1_5mm_norm_tot = spectrum('energy_dat_amorph_20GeV_1.5mm', '.txt', []);

counts_dat_20GeV_aligned_norm_tot_1_5mm = spectrum('energy_dat_aligned_20GeV_1.5mm', '.txt', []);
data_align_20GeV_1_5mm = hist(counts_dat_20GeV_aligned_norm_tot_1_5mm(counts_dat_20GeV_aligned_norm_tot_1_5mm < max(E20) & counts_dat_20GeV_aligned_norm_tot_1_5mm > min(E20)), E20);
data_align_20GeV_1_5mm_err = E20 .* sqrt(data_align_20GeV_1_5mm/events_20GeV_1_5mm(1)^2 + data_bg_20GeV_1_5mm/events_20GeV_1_5mm(3)^2);
data_align_20GeV_1_5mm = E20 .* (data_align_20GeV_1_5mm/events_20GeV_1_5mm(1) - data_bg_20GeV_1_5mm/events_20GeV_1_5mm(3));
fprintf('\t 20 GeV CERN data loaded\n')

% SIM 1mm
nevents_20GeV_1mm_stoch = load(strcat(simpath,'events_run_sim_aligned_20GeV_stochastic.txt'));

counts_sim_20GeV_bg_norm = spectrum('energy_sim_background', '_20GeV.txt', []);
sim_bg_20GeV_1mm = hist(counts_sim_20GeV_bg_norm(counts_sim_20GeV_bg_norm < max(E20) & counts_sim_20GeV_bg_norm > min(E20)), E20);

counts_sim_20GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_20GeV.txt', []);

counts_sim_20GeV_aligned_stoch = spectrum('energy_sim_aligned', '_20GeV_stochastic.txt',  []);
sim_align_20GeV_1mm_stoch = hist(counts_sim_20GeV_aligned_stoch(counts_sim_20GeV_aligned_stoch < max(E20) & counts_sim_20GeV_aligned_stoch > min(E20)), E20);
sim_align_20GeV_1mm_stoch = E20 .* (sim_align_20GeV_1mm_stoch / nevents_20GeV_1mm_stoch - sim_bg_20GeV_1mm / 1e8);

% SIM 1.5mm
nevents_20GeV_1_5mm_stoch = load(strcat(simpath,'events_run_sim_aligned_20GeV_1.5mm_stochastic.txt'));

counts_sim_20GeV_bg_norm_1_5mm = spectrum('energy_sim_background', '_20GeV_1.5mm.txt', []);
sim_bg_20GeV_1_5mm = hist(counts_sim_20GeV_bg_norm_1_5mm(counts_sim_20GeV_bg_norm_1_5mm < max(E20) & counts_sim_20GeV_bg_norm_1_5mm > min(E20)), E20);

counts_sim_20GeV_amorph_bg_norm_1_5mm = spectrum('energy_sim_amorphous', '_20GeV_1.5mm.txt', []);

counts_sim_20GeV_aligned_1_5mm_stoch = spectrum('energy_sim_aligned', '_20GeV_1.5mm_stochastic.txt',  []);
sim_align_20GeV_1_5mm_stoch = hist(counts_sim_20GeV_aligned_1_5mm_stoch(counts_sim_20GeV_aligned_1_5mm_stoch < max(E20) & counts_sim_20GeV_aligned_1_5mm_stoch > min(E20)), E20);
sim_align_20GeV_1_5mm_stoch = E20 .* (sim_align_20GeV_1_5mm_stoch / nevents_20GeV_1_5mm_stoch - sim_bg_20GeV_1_5mm / 1e8);

fprintf('\t 20 GeV SIM data loaded\n')
%% 40 GeV data+sim
% DATA 1mm
events_40GeV_1mm = zeros(1,3); % [aligned, amorph, bg]
events_40GeV_1mm(1) = load(strcat(datpath, 'events_dat_aligned_40GeV_1.0mm.txt'));
events_40GeV_1mm(2) = load(strcat(datpath, 'events_dat_amorph_40GeV_1.0mm.txt'));
events_40GeV_1mm(3) = load(strcat(datpath, 'events_dat_bg_40GeV_1.0mm.txt'));

counts_dat_40GeV_bg_norm = spectrum('energy_dat_bg_40GeV_1.0mm','.txt',[]);
data_bg_40GeV_1mm = hist(counts_dat_40GeV_bg_norm(counts_dat_40GeV_bg_norm < max(E40) & counts_dat_40GeV_bg_norm > min(E40)), E40);
counts_dat_40GeV_amorph_norm_tot = spectrum('energy_dat_amorph_40GeV_1.0mm','.txt',[]);

counts_dat_40GeV_aligned_norm_tot = spectrum('energy_dat_aligned_40GeV_1.0mm','.txt',[]);
data_align_40GeV_1mm = hist(counts_dat_40GeV_aligned_norm_tot(counts_dat_40GeV_aligned_norm_tot < max(E40) & counts_dat_40GeV_aligned_norm_tot > min(E40)), E40);
data_align_40GeV_1mm_err = E40 .* sqrt(data_align_40GeV_1mm/(events_40GeV_1mm(1))^2 + data_bg_40GeV_1mm/(events_40GeV_1mm(3))^2);
data_align_40GeV_1mm = E40 .* (data_align_40GeV_1mm / (events_40GeV_1mm(1)) - data_bg_40GeV_1mm/events_40GeV_1mm(3));

% DATA 1.5mm
events_40GeV_1_5mm = zeros(1,3); % [aligned, amorph, bg]
events_40GeV_1_5mm(1) = load(strcat(datpath, 'events_dat_aligned_40GeV_1.5mm.txt'));
events_40GeV_1_5mm(2) = load(strcat(datpath, 'events_dat_amorph_40GeV_1.5mm.txt'));
events_40GeV_1_5mm(3) = load(strcat(datpath, 'events_dat_bg_40GeV_1.5mm.txt'));

counts_dat_40GeV_amorph_norm_tot_1_5mm = spectrum('energy_dat_amorph_40GeV_1.5mm','.txt',[]);
counts_dat_40GeV_bg_norm_1_5mm = spectrum('energy_dat_bg_40GeV_1.5mm','.txt',[]);
data_bg_40GeV_1_5mm = hist(counts_dat_40GeV_bg_norm_1_5mm(counts_dat_40GeV_bg_norm_1_5mm < max(E40) & counts_dat_40GeV_bg_norm_1_5mm > min(E40)), E40);

counts_dat_40GeV_aligned_norm_tot_1_5mm = spectrum('energy_dat_aligned_40GeV_1.5mm','.txt',[]);
data_align_40GeV_1_5mm = hist(counts_dat_40GeV_aligned_norm_tot_1_5mm(counts_dat_40GeV_aligned_norm_tot_1_5mm < max(E40) & counts_dat_40GeV_aligned_norm_tot_1_5mm > min(E40)), E40);
data_align_40GeV_1_5mm_err = E40 .* sqrt(data_align_40GeV_1_5mm/(events_40GeV_1_5mm(1))^2 + data_bg_40GeV_1_5mm/(events_40GeV_1_5mm(3))^2);
data_align_40GeV_1_5mm = E40 .* (data_align_40GeV_1_5mm / (events_40GeV_1_5mm(1))  - data_bg_40GeV_1_5mm/events_40GeV_1_5mm(3));
fprintf('\t 40 GeV CERN data loaded\n')

% SIM 1mm
nevents_40GeV_1mm_RR = load(strcat(simpath,'events_run_sim_aligned_40GeV.txt'));
nevents_40GeV_1mm_noRR = load(strcat(simpath,'events_run_sim_aligned_40GeV_worr.txt'));
nevents_40GeV_1mm_stoch = load(strcat(simpath,'events_run_sim_aligned_40GeV_stochastic.txt'));

counts_sim_40GeV_bg_norm = spectrum('energy_sim_background', '_40GeV.txt', []);
sim_bg_40GeV_1mm = hist(counts_sim_40GeV_bg_norm(counts_sim_40GeV_bg_norm < max(E40) & counts_sim_40GeV_bg_norm > min(E40)), E40);
counts_sim_40GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_40GeV.txt', []);

counts_sim_40GeV_aligned_norm_worr = spectrum('energy_sim_aligned', '_40GeV_worr.txt', []);
counts_sim_40GeV_aligned_norm = spectrum('energy_sim_aligned', '_40GeV.txt', []);
counts_sim_40GeV_aligned_norm_stoch = spectrum('energy_sim_aligned', '_40GeV_stochastic.txt', []);

sim_align_40GeV_1mm_RR = hist(counts_sim_40GeV_aligned_norm(counts_sim_40GeV_aligned_norm < max(E40) & counts_sim_40GeV_aligned_norm > min(E40)), E40);
sim_align_40GeV_1mm_RR = E40 .* (sim_align_40GeV_1mm_RR / nevents_40GeV_1mm_RR - sim_bg_40GeV_1mm / 1e8);
sim_align_40GeV_1mm_noRR = hist(counts_sim_40GeV_aligned_norm_worr(counts_sim_40GeV_aligned_norm_worr < max(E40) & counts_sim_40GeV_aligned_norm_worr > min(E40)), E40);
sim_align_40GeV_1mm_noRR = E40 .* (sim_align_40GeV_1mm_noRR / nevents_40GeV_1mm_noRR - sim_bg_40GeV_1mm / 1e8);
sim_align_40GeV_1mm_stoch = hist(counts_sim_40GeV_aligned_norm_stoch(counts_sim_40GeV_aligned_norm_stoch < max(E40) & counts_sim_40GeV_aligned_norm_stoch > min(E40)), E40);
sim_align_40GeV_1mm_stoch = E40 .* (sim_align_40GeV_1mm_stoch / nevents_40GeV_1mm_stoch - sim_bg_40GeV_1mm / 1e8);

% SIM 1.5mm
nevents_40GeV_1_5mm_RR = load(strcat(simpath,'events_run_sim_aligned_40GeV_1.5mm.txt'));
nevents_40GeV_1_5mm_noRR = load(strcat(simpath,'events_run_sim_aligned_40GeV_worr_1.5mm.txt'));
nevents_40GeV_1_5mm_stoch = load(strcat(simpath,'events_run_sim_aligned_40GeV_1.5mm_stochastic.txt'));

counts_sim_40GeV_bg_norm_1_5mm = spectrum('energy_sim_background', '_40GeV_1.5mm.txt', []);
sim_bg_40GeV_1_5mm = hist(counts_sim_40GeV_bg_norm_1_5mm(counts_sim_40GeV_bg_norm_1_5mm < max(E40) & counts_sim_40GeV_bg_norm_1_5mm > min(E40)), E40);
counts_sim_40GeV_amorph_bg_norm_1_5mm = spectrum('energy_sim_amorphous', '_40GeV_1.5mm.txt', []);

counts_sim_40GeV_aligned_1_5mm_norm_worr = spectrum('energy_sim_aligned', '_40GeV_worr_1.5mm.txt', []);
counts_sim_40GeV_aligned_1_5mm_norm = spectrum('energy_sim_aligned', '_40GeV_1.5mm.txt', []);
counts_sim_40GeV_aligned_1_5mm_norm_stoch = spectrum('energy_sim_aligned', '_40GeV_1.5mm_stochastic.txt', []);

sim_align_40GeV_1_5mm_RR = hist(counts_sim_40GeV_aligned_1_5mm_norm(counts_sim_40GeV_aligned_1_5mm_norm < max(E40) & counts_sim_40GeV_aligned_1_5mm_norm > min(E40)), E40);
sim_align_40GeV_1_5mm_RR = E40 .* (sim_align_40GeV_1_5mm_RR / nevents_40GeV_1_5mm_RR - sim_bg_40GeV_1_5mm / 1e8);
sim_align_40GeV_1_5mm_noRR = hist(counts_sim_40GeV_aligned_1_5mm_norm_worr(counts_sim_40GeV_aligned_1_5mm_norm_worr < max(E40) & counts_sim_40GeV_aligned_1_5mm_norm_worr > min(E40)), E40);
sim_align_40GeV_1_5mm_noRR = E40 .* (sim_align_40GeV_1_5mm_noRR / nevents_40GeV_1_5mm_noRR - sim_bg_40GeV_1_5mm / 1e8);
sim_align_40GeV_1_5mm_stoch = hist(counts_sim_40GeV_aligned_1_5mm_norm_stoch(counts_sim_40GeV_aligned_1_5mm_norm_stoch < max(E40) & counts_sim_40GeV_aligned_1_5mm_norm_stoch > min(E40)), E40);
sim_align_40GeV_1_5mm_stoch = E40 .* (sim_align_40GeV_1_5mm_stoch / nevents_40GeV_1_5mm_stoch - sim_bg_40GeV_1_5mm / 1e8);

fprintf('\t 40 GeV SIM data loaded\n')
%% 80 GeV data+sim
% DAT 1mm
events_80GeV_1mm = zeros(1,3); % [aligned, amorph, bg]
events_80GeV_1mm(1) = load(strcat(datpath, 'events_dat_aligned_80GeV_1.0mm.txt'));
events_80GeV_1mm(2) = load(strcat(datpath, 'events_dat_amorph_80GeV_1.0mm.txt'));
events_80GeV_1mm(3) = load(strcat(datpath, 'events_dat_bg_80GeV_1.0mm.txt'));

counts_dat_80GeV_bg_norm = spectrum('energy_dat_bg_80GeV_1.0mm','.txt',[]);
data_bg_80GeV_1mm = hist(counts_dat_80GeV_bg_norm(counts_dat_80GeV_bg_norm < max(E80) & counts_dat_80GeV_bg_norm > min(E80)), E80);
counts_dat_80GeV_amorph_norm_tot = spectrum('energy_dat_amorph_80GeV_1.0mm','.txt',[]);

counts_dat_80GeV_aligned_norm_tot = spectrum('energy_dat_aligned_80GeV_1.0mm','.txt',[]);
data_align_80GeV_1mm = hist(counts_dat_80GeV_aligned_norm_tot(counts_dat_80GeV_aligned_norm_tot < max(E80) & counts_dat_80GeV_aligned_norm_tot > min(E80)), E80);
data_align_80GeV_1mm_err = E80 .* sqrt(data_align_80GeV_1mm/(events_80GeV_1mm(1))^2 + data_bg_80GeV_1mm/(events_80GeV_1mm(3))^2);
data_align_80GeV_1mm = E80 .* (data_align_80GeV_1mm / (events_80GeV_1mm(1)) - data_bg_80GeV_1mm/(events_80GeV_1mm(3)));

% DATA 1.5mm
events_80GeV_1_5mm = zeros(1,3); % [aligned, amorph, bg]
events_80GeV_1_5mm(1) = load(strcat(datpath, 'events_dat_aligned_80GeV_1.5mm.txt'));
events_80GeV_1_5mm(2) = load(strcat(datpath, 'events_dat_amorph_80GeV_1.5mm.txt'));
events_80GeV_1_5mm(3) = load(strcat(datpath, 'events_dat_bg_80GeV_1.5mm.txt'));

counts_dat_80GeV_bg_norm_1_5mm_tot = spectrum('energy_dat_bg_80GeV_1.5mm','.txt',[]);
data_bg_80GeV_1_5mm = hist(counts_dat_80GeV_bg_norm_1_5mm_tot(counts_dat_80GeV_bg_norm_1_5mm_tot < max(E80) & counts_dat_80GeV_bg_norm_1_5mm_tot > min(E80)), E80);
counts_dat_80GeV_amorph_norm_1_5mm_tot = spectrum('energy_dat_amorph_80GeV_1.5mm','.txt',[]);

counts_dat_80GeV_aligned_norm_1_5mm_tot = spectrum('energy_dat_aligned_80GeV_1.5mm','.txt',[]);
data_align_80GeV_1_5mm = hist(counts_dat_80GeV_aligned_norm_1_5mm_tot(counts_dat_80GeV_aligned_norm_1_5mm_tot < max(E80) & counts_dat_80GeV_aligned_norm_1_5mm_tot > min(E80)), E80);
data_align_80GeV_1_5mm_err = E80 .* sqrt(data_align_80GeV_1_5mm/(events_80GeV_1_5mm(1))^2 + data_bg_80GeV_1_5mm/(events_80GeV_1_5mm(3))^2);
data_align_80GeV_1_5mm = E80 .* (data_align_80GeV_1_5mm / (events_80GeV_1_5mm(1)) - data_bg_80GeV_1_5mm/(events_80GeV_1_5mm(3)));
fprintf('\t 80 GeV CERN data loaded\n')

% SIM 1mm
nevents_80GeV_1mm_RR = load(strcat(simpath,'events_run_sim_aligned_80GeV.txt'));
nevents_80GeV_1mm_noRR = load(strcat(simpath,'events_run_sim_aligned_80GeV_worr.txt'));
nevents_80GeV_1mm_stoch = load(strcat(simpath,'events_run_sim_aligned_80GeV_stochastic.txt'));

counts_sim_80GeV_bg_norm = spectrum('energy_sim_background', '_80GeV.txt', []);
sim_bg_80GeV_1mm = hist(counts_sim_80GeV_bg_norm(counts_sim_80GeV_bg_norm < max(E80) & counts_sim_80GeV_bg_norm > min(E80)), E80);
counts_sim_80GeV_amorph_bg_norm = spectrum('energy_sim_amorphous', '_80GeV.txt', []);

counts_sim_80GeV_aligned_noRR = spectrum('energy_sim_aligned', '_80GeV_worr.txt',  []);
sim_align_80GeV_1mm_noRR = hist(counts_sim_80GeV_aligned_noRR(counts_sim_80GeV_aligned_noRR < max(E80) & counts_sim_80GeV_aligned_noRR > min(E80)), E80);
sim_align_80GeV_1mm_noRR = E80 .* (sim_align_80GeV_1mm_noRR / nevents_80GeV_1mm_noRR - sim_bg_80GeV_1mm / 1e8);
counts_sim_80GeV_aligned_RR = spectrum('energy_sim_aligned', '_80GeV.txt',  []);
sim_align_80GeV_1mm_RR = hist(counts_sim_80GeV_aligned_RR(counts_sim_80GeV_aligned_RR < max(E80) & counts_sim_80GeV_aligned_RR > min(E80)), E80);
sim_align_80GeV_1mm_RR = E80 .* (sim_align_80GeV_1mm_RR / nevents_80GeV_1mm_RR - sim_bg_80GeV_1mm / 1e8);
counts_sim_80GeV_aligned_stoch = spectrum('energy_sim_aligned', '_80GeV_stochastic.txt', []);
sim_align_80GeV_1mm_stoch = hist(counts_sim_80GeV_aligned_stoch(counts_sim_80GeV_aligned_stoch < max(E80) & counts_sim_80GeV_aligned_stoch > min(E80)), E80);
sim_align_80GeV_1mm_stoch = E80 .* (sim_align_80GeV_1mm_stoch / nevents_80GeV_1mm_stoch - sim_bg_80GeV_1mm / 1e8);

% SIM 1.5mm
nevents_80GeV_1_5mm_RR = load(strcat(simpath,'events_run_sim_aligned_80GeV_1.5mm.txt'));
nevents_80GeV_1_5mm_noRR = load(strcat(simpath,'events_run_sim_aligned_80GeV_worr_1.5mm.txt'));
nevents_80GeV_1_5mm_stoch = load(strcat(simpath,'events_run_sim_aligned_80GeV_1.5mm_stochastic.txt'));

counts_sim_80GeV_amorph_bg_1_5mm_norm = spectrum('energy_sim_amorphous', '_80GeV_1.5mm.txt', []);
counts_sim_80GeV_bg_1_5mm_norm = spectrum('energy_sim_background', '_80GeV_1.5mm.txt', []);

counts_sim_80GeV_aligned_1_5mm_norm_worr = spectrum('energy_sim_aligned', '_80GeV_worr_1.5mm.txt', []);
counts_sim_80GeV_aligned_RR_1_5mm = spectrum('energy_sim_aligned', '_80GeV_1.5mm.txt', []);
counts_sim_80GeV_aligned_1_5mm_stochastic = spectrum('energy_sim_aligned', '_80GeV_1.5mm_stochastic.txt', []);

sim_bg_80GeV_1_5mm = hist(counts_sim_80GeV_bg_1_5mm_norm(counts_sim_80GeV_bg_1_5mm_norm < max(E80) & counts_sim_80GeV_bg_1_5mm_norm > min(E80)), E80);
sim_align_80GeV_1_5mm_RR = hist(counts_sim_80GeV_aligned_RR_1_5mm(counts_sim_80GeV_aligned_RR_1_5mm < max(E80) & counts_sim_80GeV_aligned_RR_1_5mm > min(E80)), E80);
sim_align_80GeV_1_5mm_RR = E80 .* (sim_align_80GeV_1_5mm_RR / nevents_80GeV_1_5mm_RR - sim_bg_80GeV_1_5mm / 1e8);
sim_align_80GeV_1_5mm_noRR = hist(counts_sim_80GeV_aligned_1_5mm_norm_worr(counts_sim_80GeV_aligned_1_5mm_norm_worr < max(E80) & counts_sim_80GeV_aligned_1_5mm_norm_worr > min(E80)), E80);
sim_align_80GeV_1_5mm_noRR = E80 .* (sim_align_80GeV_1_5mm_noRR / nevents_80GeV_1_5mm_noRR - sim_bg_80GeV_1_5mm / 1e8);
sim_align_80GeV_1_5mm_stoch = hist(counts_sim_80GeV_aligned_1_5mm_stochastic(counts_sim_80GeV_aligned_1_5mm_stochastic < max(E80) & counts_sim_80GeV_aligned_1_5mm_stochastic > min(E80)), E80);
sim_align_80GeV_1_5mm_stoch = E80 .* (sim_align_80GeV_1_5mm_stoch / nevents_80GeV_1_5mm_stoch - sim_bg_80GeV_1_5mm / 1e8);

fprintf('\t 80 GeV SIM data loaded\n')
%% Kalibering 
fprintf('Calculating callibration factors\n')
eff_20 = 3.14; eff_40 = 3.14; eff_80 = 3.14;eff_20_1_5mm = 3.14; eff_40_1_5mm = 3.14; eff_80_1_5mm = 3.14;
% 20 GeV
% %1mm
[eff_20, ~, ~, ~, data_amorph_20GeV_1mm, sim_amorph_20GeV_1mm, data_amorph_20GeV_1mm_err] = calibrate(E20,...
                    counts_sim_20GeV_amorph_bg_norm,counts_sim_20GeV_bg_norm,...
                    counts_dat_20GeV_amorph_norm_tot, counts_dat_20GeV_bg_norm_tot,...
                    1e8,1e8, events_20GeV_1mm(2), events_20GeV_1mm(3));

%1.5mm
[eff_20_1_5mm, ~, ~, ~, data_amorph_20GeV_1_5mm, sim_amorph_20GeV_1_5mm, data_amorph_20GeV_1_5mm_err] = calibrate(E20,...
                          counts_sim_20GeV_amorph_bg_norm_1_5mm,counts_sim_20GeV_bg_norm_1_5mm,...
                          counts_dat_20GeV_amorph_1_5mm_norm_tot,counts_dat_20GeV_bg_1_5mm_norm_tot,...
                          1e8,1e8, events_20GeV_1_5mm(2), events_20GeV_1_5mm(3));

% 40 GeV
%1mm
[eff_40, ~, ~, ~, data_amorph_40GeV_1mm, sim_amorph_40GeV_1mm, data_amorph_40GeV_1mm_err] = calibrate(E40,...
                          counts_sim_40GeV_amorph_bg_norm,counts_sim_40GeV_bg_norm,...
                          counts_dat_40GeV_amorph_norm_tot,counts_dat_40GeV_bg_norm,...
                          1e8,1e8, events_40GeV_1mm(2), events_40GeV_1mm(3));

%1.5mm
[eff_40_1_5mm, ~, ~, ~, data_amorph_40GeV_1_5mm, sim_amorph_40GeV_1_5mm, data_amorph_40GeV_1_5mm_err] = calibrate(E40,...
                          counts_sim_40GeV_amorph_bg_norm_1_5mm,counts_sim_40GeV_bg_norm_1_5mm,...
                          counts_dat_40GeV_amorph_norm_tot_1_5mm,counts_dat_40GeV_bg_norm_1_5mm,...
                          1e8,1e8, events_40GeV_1_5mm(2), events_40GeV_1_5mm(3));

% 80 GeV
%1mm
[eff_80, ~, ~, ~, data_amorph_80GeV_1mm, sim_amorph_80GeV_1mm, data_amorph_80GeV_1mm_err] = calibrate(E80,...
                          counts_sim_80GeV_amorph_bg_norm,counts_sim_80GeV_bg_norm,...
                          counts_dat_80GeV_amorph_norm_tot,counts_dat_80GeV_bg_norm,...
                          1e8,1e8, 1719461 + 1172521 + 1210722 + 538281, 1911215 + 1892132 + 1219189);

%1.5mm
[eff_80_1_5mm, ~, ~, ~, data_amorph_80GeV_1_5mm, sim_amorph_80GeV_1_5mm, data_amorph_80GeV_1_5mm_err] = calibrate(E80,...
                          counts_sim_80GeV_amorph_bg_1_5mm_norm,counts_sim_80GeV_bg_1_5mm_norm,...
                          counts_dat_80GeV_amorph_norm_1_5mm_tot,counts_dat_80GeV_bg_norm_1_5mm_tot,...
                          1e8,1e8, 873246 + 434680 + 847524 + 182889 + 18846 + 392613 + 495068, 2497897 + 312302 + 216860);

% eff_80_1_5mm = eff_80;
% eff_40_1_5mm = eff_40;
% eff_20_1_5mm = eff_20;
fprintf('\n\t20 GeV\t40 GeV\t80 GeV\n%1.1fmm \t%1.3f \t%1.3f \t%1.3f\n%1.1fmm \t%1.3f \t%1.3f \t%1.3f\n',1, eff_20,eff_40,eff_80,1.5, eff_20_1_5mm,eff_40_1_5mm,eff_80_1_5mm);
%% Enhancement 
% 40 GeV
E = 40000;  
% 1mm
I_40_RR_1mm  = load(strcat(simpath,'sum_angles40GeV1mmRR.txt'));
I_40_noRR_1mm  = load(strcat(simpath,'sum_angles40GeV1mmnoRR.txt'));
I_40_stoch_1mm  = load(strcat(simpath,'sum_angles40GeV1mmstochastic.txt'));
bremstrahlung_40GeV_1mm_RR = 1.00*1e-3*alpha*16/3*r0^2*(1-I_40_RR_1mm(:,1)./(E)+(I_40_RR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
bremstrahlung_40GeV_1mm_noRR = 1.00*1e-3*alpha*16/3*r0^2*(1-I_40_noRR_1mm(:,1)./(E)+(I_40_noRR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_40GeV_1mm = (data_align_40GeV_1mm)./(data_amorph_40GeV_1mm);
enhance_err_40GeV_1mm = abs(enhance_dat_40GeV_1mm) .* sqrt ((data_align_40GeV_1mm_err ./ data_align_40GeV_1mm).^2 +  (data_amorph_40GeV_1mm_err ./ data_amorph_40GeV_1mm).^2);

%1.5mm
I_40_RR_1_5mm  = load(strcat(datpath,'sum_angles40GeV1_5mmRR.txt'));
I_40_noRR_1_5mm  = load(strcat(simpath,'sum_angles40GeV1_5mmnoRR.txt'));
I_40_stoch_1_5mm  = load(strcat(simpath,'sum_angles40GeV1_5mmstochastic.txt'));
bremstrahlung_40GeV_1_5mm_RR = 1.50*1e-3*alpha*16/3*r0^2*(1-I_40_RR_1_5mm(:,1)./(E)+(I_40_RR_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_40GeV_1_5mm = (data_align_40GeV_1_5mm)./(data_amorph_40GeV_1_5mm);
enhance_err_40GeV_1_5mm = abs(enhance_dat_40GeV_1_5mm) .* sqrt ((data_align_40GeV_1_5mm_err ./ data_align_40GeV_1_5mm).^2 +  (data_amorph_40GeV_1_5mm_err ./ data_amorph_40GeV_1_5mm).^2);

% 20 GeV
E = 20000;
% 1mm
I_20_stoch_1mm  = load(strcat(datpath,'sum_angles20GeV1mmstochastic.txt'));
bremstrahlung_20GeV_1mm_stoch = 1.00*1e-3*alpha*16/3*r0^2*(1-I_20_stoch_1mm(:,1)./(E)+(I_20_stoch_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_20GeV_1mm = (data_align_20GeV_1mm)./(data_amorph_20GeV_1mm);
enhance_err_20GeV_1mm = abs(enhance_dat_20GeV_1mm) .* sqrt ((data_align_20GeV_1mm_err ./ data_align_20GeV_1mm).^2 +  (data_amorph_20GeV_1mm_err ./ data_amorph_20GeV_1mm).^2);

%1.5mm
I_20_stoch_1_5mm  = load(strcat(datpath,'sum_angles20GeV1_5mmstochastic.txt'));
bremstrahlung_20GeV_1_5mm_stoch = 1.50*1e-3*alpha*16/3*r0^2*(1-I_20_stoch_1_5mm(:,1)./(E)+(I_20_stoch_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_20GeV_1_5mm = (data_align_20GeV_1_5mm)./(data_amorph_20GeV_1_5mm);
enhance_err_20GeV_1_5mm = abs(enhance_dat_20GeV_1_5mm) .* sqrt ((data_align_20GeV_1_5mm_err ./ data_align_20GeV_1_5mm).^2 +  (data_amorph_20GeV_1_5mm_err ./ data_amorph_20GeV_1_5mm).^2);

% 80 GeV
E = 80000;
%1mm
I_80_RR_1mm  = load(strcat(simpath,'sum_angles80GeV1mmRR.txt'));
I_80_noRR_1mm  = load(strcat(simpath,'sum_angles80GeV1mmnoRR.txt'));
I_80_stoch_1mm  = load(strcat('/home/christian/Dropbox/Cern2018Experiment/grendel/spectre/','sum_angles80GeV1mmstochastic.txt'));
bremstrahlung_80GeV_1mm = 1.00*1e-3*alpha*16/3*r0^2*(1-I_80_RR_1mm(:,1)./(E)+(I_80_RR_1mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_80GeV_1mm = (data_align_80GeV_1mm)./(data_amorph_80GeV_1mm);
enhance_err_80GeV_1mm = abs(enhance_dat_80GeV_1mm) .* sqrt ((data_align_80GeV_1mm_err ./ data_align_80GeV_1mm).^2 +  (data_amorph_80GeV_1mm_err ./ data_amorph_80GeV_1mm).^2);

%1.5mm
I_80_RR_1_5mm  = load(strcat(simpath,'sum_angles80GeV1_5mmRR.txt'));
I_80_noRR_1_5mm  = load(strcat(simpath,'sum_angles80GeV1_5mmnoRR.txt'));
I_80_stoch_1_5mm  = load(strcat(simpath,'sum_angles80GeV1_5mmstochastic.txt'));
bremstrahlung_80GeV_1_5mm_RR = 1.50*1e-3*alpha*16/3*r0^2*(1-I_80_RR_1_5mm(:,1)./(E)+(I_80_RR_1_5mm(:,1)/(E)).^2)*(7*6*log(183*6^(-1/3)))*Na*di_density/di_m;
enhance_dat_80GeV_1_5mm = (data_align_80GeV_1_5mm)./(data_amorph_80GeV_1_5mm);
enhance_err_80GeV_1_5mm = abs(enhance_dat_80GeV_1_5mm) .* sqrt ((data_align_80GeV_1_5mm_err ./ data_align_80GeV_1_5mm).^2 +  (data_amorph_80GeV_1_5mm_err ./ data_amorph_80GeV_1_5mm).^2);

fprintf('Finished calculating enhancement\n')
%% Amorph residual
% 20 GeV
% residuals_20GeV_1mm = (data_amorph_20GeV_1mm - eff_20 * sim_amorph_20GeV_1mm);
% residuals_20GeV_1_5mm = (data_amorph_20GeV_1_5mm - eff_20_1_5mm * sim_amorph_20GeV_1_5mm);

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
% f = figure;
% [ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
% axes(ha(1))
% % hold on
% % plot(E20, residuals_20GeV_1mm,'o','MarkerFaceColor','b')
% % plot(E20, zeros(size(E20)),'--','linewidth',1.5)
% % grid on
% % box on
% % xticklabels('auto'); yticklabels('auto')
% % title('Residual 20GeV 1mm')
% % xlabel('E');ylabel('dat - sim')
% % 
% axes(ha(2))
% hold on
% plot(E40, residuals_40GeV_1mm,'o','MarkerFaceColor','b')
% plot(E40, zeros(size(E40)),'--','linewidth',1.5)
% 
% grid on
% box on
% xlabel('E'); ylabel('dat - sim')
% xticklabels('auto'); yticklabels('auto')
% title('Residual 40GeV 1mm')
% 
% axes(ha(3))
% hold on
% plot(E80, residuals_80GeV_1mm,'o','MarkerFaceColor','b')
% plot(E80, zeros(size(E80)),'--','linewidth',1.5)
% 
% grid on
% box on
% xticklabels('auto'); yticklabels('auto')
% title('Residual 80GeV 1mm')
% xlabel('E');ylabel('dat - sim')
% 
% set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])
% 
% % f = figure;
% % [ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
% % axes(ha(1))
% % hold on
% % plot(E20, residuals_20GeV_1_5mm,'o','MarkerFaceColor','b')
% % plot(E20, zeros(size(E20)),'--','linewidth',1.5)
% % 
% % grid on
% % box on
% % xticklabels('auto'); yticklabels('auto')
% % xlabel('E');ylabel('dat - sim')
% % title('Residual 20GeV 1.5mm')
% % 
% % axes(ha(2))
% % hold on
% % plot(E40, residuals_40GeV_1_5mm,'o','MarkerFaceColor','b')
% % plot(E40, zeros(size(E40)),'--','linewidth',1.5)
% % 
% % grid on
% % box on
% % xticklabels('auto'); yticklabels('auto')
% % xlabel('E');ylabel('dat - sim')
% % title('Residual 40GeV 1.5mm')
% % 
% % axes(ha(3))
% % hold on
% % plot(E80, residuals_80GeV_1_5mm,'o','MarkerFaceColor','b')
% % plot(E80, zeros(size(E80)),'--','linewidth',1.5)
% % grid on
% % box on
% % xticklabels('auto'); yticklabels('auto')
% % xlabel('E');ylabel('dat - sim')
% % title('Residual 80GeV 1.5mm')
% % 
% % set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])
% 
%% aligned plot 1mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1));
title('20 GeV 1mm','Interpreter','latex')
hold on
box on
errorbar(E20, data_align_20GeV_1mm,data_align_20GeV_1mm_err,'o','MarkerFaceColor','auto')
plot(E20, eff_20 * sim_align_20GeV_1mm_stoch,'-','linewidth',2.5)
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
plot(E40, eff_40 * sim_align_40GeV_1mm_stoch,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
axpos = get(gca,'Position');
set(gca, 'Position', axpos)
set(gca, 'FontSize', 18)
ax = gca;
ax.FontSize = 18;
ax.YAxis.Exponent = -3;
xticklabels('auto'); yticklabels('auto')
grid on
legend('Data','BKC RR','BKC noRR','Stochastic')

axes(ha(3));
% figure
hold on
box on
title('c)','Interpreter','latex')
errorbar(E80, data_align_80GeV_1mm,data_align_80GeV_1mm_err,'o','MarkerFaceColor','auto')
plot(E80, eff_80 * sim_align_80GeV_1mm_RR,'-','linewidth',2.5)
plot(E80, eff_80 * sim_align_80GeV_1mm_noRR,'-','linewidth',2.5)
plot(E80, eff_80 * sim_align_80GeV_1mm_stoch,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
grid on
legend('Data','BKC RR','BKC noRR','Stochastic')

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])
%% aligned plot 1.5mm
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);

axes(ha(1));
title('20 GeV 1.5mm','Interpreter','latex')
hold on
box on
errorbar(E20, data_align_20GeV_1_5mm/1.5,data_align_20GeV_1_5mm_err/1.5,'^','MarkerFaceColor','auto')
plot(E20, eff_20_1_5mm * sim_align_20GeV_1_5mm_stoch/1.5,'-','linewidth',2.5)
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
errorbar(E40, data_align_40GeV_1_5mm/1.5,data_align_40GeV_1_5mm_err/1.5,'^','MarkerFaceColor','auto')
plot(E40, eff_40_1_5mm * sim_align_40GeV_1_5mm_RR/1.5,'-','linewidth',2.5)
plot(E40, eff_40_1_5mm * sim_align_40GeV_1_5mm_noRR/1.5,'-','linewidth',2.5)
plot(E40, eff_40_1_5mm * sim_align_40GeV_1_5mm_stoch/1.5,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
ax = gca;
ax.FontSize = 18;
ax.YAxis.Exponent = -3;
xticklabels('auto'); yticklabels('auto')
grid on
legend('Data','BKC RR','BKC noRR','Stochastic')

axes(ha(3));
hold on
box on
title('c)','Interpreter','latex')
errorbar(E80, data_align_80GeV_1_5mm/1.5,data_align_80GeV_1_5mm_err/1.5,'^','MarkerFaceColor','auto')
plot(E80, eff_80_1_5mm * sim_align_80GeV_1_5mm_RR/1.5,'-','linewidth',2.5)
plot(E80, eff_80_1_5mm * sim_align_80GeV_1_5mm_noRR/1.5,'-','linewidth',2.5)
plot(E80, eff_80_1_5mm * sim_align_80GeV_1_5mm_stoch/1.5,'-','linewidth',2.5)
xlabel('Energy [GeV]','fontsize',22,'interpreter','latex');
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
set(gca, 'FontSize', 18)
ax = gca;
ax.YAxis.Exponent = -3;
grid on
legend('Data','BKC RR','BKC noRR','Stochastic')

set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18 36],'PaperPosition',[0, 0, 18 36],'Position',[0 0 18 36])
%% enhancement plot
f = figure;
[ha, ~] = tight_subplot(3,1,[.12 .04],[.05 .05],[.07 .07]);
axes(ha(1))
hold on
errorbar(E20, enhance_dat_20GeV_1mm,enhance_err_20GeV_1mm,'o','MarkerFaceColor','auto')
plot(I_20_stoch_1mm(:,1),  I_20_stoch_1mm(:,2) ./ bremstrahlung_20GeV_1mm_stoch,':','linewidth',1.5)
plot(E20, sim_align_20GeV_1mm_stoch ./ sim_amorph_20GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
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
plot(I_40_noRR_1mm(:,1),  I_40_noRR_1mm(:,2) ./ bremstrahlung_40GeV_1mm_noRR,':','linewidth',1.5)
plot(I_40_stoch_1mm(:,1),  I_40_stoch_1mm(:,2) ./ bremstrahlung_40GeV_1mm_noRR,':','linewidth',1.5)
plot(E40, sim_align_40GeV_1mm_RR./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E40, sim_align_40GeV_1mm_noRR./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E40, sim_align_40GeV_1mm_stoch./sim_amorph_40GeV_1mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','RR','noRR','Stochastic')
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
plot(I_80_stoch_1mm(:,1),  I_80_stoch_1mm(:,2) ./ bremstrahlung_80GeV_1mm,':','linewidth',1.5)
plot(E80, sim_align_80GeV_1mm_RR./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E80, sim_align_80GeV_1mm_noRR./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E80, sim_align_80GeV_1mm_stoch./sim_amorph_80GeV_1mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','RR','noRR','Stochastic')
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
plot(I_20_stoch_1_5mm(:,1),  I_20_stoch_1_5mm(:,2) ./ bremstrahlung_20GeV_1_5mm_stoch,':','linewidth',1.5)
plot(E20, sim_align_20GeV_1_5mm_stoch ./ sim_amorph_20GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
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
plot(I_40_RR_1_5mm(:,1),I_40_RR_1_5mm(:,2)./bremstrahlung_40GeV_1_5mm_RR,':','linewidth',1.5)
plot(I_40_noRR_1_5mm(:,1),I_40_noRR_1_5mm(:,2)./bremstrahlung_40GeV_1_5mm_RR,':','linewidth',1.5)
plot(I_40_stoch_1_5mm(:,1),  I_40_stoch_1_5mm(:,2) ./ bremstrahlung_40GeV_1_5mm_RR,':','linewidth',1.5)
plot(E40, sim_align_40GeV_1_5mm_RR./sim_amorph_40GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E40, sim_align_40GeV_1_5mm_noRR./sim_amorph_40GeV_1_5mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E40, sim_align_40GeV_1_5mm_stoch./sim_amorph_40GeV_1_5mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','RR','noRR','Stochastic')
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
plot(I_80_noRR_1_5mm(:,1), I_80_noRR_1_5mm(:,2) ./ bremstrahlung_80GeV_1_5mm_RR,':','linewidth',1.5)
plot(I_80_stoch_1_5mm(:,1),  I_80_stoch_1_5mm(:,2) ./ bremstrahlung_80GeV_1_5mm_RR,':','linewidth',1.5)
plot(E80, sim_align_80GeV_1_5mm_RR./sim_amorph_80GeV_1_5mm,'-','linewidth',1.5,'color',colors(2,:))
plot(E80, sim_align_80GeV_1_5mm_noRR./sim_amorph_80GeV_1_5mm,'-','linewidth',1.5,'color',colors(3,:))
plot(E80, sim_align_80GeV_1_5mm_stoch./sim_amorph_80GeV_1_5mm,'-','linewidth',1.5,'color',colors(4,:))
legend('Data','RR','noRR','Stochastic')
xticklabels('auto'); yticklabels('auto')
xlim([0, 80])
ylim([0, 100]);
grid on
box on
title('enhancement 80GeV 1.5mm')
set(f, 'Units','centimeters','PaperUnits','centimeters', 'PaperSize',[18, 36],'PaperPosition',[0, 0, 18, 36],'Position',[0 0 18, 36])
% 
