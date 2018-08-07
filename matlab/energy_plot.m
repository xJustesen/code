clc; close all; clear all
datpath = '/home/christian/Dropbox/speciale/data/';

%% DATA 20GeV 1mm e- amorphous
energy = linspace(0, 20, 15);

filepath1 = strcat(datpath, 'energy_109.txt');
filepath2 = strcat(datpath, 'energy_115.txt');

nrg_20GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_20GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_20GeV_dat_amorph_tot = [nrg_20GeV_dat1; nrg_20GeV_dat2];

NEvents_20GeV_amorph_tot = 3249247 + 148559;

[counts_dat_20GeV_amorph_1, ~] = hist(nrg_20GeV_dat1(nrg_20GeV_dat1 < 20 & nrg_20GeV_dat1 > 0), energy);
[counts_dat_20GeV_amorph_2, ~] = hist(nrg_20GeV_dat2(nrg_20GeV_dat2 < 20 & nrg_20GeV_dat2 > 0), energy);

counts_dat_20GeV_amorph_norm_1 = counts_dat_20GeV_amorph_1/3249247;
counts_dat_20GeV_amorph_norm_2 = counts_dat_20GeV_amorph_2/148559;

[counts_dat_20GeV_amorph_tot, ~] = hist(nrg_20GeV_dat_amorph_tot(nrg_20GeV_dat_amorph_tot < 20 & nrg_20GeV_dat_amorph_tot > 0), energy);
counts_dat_20GeV_amorph_norm_tot = counts_dat_20GeV_amorph_tot/NEvents_20GeV_amorph_tot;

%% DATA 20GeV 1mm e- background
filepath1 = strcat(datpath, 'energy_105.txt');
filepath2 = strcat(datpath, 'energy_106.txt');
filepath3 = strcat(datpath, 'energy_107.txt');
filepath4 = strcat(datpath, 'energy_108.txt');
filepath5 = strcat(datpath, 'energy_110.txt');
filepath6 = strcat(datpath, 'energy_111.txt');

nrg_20GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_20GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_20GeV_dat3 = load(filepath3) * 6.2415091E9;
nrg_20GeV_dat4 = load(filepath4) * 6.2415091E9;
nrg_20GeV_dat5 = load(filepath5) * 6.2415091E9;
nrg_20GeV_dat6 = load(filepath6) * 6.2415091E9;

nrg_20GeV_dat_bg_tot = [nrg_20GeV_dat1; nrg_20GeV_dat2; nrg_20GeV_dat3; nrg_20GeV_dat4; nrg_20GeV_dat5; nrg_20GeV_dat6];
NEvents_20GeV_dat_bg_tot = 382505 + 696187 + 738157 + 869787 + 1653683 + 1426207;

[counts_dat_20GeV_bg_tot, ~] = hist(nrg_20GeV_dat_bg_tot(nrg_20GeV_dat_bg_tot < 20 & nrg_20GeV_dat_bg_tot > 0), energy);
counts_dat_20GeV_bg_norm_tot = counts_dat_20GeV_bg_tot/NEvents_20GeV_dat_bg_tot;

[counts_dat_20GeV_bg_1, ~] = hist(nrg_20GeV_dat1(nrg_20GeV_dat1 < 20 & nrg_20GeV_dat1 > 0), energy);
[counts_dat_20GeV_bg_2, ~] = hist(nrg_20GeV_dat2(nrg_20GeV_dat2 < 20 & nrg_20GeV_dat2 > 0), energy);
[counts_dat_20GeV_bg_3, ~] = hist(nrg_20GeV_dat3(nrg_20GeV_dat3 < 20 & nrg_20GeV_dat3 > 0), energy);
[counts_dat_20GeV_bg_4, ~] = hist(nrg_20GeV_dat4(nrg_20GeV_dat4 < 20 & nrg_20GeV_dat4 > 0), energy);
[counts_dat_20GeV_bg_5, ~] = hist(nrg_20GeV_dat5(nrg_20GeV_dat5 < 20 & nrg_20GeV_dat5 > 0), energy);
[counts_dat_20GeV_bg_6, ~] = hist(nrg_20GeV_dat6(nrg_20GeV_dat6 < 20 & nrg_20GeV_dat6 > 0), energy);

