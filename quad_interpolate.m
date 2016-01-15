function freqvec = quad_interpolate(ynew, fsnew, framelen, overlap, nfft, nopeaks)

% NFFT points is 4*length of framelen described in the paper.

frame_hop = framelen - overlap;
number_frames = floor((length(ynew)-framelen)/frame_hop)

for i = 0:number_frames
    %Get the frame of concern
    frames_temp = ynew(i*frame_hop+1:i*frame_hop+framelen);
    %Take the fft of the frame of concern
    fft_signal = abs(fft(frames_temp, nfft));
    %Sort it to determine the index of the peak
    [peak, peakindex] = sort(fft_signal, 'descend');
    %Quadratic intrpolation on the 3 points around the peak index.
    polyfit_y = [fft_signal(peakindex(1)-1), fft_signal(peakindex(1)), fft_signal(peakindex(1)+1)];
    p = polyfit([1,2,3], polyfit_y,2);
    deri_poly = polyder(p);
    %determine the quadratically interpolated maxima
    quadratic_maxima = roots(deri_poly);
    %find the respective maximimum frequency
    frame_freq_index = peakindex(1)-1+quadratic_maxima;
    freqvec(i+1) =  (frame_freq_index/nfft)*fsnew;
    %sccale into the fundamental. 
    while freqvec(i+1) >= 65 %just a random hardcoded threshold.
        freqvec(i+1) = freqvec(i+1)/2;
    end
 
end

end

