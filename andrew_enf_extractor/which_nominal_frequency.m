    function fnom = which_nominal_frequency(data,fs)
    nfft = length(data);
    freqaxis = (fs/2)*linspace(0,1,(nfft/2));

    x = abs(fft(data, nfft));
    x = x(1:(nfft/2));
    %plot(freqaxis,x);
    
    i = 1;
    dist_50 = 20;
    dist_60 = 20;
    dist_offset = 3;
    [peak,sample] = max(x);
    while(60*i < 500)
        temp_50 = abs(freqaxis(sample) - 50*i);
        temp_60 = abs(freqaxis(sample) - 60*i);
        
        if temp_50 < dist_50
            dist_50 = temp_50;
        end
        
        if temp_60 < dist_60
            dist_60 = temp_60;
        end

        %plot(x(freqaxis>50-offset &freqaxis<60+offset));
        %hold on;
        i = i+1;
    end
            if dist_50 < dist_60
               fnom = 50;
            elseif dist_60 < dist_50
               fnom = 60;
            else
               fnom = 0;
            end
            
            if dist_60 > dist_offset & dist_50 > dist_offset
               fnom = 50;
            end
end