counts_dat_20GeV_bg_norm_1 = counts_dat_20GeV_bg_1/382505;
counts_dat_20GeV_bg_norm_2 = counts_dat_20GeV_bg_2/696187;
counts_dat_20GeV_bg_norm_3 = counts_dat_20GeV_bg_3/738157;
counts_dat_20GeV_bg_norm_4 = counts_dat_20GeV_bg_4/869787;
counts_dat_20GeV_bg_norm_5 = counts_dat_20GeV_bg_5/1653683;
counts_dat_20GeV_bg_norm_6 = counts_dat_20GeV_bg_6/1426207;

%% SIM 20GeV 1mm e- amorph + backogrund
filepath1 = strcat(datpath,'energy_sim_amorphous1_20GeV.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_20GeV.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_20GeV.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_20GeV.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_20GeV.txt');

nrg_20GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_20GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_20GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_20GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_20GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_20GeV_sim_amorph_bg = [nrg_20GeV_sim1; nrg_20GeV_sim2; nrg_20GeV_sim3; nrg_20GeV_sim4; nrg_20GeV_sim5];
[counts_sim_20GeV_amorph_bg, ~] = hist(nrg_20GeV_sim_amorph_bg(nrg_20GeV_sim_amorph_bg < 20 & nrg_20GeV_sim_amorph_bg > 0), energy);
counts_sim_20GeV_amorph_bg_norm = counts_sim_20GeV_amorph_bg/2.5e6;

%% SIM 20GeV 1mm e- amorph
filepath1 = strcat(datpath,'energy_sim_amorphous1_20GeV_no_background.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_20GeV_no_background.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_20GeV_no_background.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_20GeV_no_background.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_20GeV_no_background.txt');

nrg_20GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_20GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_20GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_20GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_20GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_20GeV_sim_amorph = [nrg_20GeV_sim1; nrg_20GeV_sim2; nrg_20GeV_sim3; nrg_20GeV_sim4; nrg_20GeV_sim5];
[counts_sim_20GeV_amorph, ~] = hist(nrg_20GeV_sim_amorph(nrg_20GeV_sim_amorph < 20 & nrg_20GeV_sim_amorph > 0), energy);
counts_sim_20GeV_amorph_norm = counts_sim_20GeV_amorph/5e6;

%% SIM 20GeV 1mm e- background
filepath1 = strcat(datpath,'energy_sim_background1_20GeV.txt');
filepath2 = strcat(datpath,'energy_sim_background2_20GeV.txt');
filepath3 = strcat(datpath,'energy_sim_background3_20GeV.txt');
filepath4 = strcat(datpath,'energy_sim_background4_20GeV.txt');
filepath5 = strcat(datpath,'energy_sim_background5_20GeV.txt');

nrg_20GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_20GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_20GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_20GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_20GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_20GeV_sim_bg = [nrg_20GeV_sim1; nrg_20GeV_sim2; nrg_20GeV_sim3; nrg_20GeV_sim4; nrg_20GeV_sim5];
[counts_sim_20GeV_bg, ~] = hist(nrg_20GeV_sim_bg(nrg_20GeV_sim_bg < 20 & nrg_20GeV_sim_bg > 0), energy);
counts_sim_20GeV_bg_norm = counts_sim_20GeV_bg/2.5e6;

%% DATA 40GeV 1mm e- background
energy = linspace(0, 40, 30);

filepath1 = strcat(datpath,'energy_74.txt');
nrg_40GeV_dat_bg = load(filepath1) * 6.2415091E9;
[counts_dat_40GeV_bg, ~] = hist(nrg_40GeV_dat_bg(nrg_40GeV_dat_bg < 40 & nrg_40GeV_dat_bg > 0), energy);
counts_dat_40GeV_bg_norm = counts_dat_40GeV_bg/3330436;

%% DATA 40GeV 1mm e- aligned
filepath1 = strcat(datpath,'energy_71_testparams.txt');
filepath2 = strcat(datpath,'energy_72_testparams.txt');
filepath3 = strcat(datpath,'energy_79_testparams.txt');
filepath4 = strcat(datpath,'energy_80_testparams.txt');
filepath5 = strcat(datpath,'energy_81_testparams.txt');

nrg_40GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_dat3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_dat4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_dat5 = load(filepath5) * 6.2415091E9;

NEvents_40GeV_aligned_tot = 157015 + 520239 + 504200 + 1409253 + 1395830;
nrg_40GeV_dat_aligned_tot = [nrg_40GeV_dat1; nrg_40GeV_dat2; nrg_40GeV_dat3; nrg_40GeV_dat4; nrg_40GeV_dat5];
[counts_dat_40GeV_aligned_tot, ~] = hist(nrg_40GeV_dat_aligned_tot(nrg_40GeV_dat_aligned_tot < 40 & nrg_40GeV_dat_aligned_tot > 0), energy);

