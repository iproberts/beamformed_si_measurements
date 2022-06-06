function [m,s] = get_normal_params_max(delta_theta,delta_phi)
% GET_NORMAL_PARAMS_MAX Returns the normal distribution parameters for max 
% INR over some spatial neighborhood (delta_theta,delta_phi).
%
% Usage:
%  [m,s] = get_normal_params_max(delta_theta,delta_phi)
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
%  [m,s] = get_normal_params_max(2,2)
% 
% Example 2: Off-grid (interpolated).
%  [m,s] = get_normal_params_max(1.5,1.5)
%
% Reference: Table 4 in [1].
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
 
M = [20.325 , 24.363 , 26.421 , 27.626 , 28.412 , 29.056;
     23.839 , 26.852 , 28.641 , 29.712 , 30.415 , 31.001;
     25.632 , 28.422 , 30.153 , 31.185 , 31.853 , 32.415;
     26.890 , 29.607 , 31.333 , 32.353 , 33.005 , 33.555;
     27.892 , 30.608 , 32.353 , 33.376 , 34.023 , 34.570;
     28.724 , 31.458 , 33.226 , 34.256 , 34.905 , 35.452;];

S = [70.693 , 44.947 , 39.023 , 36.810 , 35.643 , 34.665;
     49.626 , 39.307 , 35.371 , 33.945 , 33.264 , 32.603;
     45.345 , 37.004 , 33.267 , 31.994 , 31.509 , 30.999;
     43.385 , 35.480 , 31.574 , 30.312 , 29.935 , 29.518;
     41.948 , 33.807 , 29.510 , 28.132 , 27.788 , 27.403;
     40.611 , 32.024 , 27.272 , 25.733 , 25.362 , 24.955;];

m = interp2(dth,dph,M,delta_theta,delta_phi);
s = interp2(dth,dph,S,delta_theta,delta_phi);

if any(s <= 0)
    warning('Encountered a non-positive variance parameter.');
end

if nargout < 2
    m = [m(:),s(:)];
end

end