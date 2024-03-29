# About

This repository contains code related to the following paper on measurements of self-interference at 28 GHz using phased arrays.

[1] I. P. Roberts, A. Chopra, T. Novlan, S. Vishwanath, and J. G. Andrews, "Beamformed Self-Interference Measurements at 28 GHz: Spatial Insights and Angular Spread," _IEEE Trans. Wireless Commun._, Nov. 2022.

Using the code in this repo, which is based on measurements and statistical characterizations in [1], users can:
 - draw realizations of mmWave self-interference levels (INR values) in full-duplex mmWave systems;
 - conduct statistical analyses of full-duplex mmWave communication systems;
 - develop methods to mitigate self-interference in full-duplex mmWave communication systems;
 - evaluate solutions for full-duplex mmWave communication systems.

This work is based on nearly 6.5 million measurements of self-interference taken at 28 GHz in an anechoic chamber using two colocated 256-element phased arrays mounted on separate sides of an equilateral platform. Please see [1] for details.

If you use this code or our paper in your work, please cite [1] with the following BibTeX.

```
@ARTICLE{roberts_beamformed_si_measurements_2022,
    author={I. P. Roberts and A. Chopra and T. Novlan and S. Vishwanath and J. G. Andrews},
    journal={IEEE Trans.~Wireless~Commun.},
    title={Beamformed Self-Interference Measurements at 28 {GHz}: Spatial Insights and Angular Spread}, 
    year=2022,
    month=jun,
    note={(early access)}
}
```

Related work can be found at https://ianproberts.com.

# Contents

This repo contains the following MATLAB code:
 - a main script illustrating example usage
 - five `get` functions, which return statistical parameters based on some inputs
 - five `.mat` files that contain the tabulated fitted parameters in [1]

# Example Usage

The measurements and statistical characterization in [1] are particularly useful for drawing realizations of self-interference levels that a full-duplex mmWave platform may incur when transmitting while receiving in-band. We use interference-to-noise ratio (INR) to describe the level of self-interference experienced by such a system. When INR < 0 dB, the system is noise-limited, and when INR > 0 dB, it is self-interference-limited.

To draw a realization of mmWave self-interference (i.e., of INR) for a random transmit beam and random receive beam, one can execute the following in MATLAB using our code.

```
[m,s] = get_normal_params_min(0,0) % mean and variance
INR_dB = normrnd(m,sqrt(s)) % INR in dB
```

The first line fetches a mean `m` and variance `s`, which have been fitted from the measured INR distribution (see Fig. 5 in [1]).

The second line draws a realization of INR (in dB) from a normal distribution with mean `m` and standard deviation `sqrt(s)`.

## Slightly Shifting Beams to Significantly Reduce Self-Interference

One key result from [1] is that INR can be greatly reduced by slightly shifting the steering direction of transmit and receive beams. We have modeled this statistically in [1] in two ways. 

### Method 1

The first is by modeling the minimum INR distribution (after shifting at most by some amount) as a log-normal distribution. This can be realized in MATLAB using our code as follows.

```
% set neighborhood size (maximum shifting tolerance)
delta_theta = 2; % shifting tolerance in azimuth (degrees)
delta_phi = 2; % shifting tolerance in elevation (degrees)

% fetch distribution parameters based on this shifting tolerance
[m,s] = get_normal_params_min(delta_theta,delta_phi); % mean, variance

% draw 1,000 realizations of minimum INR (in dB) using a normal distribution
min_INR_dB = normrnd(m,sqrt(s),1000,1); % minimum INR (in dB)
```

The following is taken from the included main script, which illustrates the reduction in INR (distributional shift) when transmit and receive beams are allowed to shift their steering directions by at most a few degrees. Each line is a different shifting tolerance (azimuth tolerance, elevation tolerance) in degrees, with (0,0) being the nominal INR distribution without shifting beams.

<p align="center">
  <img src="https://user-images.githubusercontent.com/52005199/165019115-dd67b7a1-94cb-4fcc-a501-07d7d1fd4525.png">
</p>

### Method 2

The second method to realizing minimum INR is based on the Gamma distribution. We found that the reduction in INR seen by a particular beam pair depends on the neighborhood size (shifting tolerance) as well as the INR inherently seen by that beam pair (i.e., the nominal INR of that beam pair). With this method, the shifting tolerance in azimuth and elevation must be equal when using our provided `get` functions.