[counts_dat_40GeV_aligned_1, ~] = hist(nrg_40GeV_dat1(nrg_40GeV_dat1 < 40 & nrg_40GeV_dat1 > 0), energy);
[counts_dat_40GeV_aligned_2, ~] = hist(nrg_40GeV_dat2(nrg_40GeV_dat2 < 40 & nrg_40GeV_dat2 > 0), energy);
[counts_dat_40GeV_aligned_3, ~] = hist(nrg_40GeV_dat3(nrg_40GeV_dat3 < 40 & nrg_40GeV_dat3 > 0), energy);
[counts_dat_40GeV_aligned_4, ~] = hist(nrg_40GeV_dat4(nrg_40GeV_dat4 < 40 & nrg_40GeV_dat4 > 0), energy);
[counts_dat_40GeV_aligned_5, ~] = hist(nrg_40GeV_dat5(nrg_40GeV_dat5 < 40 & nrg_40GeV_dat5 > 0), energy);

counts_dat_40GeV_aligned_norm_tot = counts_dat_40GeV_aligned_tot/NEvents_40GeV_aligned_tot;

counts_dat_40GeV_aligned_norm_1 = counts_dat_40GeV_aligned_1/157015;
counts_dat_40GeV_aligned_norm_2 = counts_dat_40GeV_aligned_2/520239;
counts_dat_40GeV_aligned_norm_3 = counts_dat_40GeV_aligned_3/504200;
counts_dat_40GeV_aligned_norm_4 = counts_dat_40GeV_aligned_4/1409253;
counts_dat_40GeV_aligned_norm_5 = counts_dat_40GeV_aligned_5/1395830;

%% DATA 40GeV 1mm e- amoprh.
filepath1 = strcat(datpath,'energy_73.txt');
filepath2 = strcat(datpath,'energy_75.txt');
filepath3 = strcat(datpath,'energy_76.txt');
filepath4 = strcat(datpath,'energy_77.txt');
filepath5 = strcat(datpath,'energy_78.txt');

nrg_40GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_dat3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_dat4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_dat5 = load(filepath5) * 6.2415091E9;

NEvents_40GeV_amorph_tot = 1419411 + 1495264 + 1588451 + 786876 + 1596144;
nrg_40GeV_dat_amorph_tot = [nrg_40GeV_dat1; nrg_40GeV_dat2; nrg_40GeV_dat3; nrg_40GeV_dat4; nrg_40GeV_dat5];
[counts_dat_40GeV_amorph_tot, ~] = hist(nrg_40GeV_dat_amorph_tot(nrg_40GeV_dat_amorph_tot < 40 & nrg_40GeV_dat_amorph_tot > 0), energy);

[counts_dat_40GeV_amorph_1, ~] = hist(nrg_40GeV_dat1(nrg_40GeV_dat1 < 40 & nrg_40GeV_dat1 > 0), energy);
[counts_dat_40GeV_amorph_2, ~] = hist(nrg_40GeV_dat2(nrg_40GeV_dat2 < 40 & nrg_40GeV_dat2 > 0), energy);
[counts_dat_40GeV_amorph_3, ~] = hist(nrg_40GeV_dat3(nrg_40GeV_dat3 < 40 & nrg_40GeV_dat3 > 0), energy);
[counts_dat_40GeV_amorph_4, ~] = hist(nrg_40GeV_dat4(nrg_40GeV_dat4 < 40 & nrg_40GeV_dat4 > 0), energy);
[counts_dat_40GeV_amorph_5, ~] = hist(nrg_40GeV_dat5(nrg_40GeV_dat5 < 40 & nrg_40GeV_dat5 > 0), energy);

counts_dat_40GeV_amorph_norm_tot = counts_dat_40GeV_amorph_tot/NEvents_40GeV_amorph_tot;

counts_dat_40GeV_amorph_norm_1 = counts_dat_40GeV_amorph_1/1419411;
counts_dat_40GeV_amorph_norm_2 = counts_dat_40GeV_amorph_2/1495264;
counts_dat_40GeV_amorph_norm_3 = counts_dat_40GeV_amorph_3/1588451;
counts_dat_40GeV_amorph_norm_4 = counts_dat_40GeV_amorph_4/786876;
counts_dat_40GeV_amorph_norm_5 = counts_dat_40GeV_amorph_5/1596144;

