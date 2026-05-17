%% Corrected Lift and L/D vs AoA — Model 1 (Baseline) & Model 5 (Final)
clear; clc; close all;

%% Data — corrected values only
AoA = (1:16)';

% Model 1 — Baseline BrUAS 2022
drag1 = [8.91,11.24,13.61,16.02,18.47,20.95,23.48,26.05,28.69,31.42,34.27,37.22,39.98,42.66,45.27,48.33]';
lift1 = [136.02,136.94,138.02,139.06,140.04,141.02,142.01,143.04,144.19,145.54,147.21,148.80,148.63,148.04,147.18,148.44]';

% Model 5 — Final Proposed Configuration
drag5 = [9.49,12.06,14.68,17.35,20.05,22.80,25.59,28.44,31.37,34.39,37.56,40.88,44.00,46.85,49.98,52.96]';
lift5 = [152.03,152.71,153.87,155.01,156.13,157.23,158.35,159.54,160.87,162.48,164.47,166.51,166.55,165.23,165.41,164.55]';

% L/D
LD1 = lift1 ./ drag1;
LD5 = lift5 ./ drag5;

%% Derived statistics
[maxLift1, iStall1] = max(lift1);   stallAoA1 = AoA(iStall1);
[maxLift5, iStall5] = max(lift5);   stallAoA5 = AoA(iStall5);
avgDiff = mean((lift5 - lift1) ./ lift1 * 100);
[maxLD1, iMaxLD1]   = max(LD1);     maxLDAoA1 = AoA(iMaxLD1);
[maxLD5, iMaxLD5]   = max(LD5);     maxLDAoA5 = AoA(iMaxLD5);

%% Style
c1  = [0.173 0.627 0.173];   % green  — Model 1
c5  = [0.580 0.000 0.827];   % purple — Model 5
cg  = [0.88  0.88  0.88];
fnt = 'Helvetica';
lw  = 2.2;
ms  = 8;

%% Figure 1 — Corrected Lift vs AoA
fig1 = figure('Color','w','Units','centimeters','Position',[2 2 22 13]);
hold on; grid on; box on;
ax = gca; ax.FontSize = 16; ax.FontName = fnt; ax.GridColor = cg;

plot(AoA, lift1, '-o','Color',c1,'LineWidth',lw,'MarkerSize',ms,...
    'MarkerFaceColor',c1,...
    'DisplayName',sprintf('Model 1 — Baseline  |  Max lift: %.1f N (@%d^{\\circ})  |  Stall: %d^{\\circ}',...
    maxLift1, stallAoA1, stallAoA1));

plot(AoA, lift5, '-s','Color',c5,'LineWidth',lw,'MarkerSize',ms,...
    'MarkerFaceColor',c5,...
    'DisplayName',sprintf('Model 5 — Final  |  Max lift: %.1f N (@%d^{\\circ})  |  Stall: %d^{\\circ}  |  Avg \\DeltaLift: +%.1f%%',...
    maxLift5, stallAoA5, stallAoA5, avgDiff));

% Stall markers
plot(stallAoA1, maxLift1, 'v','Color',c1,'MarkerSize',13,...
    'MarkerFaceColor',c1,'HandleVisibility','off');
plot(stallAoA5, maxLift5, 'v','Color',c5,'MarkerSize',13,...
    'MarkerFaceColor',c5,'HandleVisibility','off');

text(stallAoA1+0.2, maxLift1-1.2, sprintf('Stall %d^\\circ',stallAoA1),...
    'FontSize',14,'FontName',fnt,'Color',c1,'FontWeight','bold');
text(stallAoA5+0.2, maxLift5-1.2, sprintf('Stall %d^\\circ',stallAoA5),...
    'FontSize',14,'FontName',fnt,'Color',c5,'FontWeight','bold');

xlabel('Angle of Attack \alpha (deg)','FontSize',18,'FontName',fnt,'FontWeight','bold');
ylabel('Lift (N)','FontSize',18,'FontName',fnt,'FontWeight','bold');
title('Lift vs Angle of Attack','FontSize',24,'FontName',fnt,'FontWeight','bold');
lg1 = legend('Location','northwest','FontSize',13,'FontName',fnt);
lg1.Box = 'on'; lg1.EdgeColor = [0.5 0.5 0.5];
xlim([0 17]); ylim([130 175]); xticks(1:16);
exportgraphics(fig1,'Lift_vs_AoA.png','Resolution',300);

%% Figure 2 — L/D vs AoA
fig2 = figure('Color','w','Units','centimeters','Position',[2 2 22 13]);
hold on; grid on; box on;
ax = gca; ax.FontSize = 16; ax.FontName = fnt; ax.GridColor = cg;

plot(AoA, LD1, '-o','Color',c1,'LineWidth',lw,'MarkerSize',ms,...
    'MarkerFaceColor',c1,...
    'DisplayName',sprintf('Model 1 — Baseline  |  Max L/D: %.2f (@%d^{\\circ})',...
    maxLD1, maxLDAoA1));

plot(AoA, LD5, '-s','Color',c5,'LineWidth',lw,'MarkerSize',ms,...
    'MarkerFaceColor',c5,...
    'DisplayName',sprintf('Model 5 — Final  |  Max L/D: %.2f (@%d^{\\circ})',...
    maxLD5, maxLDAoA5));

% Peak L/D markers
plot(maxLDAoA1, maxLD1, 'p','Color',c1,'MarkerSize',15,...
    'MarkerFaceColor',c1,'HandleVisibility','off');
plot(maxLDAoA5, maxLD5, 'p','Color',c5,'MarkerSize',15,...
    'MarkerFaceColor',c5,'HandleVisibility','off');

text(maxLDAoA1+0.2, maxLD1+0.1, sprintf('Peak %.2f',maxLD1),...
    'FontSize',14,'FontName',fnt,'Color',c1,'FontWeight','bold');
text(maxLDAoA5+0.2, maxLD5+0.1, sprintf('Peak %.2f',maxLD5),...
    'FontSize',14,'FontName',fnt,'Color',c5,'FontWeight','bold');

xlabel('Angle of Attack \alpha (deg)','FontSize',18,'FontName',fnt,'FontWeight','bold');
ylabel('Aerodynamic Efficiency L/D','FontSize',18,'FontName',fnt,'FontWeight','bold');
title('Aerodynamic Efficiency vs Angle of Attack','FontSize',24,'FontName',fnt,'FontWeight','bold');
lg2 = legend('Location','northeast','FontSize',13,'FontName',fnt);
lg2.Box = 'on'; lg2.EdgeColor = [0.5 0.5 0.5];
xlim([0 17]); xticks(1:16);
exportgraphics(fig2,'LD_vs_AoA.png','Resolution',300);