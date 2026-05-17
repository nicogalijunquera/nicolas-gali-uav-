clear; clc; close all;

%% -------------------------------------------------
%  BrUAS 2022 Baseline Structural Calibration
%% -------------------------------------------------
b0 = 2.52;
c0 = 0.39993;
S  = b0 * c0;
AR0 = b0^2 / S;

mass0 = 10;
g = 9.81;
W0 = mass0 * g;

n_fail0 = 3.5;
M_fail0 = n_fail0 * W0 * b0 / 2;

%% -------------------------------------------------
%  Aerodynamic Model
%% -------------------------------------------------
CL      = 0.60;
CD0_ref = 0.025;
e       = 0.85;
kRe     = 0.20;

%% -------------------------------------------------
%  AR Range
%% -------------------------------------------------
AR = linspace(4, 18, 8000);

b = sqrt(AR .* S);

CD0 = CD0_ref .* (AR ./ AR0).^kRe;
CDi = CL^2 ./ (pi * e .* AR);
CD  = CD0 + CDi;
LD  = CL ./ CD;

LD0 = interp1(AR, LD, AR0, 'linear');
[LD_max, idx] = max(LD);
AR_opt = AR(idx);

M_root = n_fail0 * W0 .* b / 2;

%% -------------------------------------------------
%  Selected AR points
%% -------------------------------------------------
AR_pts = [8 10 12 14];
LD_pts = interp1(AR, LD, AR_pts, 'linear');
pct_improve = 100 * (LD_pts - LD0) ./ LD0;

%% -------------------------------------------------
%  Typography Scaling
%% -------------------------------------------------
baseFont   = 26;
titleFont  = 32;
labelFont  = 28;
tickFont   = 24;
legendFont = 22;

fig = figure('Color','w','Position',[50 50 1600 900]);

set(fig, 'DefaultAxesFontSize', tickFont);
set(fig, 'DefaultTextFontSize', baseFont);
set(fig, 'DefaultLineLineWidth', 3);

%% -------------------------------------------------
%  Plot
%% -------------------------------------------------
yyaxis left
hLD  = plot(AR, LD, 'LineWidth', 3.2); hold on
hOpt = plot(AR_opt, LD_max, 'o', 'MarkerSize', 14, 'LineWidth', 3);
hPts = plot(AR_pts, LD_pts, 's', 'MarkerSize', 13, 'LineWidth', 3);

ylabel('Estimated Aerodynamic Efficiency, L/D', 'FontSize', labelFont)
ylim([0 max(LD)*1.15])

yyaxis right
hM = plot(AR, M_root, 'LineWidth', 3.2); hold on
hMfail = yline(M_fail0, '--', 'LineWidth', 3);
ylabel('Root Bending Moment (Nm)', 'FontSize', labelFont)
ylim([0 max(M_root)*1.15])

hBase = xline(AR0, '--', 'LineWidth', 3);
hAR10 = xline(10, '--', 'LineWidth', 3);

xlabel('Aspect Ratio, AR', 'FontSize', labelFont)
title('Aerodynamic Efficiency and Root Bending Moment vs Aspect Ratio', ...
      'FontSize', titleFont)

grid on
set(gca, 'FontSize', tickFont, 'LineWidth', 1.8);

%% -------------------------------------------------
%  % labels (clean + minimal)
%% -------------------------------------------------
yyaxis left

yRange  = max(LD) - min(LD);
xOffset = 0.18;
yOffset = 0.045 * yRange;

for i = 1:numel(AR_pts)

    txt = sprintf('+%.1f\\%%', pct_improve(i));

    t = text(AR_pts(i) + xOffset, ...
             LD_pts(i) + yOffset, ...
             txt, ...
             'Interpreter','latex', ...
             'FontSize', baseFont-4, ...
             'VerticalAlignment','bottom', ...
             'HorizontalAlignment','left', ...
             'Margin', 3);

    t.BackgroundColor = [1 1 1 0.6];   % semi-transparent
    t.EdgeColor = 'none';
end

%% -------------------------------------------------
%  Legend (clarifies % reference)
%% -------------------------------------------------
lg = legend([hLD hPts hOpt hM hMfail hBase hAR10], ...
    { ...
      'L/D', ...
      'Annotated AR points (% increase relative to baseline AR_0)', ...
      sprintf('Aero-only optimum (AR = %.2f)', AR_opt), ...
      'Root bending moment', ...
      sprintf('BrUAS 2022 failure moment (%.0f Nm)', M_fail0), ...
      sprintf('Baseline AR_0 = %.2f', AR0), ...
      'AR = 10' ...
    }, ...
    'Location','best');

set(lg, 'FontSize', legendFont);

%% -------------------------------------------------
%  Export
%% -------------------------------------------------
outDir = fullfile(pwd, 'exports');
if ~exist(outDir, 'dir'); mkdir(outDir); end

exportgraphics(fig, fullfile(outDir,'AR_LD_Mroot_large_clean.png'), 'Resolution', 600);
exportgraphics(fig, fullfile(outDir,'AR_LD_Mroot_large_clean.pdf'), 'ContentType', 'vector');

disp('Saved: AR_LD_Mroot_large_clean.png and .pdf');