%% SIM 40GeV 1mm e- aligned
filepath1 = strcat(datpath,'energy_sim_aligned1_40GeV_no_background.txt');
filepath2 = strcat(datpath,'energy_sim_aligned2_40GeV_no_background.txt');
filepath3 = strcat(datpath,'energy_sim_aligned3_40GeV_no_background.txt');
filepath4 = strcat(datpath,'energy_sim_aligned4_40GeV_no_background.txt');
filepath5 = strcat(datpath,'energy_sim_aligned5_40GeV_no_background.txt');

nrg_40GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_40GeV_sim_aligned = [nrg_40GeV_sim1; nrg_40GeV_sim2; nrg_40GeV_sim3; nrg_40GeV_sim4; nrg_40GeV_sim5];
[counts_sim_40GeV_aligned, ~] = hist(nrg_40GeV_sim_aligned(nrg_40GeV_sim_aligned < 40 & nrg_40GeV_sim_aligned > 0), energy);
counts_sim_40GeV_aligned_norm = counts_sim_40GeV_aligned/5e6;

%% SIM 40GeV 1mm e- amorph + backogrund
filepath1 = strcat(datpath,'energy_sim_amorphous1_40GeV.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_40GeV.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_40GeV.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_40GeV.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_40GeV.txt');

nrg_40GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_40GeV_sim_amorph_bg = [nrg_40GeV_sim1; nrg_40GeV_sim2; nrg_40GeV_sim3; nrg_40GeV_sim4; nrg_40GeV_sim5];
[counts_sim_40GeV_amorph_bg, ~] = hist(nrg_40GeV_sim_amorph_bg(nrg_40GeV_sim_amorph_bg < 40 & nrg_40GeV_sim_amorph_bg > 0), energy);
counts_sim_40GeV_amorph_bg_norm = counts_sim_40GeV_amorph_bg/5e6;

%% SIM 40GeV 1mm e- amorph
filepath1 = strcat(datpath,'energy_sim_amorphous1_40GeV_no_background.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_40GeV_no_background.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_40GeV_no_background.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_40GeV_no_background.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_40GeV_no_background.txt');

nrg_40GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_40GeV_sim_amorph = [nrg_40GeV_sim1; nrg_40GeV_sim2; nrg_40GeV_sim3; nrg_40GeV_sim4; nrg_40GeV_sim5];
[counts_sim_40GeV_amorph, ~] = hist(nrg_40GeV_sim_amorph(nrg_40GeV_sim_amorph < 40 & nrg_40GeV_sim_amorph > 0), energy);
counts_sim_40GeV_amorph_norm = counts_sim_40GeV_amorph/5e5;

%% SIM 40GeV 1mm e- background
filepath1 = strcat(datpath,'energy_sim_background1_40GeV.txt');
filepath2 = strcat(datpath,'energy_sim_background2_40GeV.txt');
filepath3 = strcat(datpath,'energy_sim_background3_40GeV.txt');
filepath4 = strcat(datpath,'energy_sim_background4_40GeV.txt');
filepath5 = strcat(datpath,'energy_sim_background5_40GeV.txt');

nrg_40GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_40GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_40GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_40GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_40GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_40GeV_sim_bg = [nrg_40GeV_sim1; nrg_40GeV_sim2; nrg_40GeV_sim3; nrg_40GeV_sim4; nrg_40GeV_sim5];
[counts_sim_40GeV_bg, ~] = hist(nrg_40GeV_sim_bg(nrg_40GeV_sim_bg < 40 & nrg_40GeV_sim_bg > 0), energy);
counts_sim_40GeV_bg_norm = counts_sim_40GeV_bg/5e5;

%% DATA 80GeV 1mm e- background
energy = linspace(0, 80, 60);
filepath1 = strcat(datpath,'energy_85_testparams.txt');
filepath2 = strcat(datpath,'energy_90_testparams.txt');
filepath3 = strcat(datpath,'energy_91_testparams.txt');

NEvents_80GeV_dat_bg_tot = 2023539 + 2026709 + 1300938;
nrg_80GeV_dat_bg1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_dat_bg2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_dat_bg3 = load(filepath3) * 6.2415091E9;

nrg_80GeV_dat_bg_tot = [nrg_80GeV_dat_bg1; nrg_80GeV_dat_bg2; nrg_80GeV_dat_bg3];
[counts_dat_80GeV_bg_tot, ~] = hist(nrg_80GeV_dat_bg_tot(nrg_80GeV_dat_bg_tot < 80 & nrg_80GeV_dat_bg_tot > 0), energy);
counts_dat_80GeV_bg_norm_tot = counts_dat_80GeV_bg_tot/NEvents_80GeV_dat_bg_tot;

