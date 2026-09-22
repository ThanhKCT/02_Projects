% INVESTIGATE_RUN20_COLLAPSE  Doc checkpoint run20, xem ArchiveFitness tai
% vong 49 (truoc sup) va vong 50 (sau sup) de tim diem gay sup archive.
S = load('D:\ResearchLab\02_Projects\02_Projects\JTST paper 4\code\results\Bai6_MOSFOA_Np20_Maxit100_run20_CKPT.mat');
H = S.History;

fprintf('lastIter da luu trong checkpoint: %d\n', S.lastIter);

idx49 = 50; % idx = iter+1
idx50 = 51;
fit49 = H.ArchiveFitness{idx49};
fit50 = H.ArchiveFitness{idx50};
pos49 = H.ArchiveX{idx49};
pos50 = H.ArchiveX{idx50};

fprintf('\n=== Vong 49: Repository=%d ===\n', size(fit49,1));
fprintf('f1 range: [%.2f, %.2f]  f2 range: [%.4f, %.4f]\n', min(fit49(:,1)), max(fit49(:,1)), min(fit49(:,2)), max(fit49(:,2)));

fprintf('\n=== Vong 50: Repository=%d (SAU SUP) ===\n', size(fit50,1));
disp(fit50);
disp(pos50);

fprintf('\n=== Toan bo Fitness (X, newFit) tai vong lap 50 (khong chi archive) ===\n');
% Xpos/Fitness la quan the CHINH (khong phai chi archive) tai thoi diem luu checkpoint
fprintf('Fitness hien tai (Xpos/Fitness luu trong checkpoint, N=%d):\n', size(S.Fitness,1));
disp(S.Fitness);
fprintf('Xpos tuong ung:\n');
disp(S.Xpos);

fprintf('\n=== Tim diem co f2 gan 0 hoac bat thuong trong Fitness hien tai ===\n');
suspiciousIdx = find(S.Fitness(:,2) < 0.01 | S.Fitness(:,1) < 100);
if isempty(suspiciousIdx)
    fprintf('Khong tim thay diem nao f2<0.01 hoac f1<100 trong quan the HIEN TAI (co the diem gay loi da bi thay the o cac vong sau).\n');
else
    fprintf('Cac ca the nghi ngo (chi so, x, fitness):\n');
    for i = suspiciousIdx'
        fprintf('  idx=%d x=%s fit=%s\n', i, mat2str(S.Xpos(i,:)), mat2str(S.Fitness(i,:)));
    end
end
