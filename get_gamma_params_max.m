function [a,b] = get_gamma_params_max(delta_theta_phi,INR_dB)
% GET_GAMMA_PARAMS_MAX Returns the Gamma distribution parameters for max 
% INR over some spatial neighborhood and a nominal INR.
%
% Usage:
%  [a,b] = get_gamma_params_max(delta_theta_phi,INR_dB)
%
% Args:
%  delta_theta_phi: azimuthal/elevational neighborhood size (in degrees)
%  INR_dB: nominal INR (in dB)
%
% Returns:
%  a: alpha parameter of the Gamma distribution
%  b: beta parameter of the Gamma distribution
%
% Example 1: On-grid (measured).
%  [a,b] = get_gamma_params_max(2,0)
% 
% Example 2: Off-grid (interpolated).
%  [a,b] = get_gamma_params_max(2,-5)
%
% Example 3: Off-grid (interpolated).
%  [a,b] = get_gamma_params_max(2.5,0)
%
% Example 4: Off-grid (interpolated).
%  [a,b] = get_gamma_params_max(2.5,-5)
%
% Reference: Table 5 in [1].
%  [1] I.P. Roberts et al., "Beamformed Self-Interference Measurements at
%  28 GHz: Spatial Insights and Angular Spread," IEEE Trans. Wireless
%  Commun.
% 
% https://github.com/iproberts/beamformed_si_measurements

if any(delta_theta_phi < 1)
    error('Delta theta/phi cannot be less than 1 degrees.');
end

if any(delta_theta_phi > 5)
    error('Delta theta/phi cannot be more than 5 degrees.');
end

if any(INR_dB < -20)
    warning('INR cannot be less than -20 dB. Bounding.');
    INR_dB = max(INR_dB,-20);
end

if any(INR_dB > 40)
    warning('INR cannot be more than 40 dB. Bounding.');
    INR_dB = min(INR_dB,40);
end

thph = [1:1:5];
INR = [-20:10:40];

dthph = repmat(thph',1,length(INR));
dinr = repmat(INR,length(thph),1);

A = [97.358 , 53.693 , 22.220 , 8.273 , 3.939 , 3.650 , 3.731;
     125.299 , 74.377 , 35.074 , 14.257 , 6.183 , 4.826 , 4.758;
     132.689 , 83.025 , 42.627 , 18.352 , 7.762 , 5.402 , 5.370;
     143.233 , 92.332 , 49.460 , 22.606 , 9.534 , 5.960 , 6.102;
     160.402 , 107.856 , 58.948 , 28.376 , 12.125 , 6.526 , 6.935;];

B = [0.390 , 0.527 , 0.832 , 1.228 , 1.445 , 1.087 , 0.721;
     0.350 , 0.455 , 0.683 , 1.043 , 1.443 , 1.276 , 0.844; 
     0.355 , 0.448 , 0.638 , 0.974 , 1.439 , 1.410 , 0.878;
     0.346 , 0.429 , 0.598 , 0.891 , 1.355 , 1.460 , 0.844;
     0.321 , 0.385 , 0.535 , 0.777 , 1.192 , 1.474 , 0.788;];

a = interp2(dinr,dthph,A,INR_dB,delta_theta_phi);
b = interp2(dinr,dthph,B,INR_dB,delta_theta_phi);

if any(a == 0)
    warning('Encountered an alpha parameter of zero.');
end

if any(b == 0)
    warning('Encountered a beta parameter of zero.');
end

end