%% DATA 80GeV 1mm e- amoprh.
filepath1 = strcat(datpath,'energy_86_testparams.txt');
filepath2 = strcat(datpath,'energy_87_testparams.txt');
filepath3 = strcat(datpath,'energy_88_testparams.txt');
filepath4 = strcat(datpath,'energy_89_testparams.txt');

nrg_80GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_dat3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_dat4 = load(filepath4) * 6.2415091E9;

NEvents_80GeV_amorph_tot = 1837156 + 1254664 + 1295201 + 577897;
nrg_80GeV_dat_amorph_tot = [nrg_80GeV_dat1; nrg_80GeV_dat2; nrg_80GeV_dat3; nrg_80GeV_dat4];
[counts_dat_80GeV_amorph_tot, ~] = hist(nrg_80GeV_dat_amorph_tot(nrg_80GeV_dat_amorph_tot < 80 & nrg_80GeV_dat_amorph_tot > 0), energy);

[counts_dat_80GeV_amorph_1, ~] = hist(nrg_80GeV_dat1(nrg_80GeV_dat1 < 80 & nrg_80GeV_dat1 > 0), energy);
[counts_dat_80GeV_amorph_2, ~] = hist(nrg_80GeV_dat2(nrg_80GeV_dat2 < 80 & nrg_80GeV_dat2 > 0), energy);
[counts_dat_80GeV_amorph_3, ~] = hist(nrg_80GeV_dat3(nrg_80GeV_dat3 < 80 & nrg_80GeV_dat3 > 0), energy);
[counts_dat_80GeV_amorph_4, ~] = hist(nrg_80GeV_dat4(nrg_80GeV_dat4 < 80 & nrg_80GeV_dat4 > 0), energy);

counts_dat_80GeV_amorph_norm_tot = counts_dat_80GeV_amorph_tot/NEvents_80GeV_amorph_tot;

counts_dat_80GeV_amorph_norm_1 = counts_dat_80GeV_amorph_1/1837156;
counts_dat_80GeV_amorph_norm_2 = counts_dat_80GeV_amorph_2/1254664;
counts_dat_80GeV_amorph_norm_3 = counts_dat_80GeV_amorph_3/1295201;
counts_dat_80GeV_amorph_norm_4 = counts_dat_80GeV_amorph_4/577897;

