%Building on the foundations laid by David Vang, to make a more versatile
%ENF extractor, accepting inputs to alter the ENF extraction parameters.

%**************************************************************************
% Inputs: [y, fs, framelength, overlap, nfft]
% Outputs: [enf, time]
% countingn variables= i,j,l,m,n
%**************************************************************************
function [enf, time] = extractenf(y, fs, framelength, overlap, nfft)

if isempty(nfft)
    nfft = max(256,2^(ceil(log2(length(y)))));
end

%frequency axis for the FFT
freqaxis = (fs/2)*linspace(0,1,(nfft/2));

%fourier transform of the signal and half since symmetrical about fs/2:
x = abs(fft(y, nfft));
x = x(1:(nfft/2));x

%finding the nominal frequency.
ncompare the signal strength at 50 and 60Hz
s_50 = sum(x(freqaxis>45 & freqaxis<55));
s_60 = sum(x(freqaxis>55 & freqaxis<65));
if s_50 > s_60
    fnom = 50;
else
    fnom = 60;
end
    

%Generate the spectrogram of the signal.
%s is the STFT matrix (time inc. across columns, frequency inc. down rows)
%f is the frequencies vector. Resolution = (nfft/2)+1
%t is the time instants - midpoint of each frame.
[s,f,time] = spectrogram(y, framelength, overlap, nfft, fs);

%Establishing our constants for weighted energy method.
L1 = round(((fnom-0.5)*nfft)/fs)+1;
L2 = round(((fnom+0.5)*nfft)/fs)+1;

%calculating weighted energy.
for j=1:length(f)
    if (f(j) > fnom-0.5 && f(j) < fnom+0.5)
        for n=1:length(s(1,:))
        X1=0;
        X2=0;
            for i=L1:L2
                X1=f(i)*abs(s(i,n))+X1;
                X2=abs(s(i,n))+X2;
            end
            enf(n)=X1/X2; % our ENF Vector 
        end
    end
end
% plot(time,enf);
% xlabel('Time(sec)');
% ylabel('Frequency(Hz)');