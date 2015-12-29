[ynew, fsnew] = bandpass_process_nharmonics(y,fs,60,0.1,4,0.5);
fmat = quad_interpolate_multipeak(ynew, fsnew, 10000, 9000, 40000, 10);
path = leastcostENF(fmat');
figure;
plot(path);
title('QuadWLS');
xlabel('Time axis');
ylabel('frequency');
