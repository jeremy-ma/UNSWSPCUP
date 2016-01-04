


data = sin(1:1000)';
M = length(data);
K=2^11;
omegas = (2*pi / K) * (0:(K-1));
A = exp(omegas'*1j*(0:(M-1)))';

%initialise initial estimate
P = diag(abs(fft(data,K)).^2);

R = A * P * A' + var(data) * eye(M);
alphas = zeros(K,1);
for i=1:1
    for k=1:(K)
        alphas(k) = ( A(:,k)' * inv(R) * data) / ( A(:,k)'*inv(R)*A(:,k));
    end
    P = diag(abs(alphas).^2);
    R = A * P * A' + var(data) * eye(M);
end



