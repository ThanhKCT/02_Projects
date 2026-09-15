function non_dominated_solutions = non_dominated_solutions(num_solutions)
    % 假设每个非支配解有两个决策变量
    % num_solutions: 非支配解的数量

    % 生成一个随机的非支配解矩阵，每一行是一个非支配解，每列是一个决策变量
    non_dominated_solutions = rand(num_solutions, 2); % 生成随机的非支配解数据
end
