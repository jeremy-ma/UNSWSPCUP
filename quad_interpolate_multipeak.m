function freqmat = quad_interpolate_multipeak(ynew, fsnew, framelen, overlap, nfft, nopeaks)

% NFFT points is 4*length of framelen described in the paper.

frame_hop = framelen - overlap;
number_frames = floor((length(ynew)-framelen)/frame_hop);
freqmat = zeros(number_frames+1, nopeaks);
for i = 0:number_frames
    %Get the frame of concern
    frames_temp = ynew(i*frame_hop+1:i*frame_hop+framelen);
    %Take the fft of the frame of concern
    fft_signal = abs(fft(frames_temp, nfft));
    fft_signal = fft_signal(1:(length(fft_signal))/2);
    %Sort it to determine the index of the peak
    [peak, peakindex] = sort(fft_signal, 'descend');
    potential_peaks = peakindex(1:nopeaks);
    
    for j = 1:nopeaks
        polyfit_y = [fft_signal(potential_peaks(j)-1), fft_signal(potential_peaks(j)), fft_signal(potential_peaks(j)+1)];
        p = polyfit([1,2,3], polyfit_y,2);
        %getting the coefficients of the polynomial.
        deri_poly = polyder(p);
        quadratic_maxima = roots(deri_poly);
        frame_freq_index = potential_peaks(j)-1+quadratic_maxima;
        freqmat(i+1,j) =  (frame_freq_index/nfft)*fsnew;
        while freqmat(i+1,j) >=65
            freqmat(i+1,j) = freqmat(i+1,j)/2;
        end
    end
end


end

