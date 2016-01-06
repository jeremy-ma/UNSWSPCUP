fnom = which_nominal_frequency(y,fs);

fprintf('the nonminal is %d\n', fnom);

y1 = filter_signal(y,fs,fnom, 60, 0.1, 1, 0.5);
fprintf('y1 is complete\n');
y2 = filter_signal(y,fs,fnom, 60, 0.1, 2, 0.5);
fprintf('y2 is complete\n');
y3 = filter_signal(y,fs,fnom, 60, 0.1, 3, 0.5);
fprintf('y3 is complete\n');

fmat1 = quad_interpolate_multipeak(y1,fs,10000,9000,40000,50);
fprintf('y1 fmat complete\n');

fmat2 = quad_interpolate_multipeak(y2,fs,10000,9000,40000,50);
fprintf('y2 fmat complete\n');

fmat3 = quad_interpolate_multipeak(y3,fs,10000,9000,40000,50);
fprintf('y3 fmat complete\n');

p1 = leastcostENF(fmat1);
fprintf('leastcost1 done\n');
p2 = leastcostENF(fmat2);
fprintf('leastcost2 done\n');
p3 = leastcostENF(fmat3);
fprintf('leastcost3 done\n');

figure
subplot(1,3,1)
plot(p1);
title('1st harmonic');
subplot(1,3,2);
plot(p2);
title('2nd harmonic');
subplot(1,3,3);
plot(p3);
title('3rd harmonic');