%% SIM 80GeV 1mm e- amorph + backogrund
filepath1 = strcat(datpath,'energy_sim_amorphous1_80GeV.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_80GeV.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_80GeV.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_80GeV.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_80GeV.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_amorph_bg = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_amorph_bg, ~] = hist(nrg_80GeV_sim_amorph_bg(nrg_80GeV_sim_amorph_bg < 80 & nrg_80GeV_sim_amorph_bg > 0), energy);
counts_sim_80GeV_amorph_bg_norm = counts_sim_80GeV_amorph_bg/5e6;

%% SIM 80GeV 1mm e- amorph
filepath1 = strcat(datpath,'energy_sim_amorphous1_80GeV_no_background.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_80GeV_no_background.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_80GeV_no_background.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_80GeV_no_background.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_80GeV_no_background.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_amorph = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_amorph, ~] = hist(nrg_80GeV_sim_amorph(nrg_80GeV_sim_amorph < 80 & nrg_80GeV_sim_amorph > 0), energy);
counts_sim_80GeV_amorph_norm = counts_sim_80GeV_amorph/5e5;

%% SIM 80GeV 1mm e- background
filepath1 = strcat(datpath,'energy_sim_background1_80GeV.txt');
filepath2 = strcat(datpath,'energy_sim_background2_80GeV.txt');
filepath3 = strcat(datpath,'energy_sim_background3_80GeV.txt');
filepath4 = strcat(datpath,'energy_sim_background4_80GeV.txt');
filepath5 = strcat(datpath,'energy_sim_background5_80GeV.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_bg = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_bg, ~] = hist(nrg_80GeV_sim_bg(nrg_80GeV_sim_bg < 80 & nrg_80GeV_sim_bg > 0), energy);
counts_sim_80GeV_bg_norm = counts_sim_80GeV_bg/5e6;

%% DATA 80GeV 1.5mm e- background
filepath1 = strcat(datpath,'energy_48.txt');
filepath2 = strcat(datpath,'energy_54.txt');
filepath3 = strcat(datpath,'energy_55.txt');

NEvents_80GeV_dat_bg_1_5mm_tot = 2672749 + 330905 + 231504;

nrg_80GeV_dat_bg1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_dat_bg2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_dat_bg3 = load(filepath3) * 6.2415091E9;

nrg_80GeV_dat_bg_1_5mm_tot = [nrg_80GeV_dat_bg1; nrg_80GeV_dat_bg2; nrg_80GeV_dat_bg3];
[counts_dat_80GeV_bg_1_5mm_tot, ~] = hist(nrg_80GeV_dat_bg_1_5mm_tot(nrg_80GeV_dat_bg_1_5mm_tot < 80 & nrg_80GeV_dat_bg_1_5mm_tot > 0), energy);
counts_dat_80GeV_bg_norm_1_5mm_tot = counts_dat_80GeV_bg_1_5mm_tot/NEvents_80GeV_dat_bg_1_5mm_tot;

%% DATA 80GeV 1.5mm e- amoprh.
filepath1 = strcat(datpath,'energy_49.txt');
filepath2 = strcat(datpath,'energy_50.txt');
filepath3 = strcat(datpath,'energy_51.txt');
filepath4 = strcat(datpath,'energy_52.txt');
filepath5 = strcat(datpath,'energy_53.txt');
filepath6 = strcat(datpath,'energy_56.txt');
filepath7 = strcat(datpath,'energy_57.txt');

nrg_80GeV_dat1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_dat2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_dat3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_dat4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_dat5 = load(filepath5) * 6.2415091E9;
nrg_80GeV_dat6 = load(filepath6) * 6.2415091E9;
nrg_80GeV_dat7 = load(filepath7) * 6.2415091E9;

NEvents_80GeV_amorph_1_5mm_tot = 932824 + 462386 + 898639 + 193486 + 19952 + 420023 + 529158;
nrg_80GeV_dat_amorph_1_5mm_tot = [nrg_80GeV_dat1; nrg_80GeV_dat2; nrg_80GeV_dat3; nrg_80GeV_dat4; nrg_80GeV_dat5; nrg_80GeV_dat6; nrg_80GeV_dat7];
[counts_dat_80GeV_amorph_1_5mm_tot, ~] = hist(nrg_80GeV_dat_amorph_1_5mm_tot(nrg_80GeV_dat_amorph_1_5mm_tot < 80 & nrg_80GeV_dat_amorph_1_5mm_tot > 0), energy);

[counts_dat_80GeV_amorph_1, ~] = hist(nrg_80GeV_dat1(nrg_80GeV_dat1 < 80 & nrg_80GeV_dat1 > 0), energy);
[counts_dat_80GeV_amorph_2, ~] = hist(nrg_80GeV_dat2(nrg_80GeV_dat2 < 80 & nrg_80GeV_dat2 > 0), energy);
[counts_dat_80GeV_amorph_3, ~] = hist(nrg_80GeV_dat3(nrg_80GeV_dat3 < 80 & nrg_80GeV_dat3 > 0), energy);
[counts_dat_80GeV_amorph_4, ~] = hist(nrg_80GeV_dat4(nrg_80GeV_dat4 < 80 & nrg_80GeV_dat4 > 0), energy);
[counts_dat_80GeV_amorph_5, ~] = hist(nrg_80GeV_dat5(nrg_80GeV_dat5 < 80 & nrg_80GeV_dat5 > 0), energy);
[counts_dat_80GeV_amorph_6, ~] = hist(nrg_80GeV_dat6(nrg_80GeV_dat6 < 80 & nrg_80GeV_dat6 > 0), energy);

counts_dat_80GeV_amorph_norm_1_5mm_tot = counts_dat_80GeV_amorph_1_5mm_tot/NEvents_80GeV_amorph_1_5mm_tot;

%% SIM 80GeV 1.5mm e- amorph + backogrund
filepath1 = strcat(datpath,'energy_sim_amorphous1_80GeV_1.5mm.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_80GeV_1.5mm.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_80GeV_1.5mm.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_80GeV_1.5mm.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_80GeV_1.5mm.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_amorph = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_amorph_bg, ~] = hist(nrg_80GeV_sim_amorph(nrg_80GeV_sim_amorph < 80 & nrg_80GeV_sim_amorph > 0), energy);
counts_sim_80GeV_amorph_bg_1_5mm_norm = counts_sim_80GeV_amorph_bg/5e6;

%% SIM 80GeV 1.5mm e- amorph
filepath1 = strcat(datpath,'energy_sim_amorphous1_80GeV_1.5mm_no_background.txt');
filepath2 = strcat(datpath,'energy_sim_amorphous2_80GeV_1.5mm_no_background.txt');
filepath3 = strcat(datpath,'energy_sim_amorphous3_80GeV_1.5mm_no_background.txt');
filepath4 = strcat(datpath,'energy_sim_amorphous4_80GeV_1.5mm_no_background.txt');
filepath5 = strcat(datpath,'energy_sim_amorphous5_80GeV_1.5mm_no_background.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_amorph = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_amorph_1_5mm, ~] = hist(nrg_80GeV_sim_amorph(nrg_80GeV_sim_amorph < 80 & nrg_80GeV_sim_amorph > 0), energy);
counts_sim_80GeV_amorph_1_5mm_norm = counts_sim_80GeV_amorph_1_5mm/5e6;

%% SIM 80GeV 1.5mm e- background
filepath1 = strcat(datpath,'energy_sim_background1_80GeV_1.5mm.txt');
filepath2 = strcat(datpath,'energy_sim_background2_80GeV_1.5mm.txt');
filepath3 = strcat(datpath,'energy_sim_background3_80GeV_1.5mm.txt');
filepath4 = strcat(datpath,'energy_sim_background4_80GeV_1.5mm.txt');
filepath5 = strcat(datpath,'energy_sim_background5_80GeV_1.5mm.txt');

nrg_80GeV_sim1 = load(filepath1) * 6.2415091E9;
nrg_80GeV_sim2 = load(filepath2) * 6.2415091E9;
nrg_80GeV_sim3 = load(filepath3) * 6.2415091E9;
nrg_80GeV_sim4 = load(filepath4) * 6.2415091E9;
nrg_80GeV_sim5 = load(filepath5) * 6.2415091E9;

nrg_80GeV_sim_bg = [nrg_80GeV_sim1; nrg_80GeV_sim2; nrg_80GeV_sim3; nrg_80GeV_sim4; nrg_80GeV_sim5];
[counts_sim_80GeV_bg_1_5mm, ~] = hist(nrg_80GeV_sim_bg(nrg_80GeV_sim_bg < 80 & nrg_80GeV_sim_bg > 0), energy);
counts_sim_80GeV_bg_1_5mm_norm = counts_sim_80GeV_bg_1_5mm/2.5e6;

%% plot
% energy = linspace(0, 40, 30);
% figure
% hold on
% title('40GeV e- ; 1.0mm C ; Amorph')
% errorbar(energy, counts_dat_40GeV_amorph_norm_tot, sqrt(counts_dat_40GeV_amorph_tot)/NEvents_40GeV_amorph_tot,'.')
% errorbar(energy, counts_dat_40GeV_bg_norm, sqrt(counts_dat_40GeV_bg_norm)/3330436,'^')
% errorbar(energy, counts_dat_40GeV_amorph_norm_tot - counts_dat_40GeV_bg_norm, sqrt(counts_dat_40GeV_amorph_tot)/NEvents_40GeV_amorph_tot + sqrt(counts_dat_40GeV_bg)/3330436,'o')
% errorbar(energy, counts_sim_40GeV_amorph_norm, sqrt(counts_sim_40GeV_amorph_norm)/5e5,'o-')
% errorbar(energy, counts_sim_40GeV_bg_norm, sqrt(counts_sim_40GeV_bg)/2e6,'^-')
% errorbar(energy, counts_sim_40GeV_amorph_bg_norm, sqrt(counts_sim_40GeV_amorph_bg)/2e6,'^-')
% errorbar(energy, counts_sim_40GeV_amorph_bg_norm - counts_sim_40GeV_bg_norm, sqrt(counts_sim_40GeV_amorph_bg_norm)/2e6 + sqrt(counts_sim_40GeV_bg)/2e6,'^-')
% legend('Amorph + background','Background','Amorph - background','Amorph sim', 'Bckground sim', 'Amorph + background sim', 'Amorph sim + background sim - background sim')
% 
energy = linspace(0, 80, 60);
% 
figure
hold on
title('80GeV e- ; 1.5mm C ; Amorph')
% errorbar(energy, counts_dat_80GeV_amorph_norm_1_5mm_tot, sqrt(counts_dat_80GeV_amorph_1_5mm_tot)/NEvents_80GeV_amorph_1_5mm_tot,'.')
% errorbar(energy, counts_dat_80GeV_bg_norm_1_5mm_tot, sqrt(counts_dat_80GeV_bg_1_5mm_tot)/NEvents_80GeV_dat_bg_1_5mm_tot,'^')
errorbar(energy, counts_dat_80GeV_amorph_norm_1_5mm_tot - counts_dat_80GeV_bg_norm_1_5mm_tot, sqrt(counts_dat_80GeV_amorph_1_5mm_tot)/NEvents_80GeV_amorph_1_5mm_tot + sqrt(counts_dat_80GeV_bg_1_5mm_tot)/NEvents_80GeV_dat_bg_1_5mm_tot,'o')
plot(energy, .65*counts_sim_80GeV_amorph_1_5mm_norm,'-')
% plot(energy, counts_sim_80GeV_bg_1_5mm_norm,'-')
% plot(energy, counts_sim_80GeV_amorph_bg_1_5mm_norm,'-')
% plot(energy, counts_sim_80GeV_amorph_bg_1_5mm_norm - counts_sim_80GeV_bg_1_5mm_norm, '-')
% legend('Amorph + background','Background','Amorph - background','Amorph sim', 'Bckground sim', 'Amorph + background sim', 'Amorph sim + background sim - background sim')

figure
hold on
title('80GeV e- ; 1.5 C ; Amorph ; Difference')
plot(energy, 100 * abs( counts_dat_80GeV_amorph_norm_1_5mm_tot - counts_dat_80GeV_bg_norm_1_5mm_tot - 0.7*counts_sim_80GeV_amorph_1_5mm_norm)./abs(0.7*counts_sim_80GeV_amorph_1_5mm_norm))

% % 
% figure
% hold on
% title('80GeV e- ; 1.0mm C ; Amorph')
% errorbar(energy, counts_dat_80GeV_amorph_norm_tot, sqrt(counts_dat_80GeV_amorph_norm_tot)/NEvents_80GeV_amorph_tot,'.')
% errorbar(energy, counts_dat_80GeV_bg_norm_tot, sqrt(counts_dat_80GeV_bg_tot)/NEvents_80GeV_dat_bg_tot,'^')
% errorbar(energy, counts_dat_80GeV_amorph_norm_tot - counts_dat_80GeV_bg_norm_tot, sqrt(counts_dat_80GeV_amorph_norm_tot)/NEvents_80GeV_amorph_tot + sqrt(counts_dat_80GeV_bg_norm_tot)/NEvents_80GeV_dat_bg_tot,'o')
% errorbar(energy, counts_sim_80GeV_amorph_norm, sqrt(counts_sim_80GeV_amorph_norm)/5e6 ,'s-')
% % errorbar(energy, counts_sim_80GeV_bg_norm, sqrt(counts_sim_80GeV_bg_norm)/2e6,'*-')
% % errorbar(energy, counts_sim_80GeV_amorph_bg_norm, sqrt(counts_sim_80GeV_amorph_bg)/2e6,'^-')
% % errorbar(energy, counts_sim_80GeV_amorph_bg_norm - counts_sim_80GeV_bg_norm, sqrt(counts_sim_80GeV_amorph_bg_norm)/2e6 + sqrt(counts_sim_80GeV_bg_norm)/2e6,'^-')
% legend('Amorph + background','Background','Amorph - background','Amorph sim', 'Bckground sim', 'Amorph + background sim', 'Amorph sim + background sim - background sim')
% % 
energy = linspace(0, 20, 15);
figure
hold on
title('20GeV e- ; 1.0mm C ; Amorph')
% errorbar(energy, counts_dat_20GeV_amorph_norm_tot, sqrt(counts_dat_20GeV_amorph_tot)/NEvents_20GeV_amorph_tot,'.')
% errorbar(energy, counts_dat_20GeV_bg_norm_tot, sqrt(counts_dat_20GeV_bg_tot)/NEvents_20GeV_dat_bg_tot,'^')
errorbar(energy, counts_dat_20GeV_amorph_norm_tot - counts_dat_20GeV_bg_norm_tot, sqrt(counts_dat_20GeV_amorph_tot)/NEvents_20GeV_amorph_tot + sqrt(counts_dat_20GeV_bg_tot)/NEvents_20GeV_dat_bg_tot,'o')
plot(energy, counts_sim_20GeV_amorph_norm,'-')
% plot(energy, counts_sim_20GeV_bg_norm, '-')
% plot(energy, counts_sim_20GeV_amorph_bg_norm, '-')
% plot(energy, counts_sim_20GeV_amorph_bg_norm - counts_sim_20GeV_bg_norm,'-')
% legend('Amorph + background','Background','Amorph - background','Amorph sim', 'Bckground sim', 'Amorph + background sim', 'Amorph sim + background sim - background sim')
