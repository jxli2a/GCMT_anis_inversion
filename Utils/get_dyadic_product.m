function d = get_dyadic_product(a, b)
% 2019-04-20
% By Jiaxuan Li
a = a(:);
b = b(:);
d = a*b'+b*a';
end