%% Weighted Aerodynamic Efficiency Analysis
%  Three panels: raw L/D, efficiency per unit AR, % increase vs baseline
% -------------------------------------------------------------------------
clear; clc; close all;

%% Data
models = {'Model 1','Model 2','Model 3','Model 4','Model 5'};
x      = 1:5;
LD           = [16.9906, 20.3865, 21.0745, 20.7906, 21.6639];
eff_per_AR   = [0,       0.9178,  1.0109,  1.0270,  1.1568 ];
pct_eff      = [0,       19.99,   24.04,   22.37,   27.51  ];

%% Colours
c1  = [0.216 0.494 0.722];
c2  = [0.173 0.627 0.173];
c3  = [0.847 0.353 0.188];
cg  = [0.88  0.88  0.88 ];
fnt = 'Helvetica';

%% Figure — reduced height, full page width
fig = figure('Color','w','Units','centimeters','Position',[2 2 32 7]);
tl  = tiledlayout(1,3,'TileSpacing','compact','Padding','compact');
title(tl,'Weighted Aerodynamic Efficiency Analysis', ...
    'FontSize',26,'FontWeight','bold','FontName',fnt);
subtitle(tl,'All configurations relative to BrUAS 2022 baseline', ...
    'FontSize',19,'FontName',fnt,'Color',[0.3 0.3 0.3]);

%% Panel 1 — Raw L/D
ax1 = nexttile(1);
hold(ax1,'on'); grid(ax1,'on'); box(ax1,'on');
ax1.GridColor=cg; ax1.FontSize=18; ax1.FontName=fnt;
ax1.XTick=x; ax1.XTickLabel=models; ax1.XTickLabelRotation=15;
bar(ax1,x,LD,0.6,'FaceColor',c1,'EdgeColor','none','FaceAlpha',0.88);
yline(ax1,LD(1),'--','Color',[0.5 0.5 0.5],'LineWidth',1.2, ...
    'Label','  ','LabelHorizontalAlignment','left', ...
    'FontSize',17,'FontName',fnt);
for i=1:5
    text(ax1,x(i),LD(i)+0.45,sprintf('%.2f',LD(i)), ...
        'FontSize',17,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',c1);
end
ylabel(ax1,'L/D','FontSize',20,'FontName',fnt,'FontWeight','bold');
title(ax1,'Aerodynamic Efficiency','FontSize',19,'FontName',fnt,'FontWeight','bold');
ax1.YLim=[0 26];

%% Panel 2 — Delta L/D per unit delta AR_eff
ax2 = nexttile(2);
hold(ax2,'on'); grid(ax2,'on'); box(ax2,'on');
ax2.GridColor=cg; ax2.FontSize=18; ax2.FontName=fnt;
ax2.XTick=x; ax2.XTickLabel=models; ax2.XTickLabelRotation=15;
bar(ax2,x,eff_per_AR,0.6,'FaceColor',c2,'EdgeColor','none','FaceAlpha',0.88);
for i=2:5
    text(ax2,x(i),eff_per_AR(i)+0.05,sprintf('%.3f',eff_per_AR(i)), ...
        'FontSize',17,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',c2);
end
text(ax2,x(1),0.03,'ref','FontSize',17,'FontName',fnt, ...
    'HorizontalAlignment','center','Color',[0.5 0.5 0.5]);
ylabel(ax2,'\Delta(L/D) per unit \Delta AR_{eff}', ...
    'FontSize',19,'FontName',fnt,'FontWeight','bold');
title(ax2,'Efficiency Gain per AR Unit', ...
    'FontSize',19,'FontName',fnt,'FontWeight','bold');
ax2.YLim=[0 1.5];

%% Panel 3 — % efficiency increase vs baseline
ax3 = nexttile(3);
hold(ax3,'on'); grid(ax3,'on'); box(ax3,'on');
ax3.GridColor=cg; ax3.FontSize=18; ax3.FontName=fnt;
ax3.XTick=x; ax3.XTickLabel=models; ax3.XTickLabelRotation=15;
bar(ax3,x,pct_eff,0.6,'FaceColor',c3,'EdgeColor','none','FaceAlpha',0.88);
for i=1:5
    if pct_eff(i) > 0
        text(ax3,x(i),pct_eff(i)+0.9,sprintf('+%.2f%%',pct_eff(i)), ...
            'FontSize',17,'FontName',fnt,'FontWeight','bold', ...
            'HorizontalAlignment','center','Color',c3);
    else
        text(ax3,x(i),0.5,'ref','FontSize',17,'FontName',fnt, ...
            'HorizontalAlignment','center','Color',[0.5 0.5 0.5]);
    end
end
yline(ax3,0,'--','Color',[0.5 0.5 0.5],'LineWidth',1.2,'HandleVisibility','off');
ylabel(ax3,'Efficiency Increase vs Baseline (%)', ...
    'FontSize',19,'FontName',fnt,'FontWeight','bold');
title(ax3,'% Improvement over BrUAS 2022', ...
    'FontSize',19,'FontName',fnt,'FontWeight','bold');
ax3.YLim=[0 34];

%% Export
exportgraphics(fig,'LDcomparisonanalysis.png','Resolution',300);