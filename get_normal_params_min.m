function [m,s] = get_normal_params_min(delta_theta,delta_phi)
% GET_NORMAL_PARAMS_M/iN Returns the normal distribution parameters for min 
% INR over some spatial neighborhood (delta_theta,delta_phi).
%
% Usage:
%  [m,s] = get_normal_params_min(delta_theta,delta_phi)
%
% Args:
%  delta_theta: azimuthal neighborhood size (in degrees)
%  delta_phi: elevational neighborhood size (in degrees)
%
% Returns:
%  m: mean (mu) parameter of the normal distribution
%  s: variance (sigma^2) parameter of the normal distribution
%
% Example 1: On-grid (measured).
%  [m,s] = get_normal_params_min(2,2)
% 
% Example 2: Off-grid (interpolated).
%  [m,s] = get_normal_params_min(1.5,1.5)
%
% Reference: Table 2 in [1].
%  [1] I.P. Roberts et al., "Beamformed Self-Interference Measurements at
%  28 GHz: Spatial Insights and Angular Spread," IEEE Trans. Wireless
%  Commun.
% 
% https://github.com/iproberts/beamformed_si_measurements

if any(delta_theta < 0) || any(delta_phi < 0)
    error('Delta theta and Delta phi cannot be negative.');
end

th = [0:1:5];
ph = [0:1:5];

dth = repmat(th,length(ph),1);
dph = repmat(ph',1,length(th));

M = [20.325 , 15.040 , 10.343 , 6.469 , 3.534 , 1.313;
     15.576 , 8.323 , 2.304 , -2.342 , -5.624 , -7.981;
     11.582 , 3.151 , -3.073 , -7.555 , -10.612 , -12.796;
     8.229 , -0.882 , -6.926 , -11.070 , -13.873 , -15.891;
     5.502 , -3.982 , -9.736 , -13.567 , -16.163 , -18.053;
     3.389 , -6.271 , -11.762 , -15.368 , -17.825 , -19.629;];

S = [70.693 , 102.746 , 114.623 , 112.941 , 107.370 , 101.933;
     98.859 , 148.792 , 152.390 , 135.127 , 118.001 , 105.585;
     109.036 , 153.036 , 141.964 , 117.662 , 99.814 , 88.338;
     106.825 , 137.498 , 119.298 , 96.776 , 82.491 , 73.801;
     99.757 , 118.153 , 99.318 , 81.479 , 70.953 , 64.679;
     93.250 , 103.553 , 86.701 , 72.634 , 64.540 , 59.619;];
 
m = interp2(dth,dph,M,delta_theta,delta_phi);
s = interp2(dth,dph,S,delta_theta,delta_phi);

if any(s <= 0)
    warning('Encountered a non-positive variance parameter.');
end

if nargout < 2
    m = [m(:),s(:)];
end

end