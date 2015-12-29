%--------------------------------------------------------------------------
%This is the pre-processing stage for the signal
%1. Decimate to reduce computation
%2. Create the multipass filter
%3. Filter the decimated signal.
%
%Inputs:
%y - Signal (raw signal)
%fs - sampling frequency (raw sampling frequency)
%r - decimating factor (5 - could be 1 if not wanting to decimate)
%n - decimation filter order (8)
%bw_norm - normalised bandwidth around the two centre frequencies
%[50&60Hz](0.003 - 3hz bandwidth around 50 & 60)
%N - Noise filter order (20)
%Ap - Pass band Ripple (dB)
%
%Outputs:
%z - downsampled and filtered signal 
%fs_z - new sampling frequency.
%--------------------------------------------------------------------------

function [z, fs_z] = pre_process(y, fs, r, n, N, bw_norm, Ap)

%Decimate the signal
%Inbuilt decimate function includes Type1 Cheby Filter for anti-aliasing
x = decimate(y, r, n);
%Calculate the corresponding downsampled frequency
fs_z = fs/r;

%filter design
dpass = fdesign.bandpass('N,Fp1,Fp2,Ap', N, r*((50/(fs/2)) - bw_norm), r*((60/(fs/2)) + bw_norm), Ap);
dstop = fdesign.bandstop('N,Fp1,Fp2,Ap', N, r*((50/(fs/2)) + bw_norm), r*((60/(fs/2)) - bw_norm), Ap);
h1 = design(dpass);
h2 = design(dstop);
h = dfilt.cascade(h1, h2);

z = filter(h, x);
%fvtool(h);     %filter visulisation tool - uncomment this to see the
                %frequency response.
                
end





