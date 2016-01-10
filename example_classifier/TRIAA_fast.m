%TRIAA

fs = 1000; 
n = 5;  %downsample by factor of n
fs_new = fs/n;

%trial data
f1=70;
f2=70;
t1 = 0:1e-3*n:3;
t2 = 3:1e-3*n:5;
y = [sin(2*pi*f1*t1) sin(2*pi*f2*t2)]';
% y = sin(2*pi*f1*t1)';
% figure
% plot(y)

%% 


L=length(y);
K = 4*L;
w_vec = linspace(0,2*pi*((K-1)/K),K);
R_L = eye(L);
F = exp(1i*(0:L-1)'*w_vec);

psi_n = zeros(K,1);
phi_n = zeros(K,1);
alpha_n = zeros(K,1);

for l=1:15
    R_L1 = R_L(2:end,2:end);
    r_L1 = R_L(2:end,1);
    r0 = R_L(1,1);
%     a_L1 = -R_L1\r_L1;
    a_L1 = levinson([1; R_L(2:end,1)])';
    a_L1 = a_L1(2:end);
%     if l==1
%         a_L1 = -R_L1\r_L1;
%     else
%         tmp_m = R_inv - A_L*A_L';
%         R_L1_inv = tmp_m(2:end,2:end);
%         a_L1 = -R_L1_inv*r_L1;
%     end
    
    alpha_L = r0 + r_L1'*a_L1;
    A_L = [1;a_L1]/sqrt(alpha_L);
    
    %sigma1 = 1, sigma2 = -1
    t2L = [zeros(1,L-1) 0; eye(L-1) zeros(L-1,1)] * fliplr(eye(L)) * conj(A_L);
    t2L_bar = [zeros(1,L-1) 1; eye(L-1) zeros(L-1,1)] * fliplr(eye(L)) * conj(A_L);
    R_inv = tril(toeplitz(A_L))*(toeplitz(A_L,[A_L(1);conj(flipud(A_L(2:end)))])') - tril(toeplitz(t2L))*(toeplitz(t2L_bar,[t2L_bar(1);conj(flipud(t2L_bar(2:end)))])');
    
    d_L = R_inv*y;
    
    for k=1:K
        psi_n(k) = F(:,k)'*d_L;
        phi_n(k) = F(:,k)' * R_inv * F(:,k);
        alpha_n(k) = psi_n(k)/phi_n(k);
    end
    
    tmp = dftmtx(K)' * (abs(alpha_n).^2);
    r_lL = tmp(1:L)/real(tmp(1)); % with normalize
    R_L = toeplitz(r_lL);
    
    phi_full = abs(alpha_n).^2;
    f_vec = w_vec/(2*pi)*fs_new;
    figure
    plot(f_vec,log(phi_full))
    phi = phi_full(1:end/2);
    %find max power peak
    [phi_max,max_ind] = max(phi);
    w_kmax = max_ind/(length(phi)*2);
    w_kmax_plus = (max_ind+1)/(length(phi)*2);
    
    %quadratic fit
    log_phi = log(phi);
    
    ll = [-1 0 1];
    b = log(phi(max_ind+ll));
    delta = 0.5* (b(1)-b(3))/(b(1)-2*b(2)+b(3)) * (w_kmax_plus-w_kmax);
    
    f = (w_kmax+delta)*fs_new
end
