% Function for checking the domination between the population. It
% returns a vector that indicates if each particle is dominated (1) or not
function dom_vector = checkDomination(fitness)
    Np = size(fitness,1);
    dom_vector = zeros(Np,1);
    all_perm = nchoosek(1:Np,2);    % Possible permutations - thiết lập so sánh giữa fitness của mỗi cá thế với tất cả fitness của các cá thể còn lại trong đàn - mỗi fitness có thể có nhiều giá trị tùy thuộc vào hàm mục tiêu
    all_perm = [all_perm; [all_perm(:,2) all_perm(:,1)]];
    
    d = dominates(fitness(all_perm(:,1),:),fitness(all_perm(:,2),:)); % 1 là vượt trội (tốt hơn); 0 là bị vượt trội (tệ hơn)
    dominated_particles = unique(all_perm(d==1,2)); % cá thể bị vượt trội (tệ hơn)
    dom_vector(dominated_particles) = 1; % 0 là vượt trội (tốt hơn); 1 bị vượt trội (tệ hơn)
end