```
% set neighborhood size (maximum shifting tolerance)
delta_theta_phi = 2; % shifting tolerance in azimuth and elevation (degrees)

% nominal INR
INR_dB = 0; % in dB

% get Gamma distribution parameters
[a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);

% realize INR reduction (Delta INR min), see (24) in [1] for details
Delta_INR_min_dB = gamrnd(a,b); % in dB

% minimum INR after shifting beams by at most 2 degrees in azimuth and elevation
INR_min_dB = INR_dB - Delta_INR_min_dB; % in dB
```

Realizing maximum INR when shifting beams can be executed analogously.

### Method 2B: Two-Stage Approach

In the previous code block, we manually set the nominal INR using

```
INR_dB = 0;
```

For what is perhaps more authentic, users can realize the nominal INR based on the global (unshifted) distribution as before using the following.

```
[m,s] = get_normal_params_min(0,0) % mean and variance of unshifted INR distribution
INR_dB = normrnd(m,sqrt(s)) % INR in dB
```

Then, users can realize the reduction enjoyed by a beam pair with this realized nominal INR `INR_dB` using

```
% set neighborhood size (maximum shifting tolerance)
delta_theta_phi = 2; % shifting tolerance in azimuth and elevation (degrees)

% get Gamma distribution parameters
[a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);

% realize INR reduction (Delta INR min), see (24) in [1] for details
Delta_INR_min_dB = gamrnd(a,b); % in dB

% minimum INR after shifting beams by at most 2 degrees in azimuth and elevation
INR_min_dB = INR_dB - Delta_INR_min_dB; % in dB
```

## Interpolating Between Tabulated Fitted Parameters

In [1], we provided tables containing fitted parameters for particular neighborhood sizes and nominal INR levels.

Users wishing to draw realizations for neighborhood sizes (and/or nominal INR levels) not tabulated explicitly, can use our code to fetch interpolated statistical parameters.

### Interpolating Between Neighborhood Sizes

We provide the following to illustrate how to fetch parameters for an off-grid neighborhood size of (1.5,1.5) degrees, which falls between our set of tabulated neighborhoods.

```
% set neighborhood size (maximum shifting tolerance)
delta_theta = 1.5; % shifting tolerance in azimuth (degrees) (off-grid)
delta_phi = 1.5; % shifting tolerance in elevation (degrees) (off-grid)

% fetch distribution parameters based on this shifting tolerance (interpolated)
[m,s] = get_normal_params_min(delta_theta,delta_phi); % mean, variance

% draw 1,000 realizations of minimum INR (in dB) using a normal distribution
min_INR_dB = normrnd(m,sqrt(s),1000,1); % minimum INR (in dB)
```

### Interpolating Between Nominal INR Values

This interpolating can also be done across nominal INR values when fetching Gamma distribution parameters.

```
% set neighborhood size (maximum shifting tolerance)
delta_theta_phi = 2; % shifting tolerance in azimuth and elevation (degrees)

% nominal INR (off-grid)
INR_dB = 5; % in dB

% get Gamma distribution parameters (interpolated)
[a,b] = get_gamma_params_min(delta_theta_phi,INR_dB);

% realize INR reduction (Delta INR min), see (24) in [1] for details
Delta_INR_min_dB = gamrnd(a,b); % in dB

% minimum INR after shifting beams by at most 2 degrees in azimuth and elevation
INR_min_dB = INR_dB - Delta_INR_min_dB; % in dB
```

# .mat Files

The `mat/` folder contains five `.mat` files corresponding to the five tables in our paper, each of which contains a lookup table (matrix) of fitted parameters. 

For instance, `params_normal_min.mat` corresponds to Table II in our paper and contains the following variables:
- `lut_mu_min` - a matrix where the `(i,j)`-th entry is the fitted mean of the `j`-th azimuthal neighborhood and `i`-th elevational neighborhood
- `lut_var_min` - a matrix where the `(i,j)`-th entry is the fitted variance of the `j`-th azimuthal neighborhood and `i`-th elevational neighborhood
- `delta_az_list` - the azimuthal neighborhood size of each row in `lut_mu_min` and `lut_var_min`
- `delta_el_list` - the elevational neighborhood size of each row in `lut_mu_min` and `lut_var_min`

# Questions and Feedback

Feel free to reach out to the corresponding author of [1] with any questions or feedback.

# Acknowledgments

This work has been supported by the National Science Foundation Graduate Research Fellowship Program (Grant No. DGE-1610403). Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation.
