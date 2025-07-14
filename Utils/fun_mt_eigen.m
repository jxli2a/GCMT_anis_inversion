function [V1,V2,V3,Lambda] = fun_mt_eigen(mts)
%% Usage: [V1,V2,V3,Lambda] = fun_mt_eigen(mts)
%  Produce eigenvectors and eigenvalues for moment tensors
%  Input moment tensors in voigt system
%  By Jiaxuan Li    2017-09-05

n = size(mts,2);
V1 = zeros(3,n);
V2 = zeros(3,n);
V3 = zeros(3,n);
Lambda = zeros(3,n);
tmp = mts.*repmat([1,1,1,sqrt(2),sqrt(2),sqrt(2)]',1,n);
m0 = sqrt(sum(tmp.*tmp/2));
mts = mts./repmat(m0,6,1);
% Calculate eigen values and eigen vectors for m_syn
m_syn2 = [mts(1,:);mts(6,:);mts(5,:);mts(6,:);mts(2,:);mts(4,:);mts(5,:);mts(4,:);mts(3,:)];
m_syn0 = reshape(m_syn2,[3,3,n]);
for ii = 1:n
    thismtsyn = m_syn0(:,:,ii);
    [each_vec,each_eigen] = eig(thismtsyn,'nobalance');
    lambda = diag(each_eigen);
    if ~issorted(lambda)
        [lambda,I] = sort(lambda);
        each_vec = each_vec(:, I);
    end
    V1(:,ii) = each_vec(:,1);
    V2(:,ii) = each_vec(:,2);
    V3(:,ii) = each_vec(:,3);
    Lambda(:,ii) = lambda;
end
end