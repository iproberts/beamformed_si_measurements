% File: main_beamformed_si_measurements.m
% Summary: This script demonstrates examplar use of the statistical
% characterizations of mmWave self-interference in [1]. The plots generated
% herein can be compared to those in [1], illustrating how this statistical
% modeling of self-interference aligns with collected measurements.
% 
% Reference:
%  [1] I.P. Roberts et al., "Beamformed Self-Interference Measurements at
%  28 GHz: Spatial Insights and Angular Spread," IEEE Trans. Wireless
%  Commun.
% 
% https://github.com/iproberts/beamformed_si_measurements
% 
% Notes:
%  - Neighborhood sizes (delta_theta, delta_phi) are in degrees.
%  - delta_theta and delta_phi should range from 0 to 5 degrees.
%  - INR values herein are all in decibels.
%  - Plot titles "Compare to Fig. X" refers to Fig. X in [1].
% -------------------------------------------------------------------------
clc; clearvars; close all;

%% ------------------------------------------------------------------------
% A. Realize INR range based on neighborhood size.
% -------------------------------------------------------------------------
delta_theta = 2; % degrees
delta_phi = 2; % degrees
[a,b] = get_gamma_params_rng(delta_theta,delta_phi); % alpha, beta

% draw realizations
r = gamrnd(a,b,1000,1); % INR range (in dB; see definition in [1])

% plot CDF
[f,x] = ecdf(r);
figure(1);
plot(x,f);
grid on;
grid minor;
xlabel('INR Range (dB)');
ylabel('Cumulative Probability');
xlim([0,70]);
title(['Neighborhood Size: (' num2str(delta_theta) ',' num2str(delta_phi) ')']);

%% ------------------------------------------------------------------------
% B. Realize minimum INR based on neighborhood size.
% -------------------------------------------------------------------------
delta_theta = 2;
delta_phi = 2;
[m,s] = get_normal_params_min(delta_theta,delta_phi); % mean, variance

% draw realizations
r = normrnd(m,sqrt(s),1000,1); % minimum INR distribution (in dB)

% plot CDF
[f,x] = ecdf(r);
figure(2);
plot(x,f);
grid on;
grid minor;
xlabel('Minimum INR (dB)');
ylabel('Cumulative Probability');
xlim([-40,40]);
title(['Neighborhood Size: (' num2str(delta_theta) ',' num2str(delta_phi) ')']);

%% ------------------------------------------------------------------------
% C. Realize Delta minimum INR based on neighborhood size and nominal INR.
% -------------------------------------------------------------------------
delta_theta_phi = 2; % Here, delta_theta = delta_phi
INR_dB = 0; % nominal INR (in dB)
[a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);

% draw realizations
r = gamrnd(a,b,1000,1); % Delta minimum INR (in dB; see [1] for definition)

% plot CDF
[f,x] = ecdf(r);
figure(3);
plot(x,f);
grid on;
grid minor;
xlabel('Delta Minimum INR (dB)');
ylabel('Cumulative Probability');
xlim([0,40]);
title(['Neighborhood Size: (' num2str(delta_theta) ',' num2str(delta_phi) '), Nominal INR: ' num2str(INR_dB) ' dB']);

%% ------------------------------------------------------------------------
% D. Realize maximum INR based on neighborhood size.
% -------------------------------------------------------------------------
delta_theta = 2;
delta_phi = 2;
[m,s] = get_normal_params_max(delta_theta,delta_phi);

% draw realizations
r = normrnd(m,sqrt(s),1000,1); % maximum INR distribution (in dB) 

% plot CDF
[f,x] = ecdf(r);
figure(4);
plot(x,f);
grid on;
grid minor;
xlabel('Maximum INR (dB)');
ylabel('Cumulative Probability');
xlim([0,50]);
title(['Neighborhood Size: (' num2str(delta_theta) ',' num2str(delta_phi) ')']);

%% ------------------------------------------------------------------------
% E. Realize Delta maximum INR based on neighborhood size and nominal INR.
% -------------------------------------------------------------------------
delta_theta_phi = 2;
INR_dB = 0;
[a,b] = get_gamma_params_max(delta_theta_phi,INR_dB);

% draw realizations
r = gamrnd(a,b,1000,1); % Delta maximum INR (in dB; see [1] for definition)

