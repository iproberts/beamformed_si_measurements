# About

This repository contains code related to the following paper on measurements of self-interference at 28 GHz using phased arrays.

[1] I. P. Roberts, et al., "Beamformed Beamformed Self-Interference Measurements at 28 GHz: Spatial Insights and Angular Spread," IEEE Trans. Wireless Commun.

Using the code in this repo, which is based on the statistical characterization in [1], users can:
 - draw realizations of mmWave self-interference levels (INR values) in full-duplex mmWave systems
 - conduct statistical analyses of full-duplex mmWave communication systems
 - develop solutions to mitigate self-interference in full-duplex mmWave communication systems
 - evaluate solutions for full-duplex mmWave communication systems

These measurements of self-interference were taken at 28 GHz in an anechoic chamber using two colocated 256-element phased arrays, mounted on two sides of an equilateral platform. Please see [1] for details.

# Contents

This repo contains the following MATLAB code:
 - a main script illustrating example usage
 - five `get` functions, which return statistical parameters based on some inputs
 - five `.mat` files that contain the tabulated fitted parameters in [1]

# Example Usage

The measurements and statistical characterization in [1] are particularly useful for drawing realizations of self-interference levels that a full-duplex mmWave platform may incur when transmitting while receiving in-band. We use interference-to-noise ratio (INR) to describe the level of self-interference experienced by such a system. When INR < 0 dB, the system is noise-limited, and when INR > 0 dB, it is self-interference-limited.
