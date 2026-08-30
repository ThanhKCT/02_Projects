clc; clear all; close all;
h  = [4.8 5.3 9.6 1.7 4.9 2.3]
IL = [0.76 0.31 0.63 0.31 0.67 0.3];

k       = get_k_from_IL(IL);
kq      = get_equivalent_k_multi(h, k);
E0      = select_concrete_E_by_grade(300); % Chọn bê tông mác 300 (MPa)
I       = calc_section_inertia('hollow_round', [0.7, 0.6]);
bp      = get_equivalent_pile_width(0.6);
gamma_c = 0.8;
alpha_e = (bp.*kq/(gamma_c*E0*I)).^(1/5);
lu = 2./alpha_e; % chiều dài chịu uốn tính từ mặt đất
layer = find(lu <= cumsum(h), 1, 'first')
lu = 2./alpha_e(layer)


