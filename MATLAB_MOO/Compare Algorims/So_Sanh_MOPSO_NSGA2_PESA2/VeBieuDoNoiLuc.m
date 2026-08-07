function VeBieuDoNoiLuc(NoiLuc)
    X = [0, 10,  0, 10,  0, 10];
    Y = [0,  0,  4,  4,  8,  8];

    subplot(1,3,1); hold on; grid on; axis equal; title('Biểu đồ Lực Dọc N (T)','FontWeight','bold');
    VeThanh_N(X(1),Y(1),X(3),Y(3), NoiLuc.Cot1.N_i, NoiLuc.Cot1.N_j, 'r');
    VeThanh_N(X(2),Y(2),X(4),Y(4), NoiLuc.Cot2.N_i, NoiLuc.Cot2.N_j, 'r');
    VeThanh_N(X(3),Y(3),X(5),Y(5), NoiLuc.Cot3.N_i, NoiLuc.Cot3.N_j, 'r');
    VeThanh_N(X(4),Y(4),X(6),Y(6), NoiLuc.Cot4.N_i, NoiLuc.Cot4.N_j, 'r');
    VeThanh_N(X(3),Y(3),X(4),Y(4), NoiLuc.Dam1.N_i, NoiLuc.Dam1.N_j, 'b');
    VeThanh_N(X(5),Y(5),X(6),Y(6), NoiLuc.Dam2.N_i, NoiLuc.Dam2.N_j, 'b');

    subplot(1,3,2); hold on; grid on; axis equal; title('Biểu đồ Lực Cắt Q (T)','FontWeight','bold');
    VeThanh_Q(X(1),Y(1),X(3),Y(3), NoiLuc.Cot1.Q_i, NoiLuc.Cot1.Q_j, 'r');
    VeThanh_Q(X(2),Y(2),X(4),Y(4), NoiLuc.Cot2.Q_i, NoiLuc.Cot2.Q_j, 'r');
    VeThanh_Q(X(3),Y(3),X(5),Y(5), NoiLuc.Cot3.Q_i, NoiLuc.Cot3.Q_j, 'r');
    VeThanh_Q(X(4),Y(4),X(6),Y(6), NoiLuc.Cot4.Q_i, NoiLuc.Cot4.Q_j, 'r');
    VeThanh_Q(X(3),Y(3),X(4),Y(4), NoiLuc.Dam1.Q_i, NoiLuc.Dam1.Q_j, 'b');
    VeThanh_Q(X(5),Y(5),X(6),Y(6), NoiLuc.Dam2.Q_i, NoiLuc.Dam2.Q_j, 'b');

    subplot(1,3,3); hold on; grid on; axis equal; title('Biểu đồ Mô-men M (T.m)','FontWeight','bold');
    VeThanh_M(X(1),Y(1),X(3),Y(3), NoiLuc.Cot1.M_i, NoiLuc.Cot1.M_j, 'r');
    VeThanh_M(X(2),Y(2),X(4),Y(4), NoiLuc.Cot2.M_i, NoiLuc.Cot2.M_j, 'r');
    VeThanh_M(X(3),Y(3),X(5),Y(5), NoiLuc.Cot3.M_i, NoiLuc.Cot3.M_j, 'r');
    VeThanh_M(X(4),Y(4),X(6),Y(6), NoiLuc.Cot4.M_i, NoiLuc.Cot4.M_j, 'r');
    VeThanh_M(X(3),Y(3),X(4),Y(4), NoiLuc.Dam1.M_i, NoiLuc.Dam1.M_j, 'b');
    VeThanh_M(X(5),Y(5),X(6),Y(6), NoiLuc.Dam2.M_i, NoiLuc.Dam2.M_j, 'b');
end

function VeThanh_N(x1,y1,x2,y2,vi,vj,mau)
    plot([x1,x2],[y1,y2],mau,'LineWidth',2);
    scale = 0.015; % T -> m (giá trị N thường ~20-60 T => lệch ~0.3-0.9m)
    if x1==x2
        plot([x1, x1-vi*scale],[y1,y1],mau); plot([x2, x2-vj*scale],[y2,y2],mau);
        plot([x1-vi*scale, x2-vj*scale],[y1,y2],mau);
        text(x1-vi*scale-0.5, (y1+y2)/2, sprintf('%.1f', vi),'FontSize',9);
    else
        plot([x1,x1],[y1, y1+vi*scale],mau); plot([x2,x2],[y2, y2+vj*scale],mau);
        plot([x1,x2],[y1+vi*scale, y2+vj*scale],mau);
        text((x1+x2)/2, y1+vi*scale+0.5, sprintf('%.1f', vi),'FontSize',9);
    end
end

function VeThanh_Q(x1,y1,x2,y2,vi,vj,mau)
    plot([x1,x2],[y1,y2],mau,'LineWidth',2);
    scale = 0.1; % T -> m (giá trị Q thường ~2-25 T => lệch ~0.2-2.5m)
    if x1==x2
        plot([x1, x1-vi*scale],[y1,y1],mau); plot([x2, x2-vj*scale],[y2,y2],mau);
        plot([x1-vi*scale, x2-vj*scale],[y1,y2],mau);
    else
        plot([x1,x1],[y1, y1+vi*scale],mau); plot([x2,x2],[y2, y2+vj*scale],mau);
        plot([x1,x2],[y1+vi*scale, y2+vj*scale],mau);
    end
end

function VeThanh_M(x1,y1,x2,y2,vi,vj,mau)
    plot([x1,x2],[y1,y2],mau,'LineWidth',2);
    scale = 0.02; % T.m -> m (giá trị M thường ~5-50 T.m => lệch ~0.1-1m)
    if x1==x2
        plot([x1, x1+vi*scale],[y1,y1],mau); plot([x2, x2+vj*scale],[y2,y2],mau);
        plot([x1+vi*scale, x2+vj*scale],[y1,y2],mau);
    else
        plot([x1,x1],[y1, y1-vi*scale],mau); plot([x2,x2],[y2, y2-vj*scale],mau);
        plot([x1,x2],[y1-vi*scale, y2-vj*scale],mau);
    end
end
