%% AR = 10 graphical justification (theory-based)
% Normalised induced-drag trend:  CDi / CDi0 = AR0 / AR
% Baseline BrUAS 2022 AR0 computed from geometry: AR0 = b0^2/S (or b0/c0 for rectangular)
% Here we use AR0 = 6.30 (from b0 = 2.52 m, c0 = 0.39993 m).

clear; clc; close all;

AR0 = 6.30;           % baseline aspect ratio
AR_select = 10;       % chosen aspect ratio

% High-resolution AR range
AR = linspace(3, 20, 2000);        % "more points" + smooth curve
CDi_norm = AR0 ./ AR;              % CDi / CDi0

% Add a few reference points (optional markers)
AR_pts = [4 5 6 6.3 8 10 12 15 18];
CDi_pts = AR0 ./ AR_pts;

% Figure
fig = figure('Color','w','Units','pixels','Position',[100 100 900 520]);
plot(AR, CDi_norm, 'LineWidth', 2); hold on;
plot(AR_pts, CDi_pts, 'o', 'MarkerSize', 6, 'LineWidth', 1.2);

% Highlight chosen AR=10 and baseline AR0
y_select = AR0 / AR_select;
xline(AR_select, '--', 'LineWidth', 1.5);
yline(y_select, '--', 'LineWidth', 1.2);

% Annotate key points
text(AR_select+0.2, y_select, sprintf('  AR = %g (CDi/CDi0 = %.3f)', AR_select, y_select), ...
    'FontSize', 19, 'VerticalAlignment','bottom');

% Labels and formatting
grid on;
xlabel('Aspect Ratio, AR', 'FontSize', 20);
ylabel('Normalised induced drag term, C_{D,i}/C_{D,i,0}', 'FontSize', 20);
title('Diminishing returns of induced drag reduction with increasing AR (theory)', 'FontSize', 30);

% Tight axis limits
xlim([min(AR) max(AR)]);
ylim([0 max(CDi_norm)*1.05]);

% Export high-quality images for Overleaf
outDir = fullfile(pwd, 'exports');
if ~exist(outDir, 'dir'); mkdir(outDir); end

exportgraphics(fig, fullfile(outDir,'AR_induced_drag_normalised.png'), 'Resolution', 600);
exportgraphics(fig, fullfile(outDir,'AR_induced_drag_normalised.pdf'), 'ContentType', 'vector');
disp('Saved: exports/AR_induced_drag_normalised.png and .pdf');
