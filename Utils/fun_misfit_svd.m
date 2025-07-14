function [dmin,fmin,d_scalar] = fun_misfit_svd(U,S,V,mts)
yy = U'*mts;
nevt = size(mts,2);
S_matrix = repmat([1/S(1,1),1/S(2,2),1/S(3,3),1/S(4,4),1/S(5,5),0]',1,nevt);
y = yy.*S_matrix;
Sk = V*y; V6 = V(:,6);
c2 = sum(V6(1:3));
d2 = sum(Sk(1:3,:));
ymin = -d2./c2; 
d = Sk+V6*ymin;


f_det = 8.*d(1,:).*d(2,:).*d(3,:)+(-2).*d(1,:).*d(4,:).^2+(-2).*d(2,:).* ... 
    d(5,:).^2+2.*d(4,:).*d(5,:).*d(6,:)+(-2).*d(3,:).*d(6,:).^2;
fmin = abs(f_det);

d_1 = d.*repmat([2,2,2,sqrt(2),sqrt(2),sqrt(2)]',1,nevt);
d_scalar = sqrt(sum(d_1.*d_1/2));
dmin = d./repmat(d_scalar,6,1);
end