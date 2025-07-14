function slab_cijkl = fun_slab_cijkl_thomsen(c33, c44, eps_range, gamma_range, delta1, delta2)
    c11_upper = c33*(1+eps_range*2);
    c66_upper = c44*(1+gamma_range*2);
    c13_upper = sqrt(2*c33*(c33-c44)*delta2+(c33-c44)^2)-c44;
    c13_lower = sqrt(2*c33*(c33-c44)*delta1+(c33-c44)^2)-c44;
    slab_cijkl = [c33,c44,c11_upper,c66_upper,c13_lower,c13_upper];
end