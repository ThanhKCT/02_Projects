function []=plotting(REP,Fitness)
% Plotting and verbose
    if(size(Fitness,2)==2)
        figure(1);
        plot(Fitness(:,1),Fitness(:,2),'or'); hold on;
        plot(REP.Fitness(:,1),REP.Fitness(:,2),'ok'); %hold on;
        try
            set(gca,'xtick',REP.hypercube_limits(:,1)','ytick',REP.hypercube_limits(:,2)');
            axis([min(REP.hypercube_limits(:,1)) max(REP.hypercube_limits(:,1)) ...
                  min(REP.hypercube_limits(:,2)) max(REP.hypercube_limits(:,2))]);
            grid on; xlabel('f1'); ylabel('f2');
        end
        % drawnow;
    end
    if(size(Fitness,2)==3)
        h_fig = figure(1);
        h_par = plot3(Fitness(:,1),Fitness(:,2),Fitness(:,3),'or'); hold on;
        h_rep = plot3(REP.Fitness(:,1),REP.Fitness(:,2),REP.Fitness(:,3),'ok'); %hold on;
        try
                set(gca,'xtick',REP.hypercube_limits(:,1)','ytick',REP.hypercube_limits(:,2)','ztick',REP.hypercube_limits(:,3)');
                axis([min(REP.hypercube_limits(:,1)) max(REP.hypercube_limits(:,1)) ...
                      min(REP.hypercube_limits(:,2)) max(REP.hypercube_limits(:,2))]);
        end
        grid on; xlabel('f1'); ylabel('f2'); zlabel('f3');
        drawnow;
        axis square;
    end