% plot CDF
[f,x] = ecdf(r);
figure(5);
plot(x,f);
grid on;
grid minor;
xlabel('Delta Maximum INR (dB)');
ylabel('Cumulative Probability');
xlim([0,60]);
title(['Neighborhood Size: (' num2str(delta_theta) ',' num2str(delta_phi) '), Nominal INR: ' num2str(INR_dB) ' dB']);

%% ------------------------------------------------------------------------
% F. Realize INR range, minimum INR, maximum INR based on neighborhood size (on-grid).
% -------------------------------------------------------------------------
% neighborhood sizes
delta_theta_list = [0 0 1 1:1:5];
delta_phi_list = [0 1 0 1:1:5];

% number of realizations
N = 1e5;

% for each neighborhood size
for idx_delta = 1:length(delta_theta_list)
    % set neighborhood size
    delta_theta = delta_theta_list(idx_delta);
    delta_phi = delta_phi_list(idx_delta);
    
    % label for plotting
    ss = ['(' num2str(delta_theta) ',' num2str(delta_phi) ')'];
    
    % INR range
    if ~(delta_theta == 0 && delta_phi == 0)
        [a,b] = get_gamma_params_rng(delta_theta,delta_phi);
        r = gamrnd(a,b,N,1);
        [f,x] = ecdf(r);
        figure(6);
        plot(x,f,'DisplayName',ss);
        hold on;
    end
    
    % Minimum INR
    [m,s] = get_normal_params_min(delta_theta,delta_phi);
    r = normrnd(m,sqrt(s),N,1);
    [f,x] = ecdf(r);
    figure(7);
    plot(x,f,'DisplayName',ss);
    hold on;
    
    % Maximum INR
    [m,s] = get_normal_params_max(delta_theta,delta_phi);
    r = normrnd(m,sqrt(s),N,1);
    [f,x] = ecdf(r);
    figure(8);
    plot(x,f,'DisplayName',ss);
    hold on;
end

figure(6);
hold off;
grid on;
grid minor;
xlabel('INR Range (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 12a');
legend('Location','Southeast');
xlim([0,70]);

figure(7);
hold off;
grid on;
grid minor;
xlabel('Minimum INR (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 14a');
legend('Location','Northwest');
xlim([-40,40]);

figure(8);
hold off;
grid on;
grid minor;
xlabel('Maximum INR (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 16a');
legend('Location','Northwest');
xlim([0,50]);

%% ------------------------------------------------------------------------
% G. Realize minimum INR and maximum INR based on neighborhood size and nominal INR (on-grid).
% -------------------------------------------------------------------------
% set neighborhood size
delta_theta = 2;
delta_phi = 2;

% nominal INRs to evaluate
INR_dB_list = [-20:10:20];

% for each nominal INR
for idx_inr = 1:length(INR_dB_list)
    % set nominal INR
    INR_dB = INR_dB_list(idx_inr);
    
    % label for plotting
    ss = ['INR = ' num2str(INR_dB) ' dB'];
       
    % Delta minimum INR
    [a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);
    r = gamrnd(a,b,N,1);
    [f,x] = ecdf(r);
    figure(9);
    plot(x,f,'DisplayName',ss);
    hold on;
    
    % Delta maximum INR
    [a,b] = get_gamma_params_max(delta_theta_phi,INR_dB);
    r = gamrnd(a,b,N,1);
    [f,x] = ecdf(r);
    figure(10);
    plot(x,f,'DisplayName',ss);
    hold on;
end

figure(9);
hold off;
grid on;
grid minor;
xlabel('Delta Minimum INR (dB)');
ylabel('Cumulative Probability');
legend('Location','Northwest');
xlim([0,40]);
title('Compare to Fig. 15');

figure(10);
hold off;
grid on;
grid minor;
xlabel('Delta Maximum INR (dB)');
ylabel('Cumulative Probability');
legend('Location','Southeast');
xlim([0,60]);
title('Compare to Fig. 17');

%% ------------------------------------------------------------------------
% H. Realize INR range, minimum INR, maximum INR based on neighborhood size (off-grid).
% -------------------------------------------------------------------------
% off-grid neighborhood sizes to evaluate (these use interpolated statistical parameters)
delta_theta_list = [1 1.5 2 2.5 3];
delta_phi_list = [1 1.5 2 2.5 3];

% number of realizations
N = 1e5;

