function []=plotting(REP,POS_fit)
% Plotting and verbose
    if(size(POS_fit,2)==2)
        h_fig = figure(1);
        h_par = plot(POS_fit(:,1),POS_fit(:,2),'or'); hold on;
        h_rep = plot(REP.pos_fit(:,1),REP.pos_fit(:,2),'ok'); hold on;
        try
            set(gca,'xtick',REP.hypercube_limits(:,1)','ytick',REP.hypercube_limits(:,2)');
            axis([min(REP.hypercube_limits(:,1)) max(REP.hypercube_limits(:,1)) ...
                  min(REP.hypercube_limits(:,2)) max(REP.hypercube_limits(:,2))]);
            grid on; xlabel('f1'); ylabel('f2');
        end
        drawnow;
    end
    if(size(POS_fit,2)==3)
        h_fig = figure(1);
        h_par = plot3(POS_fit(:,1),POS_fit(:,2),POS_fit(:,3),'or'); hold on;
        h_rep = plot3(REP.pos_fit(:,1),REP.pos_fit(:,2),REP.pos_fit(:,3),'ok'); hold on;
        try
                set(gca,'xtick',REP.hypercube_limits(:,1)','ytick',REP.hypercube_limits(:,2)','ztick',REP.hypercube_limits(:,3)');
                axis([min(REP.hypercube_limits(:,1)) max(REP.hypercube_limits(:,1)) ...
                      min(REP.hypercube_limits(:,2)) max(REP.hypercube_limits(:,2))]);
        end
        grid on; xlabel('f1'); ylabel('f2'); zlabel('f3');
        drawnow;
        axis square;
    end