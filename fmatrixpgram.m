%-------------------------------------------------------------------------
% This function will take your pre-processed signal and return the
% frequency matrix that will be used to find the least cost path. 
%
% Inputs: 
% y - preprocessed signal
% fs - corresponding fs for preprocessed signal
% peakno - the number of peaks you wish to evaluate in fmatrix
% framelength - the length of each frame to be eevaluated
% overlap  the overlap between consectuive frames
% nfft - number of fourier transform points 
%-------------------------------------------------------------------------

function fmatrix = fmatrixpgram(y,fs, peakno,framelength, overlap, nfft)

% Caluclate timeshift, number of frames, and initialise window and fmatrix.
timeshift = framelength - overlap;
noframe = floor((length(y)-framelength)/timeshift);
% NOTE I AM CURRENTLY USING A RECTANGULAR MATRIX. IS THAT GOOD? BAD?
window = zeros(0,0);
fmatrix = zeros(peakno, noframe+1);

% Take the periodogram of each frame & the indexes of each frame
for i = 0:noframe
    pxx = periodogram(y(i*timeshift+1:i*timeshift+framelength), window, nfft);
    [peaks, peakindex] = sort(pxx, 'descend');
    fmatrix(:,i+1) = peakindex(1:peakno);
end

%translate the inddexes into the frequencies 
%%%%%%%%%%%%%%%%%%%%%%%%%%
%AM I OFF BY ONE ON THIS?%
%%%%%%%%%%%%%%%%%%%%%%%%%%
fmatrix = (fmatrix/(length(pxx)))*(fs/2); 
 
end

