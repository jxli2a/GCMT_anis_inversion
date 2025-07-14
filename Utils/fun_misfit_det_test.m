function fmin = fun_misfit_det_test(Ct, mts)
d = Ct\mts;
d_det = abs(8.*d(1,:).*d(2,:).*d(3,:)+(-2).*d(1,:).*d(4,:).^2+(-2).*d(2,:).* ... 
    d(5,:).^2+2.*d(4,:).*d(5,:).*d(6,:)+(-2).*d(3,:).*d(6,:).^2);
nevt = size(mts,2);
d_1 = d.*repmat([2,2,2,sqrt(2),sqrt(2),sqrt(2)]',1,nevt);
d_norm = sqrt(sum(d_1.*d_1)/2);
fmin = d_det./d_norm;
end