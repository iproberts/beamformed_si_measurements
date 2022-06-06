function [a,b] = get_gamma_params_min(delta_theta_phi,INR_dB)
% GET_GAMMA_PARAMS_MIN Returns the Gamma distribution parameters for min 
% INR over some spatial neighborhood and a nominal INR.
%
% Usage:
%  [a,b] = get_gamma_params_min(delta_theta_phi,INR_dB)
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
%  [a,b] = get_gamma_params_min(2,0)
% 
% Example 2: Off-grid (interpolated).
%  [a,b] = get_gamma_params_min(2,-5)
%
% Example 3: Off-grid (interpolated).
%  [a,b] = get_gamma_params_min(2.5,0)
%
% Example 4: Off-grid (interpolated).
%  [a,b] = get_gamma_params_min(2.5,-5)
%
% Reference: Table 3 in [1].
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

A = [0.194 , 0.210 , 0.894 , 3.663 , 3.264 , 3.221 , 4.091;
     0.182 , 0.411 , 3.056 , 10.278 , 8.674 , 5.263 , 4.147;
     0.205 , 0.871 , 6.490 , 17.375 , 19.941 , 12.182 , 7.959;
     0.257 , 1.859 , 10.403 , 24.366 , 31.115 , 22.776 , 20.632;
     0.393 , 2.977 , 15.205 , 31.795 , 40.473 , 30.882 , 36.145;];

B = [1.342 , 11.374 , 10.272 , 4.050 , 3.910 , 2.801 , 1.470;
     4.914 , 13.926 , 4.828 , 2.209 , 2.926 , 4.183 , 4.033;
     9.311 , 10.195 , 2.861 , 1.577 , 1.659 , 2.737 , 3.793;
     12.404 , 6.274 , 2.066 , 1.262 , 1.215 , 1.772 , 1.941;
     11.989 , 4.664 , 1.570 , 1.047 , 1.014 , 1.452 , 1.271;];

a = interp2(dinr,dthph,A,INR_dB,delta_theta_phi);
b = interp2(dinr,dthph,B,INR_dB,delta_theta_phi);

if any(a == 0)
    warning('Encountered an alpha parameter of zero.');
end

if any(b == 0)
    warning('Encountered a beta parameter of zero.');
end

end