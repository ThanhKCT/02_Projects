clear all; close all; clc
No_layers=7;
pile_type = pile_type_guide(true);
method    = method_guide(true);
for i=1:No_layers
    soil_type = soil_type_guide(true);
    gamma.cf(i) = get_gamma_cf(pile_type, soil_type, method)
end
soil_type = soil_type_guide(true);
gamma.cq = get_gamma_cq(pile_type, method)
gamma.c = get_gamma_c()
gamma.ck = get_gamma_c()
gamma.O = get_gamma_0()
gamma.n = get_gamma_n()
gamma.k = get_gamma_k()
save gamma.mat gamma
