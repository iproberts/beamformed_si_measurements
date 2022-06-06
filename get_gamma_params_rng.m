function [a,b] = get_gamma_params_rng(delta_theta,delta_phi)
% GET_GAMMA_PARAMS_RNG Returns the Gamma distribution parameters for INR
% range based on some spatial neighborhood (delta_theta,delta_phi).
%
% Usage:
%  [a,b] = get_gamma_params_rng(delta_theta,delta_phi)
%
% Args:
%  delta_theta: azimuthal neighborhood size (in degrees)
%  delta_phi: elevational neighborhood size (in degrees)
%
% Returns:
%  a: alpha parameter of the Gamma distribution
%  b: beta parameter of the Gamma distribution
%
% Example 1: On-grid (measured).
%  [a,b] = get_gamma_params_rng(2,2)
% 
% Example 2: Off-grid (interpolated).
%  [a,b] = get_gamma_params_rng(1.5,1.5);
%
% Reference: Table 1 in [1].
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

 
A = [0.000 , 2.741 , 4.416 , 6.726 , 9.496 , 12.505;
     2.592 , 4.522 , 6.903 , 10.901 , 16.039 , 21.691;
     4.038 , 6.572 , 10.688 , 17.567 , 25.955 , 34.666;
     5.801 , 9.635 , 16.314 , 26.672 , 38.058 , 48.768;
     7.978 , 13.913 , 23.805 , 37.321 , 50.516 , 61.796;
     10.388 , 18.853 , 31.672 , 47.237 , 61.173 , 72.498;];

B = [0.000 , 3.401 , 3.641 , 3.146 , 2.620 , 2.219;
     3.188 , 4.098 , 3.815 , 2.940 , 2.247 , 1.797;
     3.479 , 3.845 , 3.109 , 2.205 , 1.636 , 1.304;
     3.217 , 3.165 , 2.345 , 1.628 , 1.232 , 1.014;
     2.806 , 2.486 , 1.768 , 1.258 , 0.993 , 0.852;
     2.439 , 2.001 , 1.420 , 1.051 , 0.862 , 0.760;];

a = interp2(dth,dph,A,delta_theta,delta_phi);
b = interp2(dth,dph,B,delta_theta,delta_phi);

if any(a == 0)
    warning('Encountered an alpha parameter of zero.');
end

if any(b == 0)
    warning('Encountered a beta parameter of zero.');
end

if nargout < 2
    a = [a(:),b(:)];
end

end