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
fmatrix = zeros(2*peakno, noframe+1);

% Take the periodogram of each frame & the indexes of each frame
pxx = periodogram(y(1:framelength), window, nfft);
fiflowind = floor((2*48*(length(pxx)-1))/fs);
fifhighind = ceil((2*52*(length(pxx)-1))/fs);
sixlowind = floor((2*58*(length(pxx)-1))/fs);
sixhighind = ceil((2*62*(length(pxx)-1))/fs);
[peaksfif, peakindexfif] = sort(pxx(fiflowind:fifhighind), 'descend');
[peakssix, peakindexsix] = sort(pxx(sixlowind:sixhighind), 'descend');
fmatrix(1:peakno,1) = peakindexfif(1:peakno)+fiflowind-1;
fmatrix(peakno+1:2*peakno, 1) = peakindexsix(1:peakno) + sixlowind-1;

for i = 1:noframe
    pxx = periodogram(y(i*timeshift+1:i*timeshift+framelength), window, nfft);
    
    [peaksfif, peakindexfif] = sort(pxx(fiflowind:fifhighind), 'descend');
    [peakssix, peakindexsix] = sort(pxx(sixlowind:sixhighind), 'descend');
    fmatrix(1:peakno/2,i+1) = peakindexfif(1:peakno/2)+fiflowind-1;
    fmatrix((peakno/2)+1:peakno,i+1) = peakindexsix(1:peakno/2) + sixlowind-1;
end

%translate the inddexes into the frequencies 
%%%%%%%%%%%%%%%%%%%%%%%%%%
%AM I OFF BY ONE ON THIS?%
%%%%%%%%%%%%%%%%%%%%%%%%%%
fmatrix = (fmatrix/(length(pxx)))*(fs/2); 
 
end

