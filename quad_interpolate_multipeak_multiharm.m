function freqmat = quad_interpolate_multipeak(y, fs, framelength, overlap, nfft, nopeaks)

% NFFT points is 4*length of framelen described in the paper.

frame_hop = framelength - overlap;
number_frames = floor((length(y)-framelength)/frame_hop);
freqmat = zeros(nopeaks, number_frames+1);
%Get the frame of concern
frames_temp_M = buffer(y,framelength,overlap,'nodelay');
%Take the fft of the frame of concern
fft_signal_M = abs(fft(frames_temp_M, nfft));
fft_signal_M = fft_signal_M(1:(size(fft_signal_M,1))/2,:);
%Sort it to determine the index of the peak
[~, peakindex_M] = sort(fft_signal_M, 1, 'descend');

for i = 0:number_frames
    fft_signal = fft_signal_M(:,i+1);
    peakindex = peakindex_M(:,i+1);
    potential_peaks = peakindex(1:nopeaks);
    polyfit_y = [fft_signal(potential_peaks-1), fft_signal(potential_peaks), fft_signal(potential_peaks+1)];
    P = polyfitM([-1,0,1], polyfit_y, 2);
    quadratic_maxima_M = - P(:,2)./(2*P(:,1)); % x=-b/2a for x-intercept
    frame_freq_index_M = potential_peaks+quadratic_maxima_M;
    freqmat(:,i+1) =  (frame_freq_index_M/nfft)*fs;
end

for n = 1:nopeaks
    for m = 1:number_frames+1
        if freqmat(n,m) < 80
            continue
        elseif freqmat(n,m) < 135
            freqmat(n,m) = freqmat(n,m)/2;
        elseif freqmat(n,m) < 190
            freqmat(n,m) = freqmat(n,m)/3;
        else 
            freqmat(n,m) = freqmat(n,m)/4;
        end
    end
end

end