% for each neighborhood size (shifting tolerance)
for idx_delta = 1:length(delta_theta_list)
    % set neighborhood size
    delta_theta = delta_theta_list(idx_delta);
    delta_phi = delta_phi_list(idx_delta);
    
    % label for plotting
    ss = ['(' num2str(delta_theta) ',' num2str(delta_phi) ')'];
    
    % INR range
    if ~(delta_theta == 0 && delta_phi == 0)
        [a,b] = get_gamma_params_rng(delta_theta,delta_phi);
        r = gamrnd(a,b,N,1);
        [f,x] = ecdf(r);
        figure(11);
        plot(x,f,'DisplayName',ss);
        hold on;
    end
    
    % Minimum INR
    [m,s] = get_normal_params_min(delta_theta,delta_phi);
    r = normrnd(m,sqrt(s),N,1);
    [f,x] = ecdf(r);
    figure(12);
    plot(x,f,'DisplayName',ss);
    hold on;
    
    % Maximum INR
    [m,s] = get_normal_params_max(delta_theta,delta_phi);
    r = normrnd(m,sqrt(s),N,1);
    [f,x] = ecdf(r);
    figure(13);
    plot(x,f,'DisplayName',ss);
    hold on;
end

figure(11);
hold off;
grid on;
grid minor;
xlabel('INR Range (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 12a');
legend('Location','Southeast');
xlim([0,70]);

figure(12);
hold off;
grid on;
grid minor;
xlabel('Minimum INR (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 14a');
legend('Location','Northwest');
xlim([-40,40]);

figure(13);
hold off;
grid on;
grid minor;
xlabel('Maximum INR (dB)');
ylabel('Cumulative Probability');
title('Compare to Fig. 16a');
legend('Location','Northwest');
xlim([0,50]);

%% ------------------------------------------------------------------------
% I. Realize minimum and maximum INR using two-step method (see (27) in [1]).
%    1. First draw nominal INR from unshifted (global) distribution.
%    2. Then, draw shift using Gamma distributions.
% -------------------------------------------------------------------------
% realize nominal INR from unshifted distribution
N = 100000; % number of realizations
[m,s] = get_normal_params_min(0,0);
INR_dB = normrnd(m,sqrt(s),N,1); % nominal INR (in dB)

% plot CDF of nominal INR values
ss = ['(' num2str(0) ',' num2str(0) ')'];
[f,x] = ecdf(INR_dB);
figure(14);
plot(x,f,'DisplayName',ss);
hold on;
figure(15);
plot(x,f,'DisplayName',ss);
hold on;

% plot min, max INR distributions if allowed to shift
delta_theta_phi_list = [1:5];
for idx_delta = 1:length(delta_theta_phi_list)
    % set neighborhood size
    delta_theta_phi = delta_theta_phi_list(idx_delta);
    
    % label for plotting
    ss = ['(' num2str(delta_theta_phi) ',' num2str(delta_theta_phi) ')'];
    
    % get delta minimum INR when allowed to shift
    [a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);
    Delta_INR_min_dB = gamrnd(a,b); % in dB
    
    % minimum INR after shifting from nominal values
    INR_min_dB = INR_dB - Delta_INR_min_dB(:); % in dB
    
    % plot CDF
    [f,x] = ecdf(INR_min_dB);
    figure(14);
    plot(x,f,'DisplayName',ss);
    hold on;
    
    % get delta maximum INR when allowed to shift
    [a,b] = get_gamma_params_max(delta_theta_phi,INR_dB);
    Delta_INR_max_dB = gamrnd(a,b); % in DB
    
    % maximum INR after shifting from nominal values
    INR_max_dB = INR_dB + Delta_INR_max_dB(:); % in dB
    
    % plot CDF
    [f,x] = ecdf(INR_max_dB);
    figure(15);
    plot(x,f,'DisplayName',ss);
    hold on;
end

figure(14);
hold off;
xlabel('Minimum INR (dB)');
ylabel('Cumulative Probability');
grid on;
grid minor;
legend('Location','Northwest');
xlim([-40,40]);
title('Compare to Fig. 14a');

figure(15);
hold off;
xlabel('Maximum INR (dB)');
ylabel('Cumulative Probability');
grid on;
grid minor;
legend('Location','Northwest');
xlim([0,50]);
title('Compare to Fig. 16a');