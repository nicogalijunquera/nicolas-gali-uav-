%% NACA 4415 – Lift Coefficient vs Angle of Attack
%  Experimental data: Hoffmann, Reuss Ramsay & Gregorek (1996)
%  OSU/NREL 3x5 Subsonic Wind Tunnel (NREL/TP-442-7815)
%  Reynolds numbers: 0.75e6, 1.0e6, 1.25e6, 1.5e6 (clean airfoil)
%  Leading-edge grit roughness (LEGR) at Re = 1.25e6 also included
%
%  UAS conditions
%    Freestream velocity : V   = 31.5   m/s
%    Chord length        : c   = 0.317  m
%    Air density (ISA)   : rho = 1.225  kg/m3
%    Dynamic viscosity   : mu  = 1.789e-5 Pa.s
%    Reynolds number     : Re_UAS ~ 6.84e5  -> closest curve: Re = 0.75e6
% -------------------------------------------------------------------------

clear; clc; close all;

%% ── Flow conditions ─────────────────────────────────────────────────────
V      = 31.5;      % Freestream velocity  [m/s]
c      = 0.317;     % Chord length         [m]
rho    = 1.225;     % Air density (ISA SL) [kg/m3]
mu     = 1.789e-5;  % Dynamic viscosity    [Pa.s]
Re_UAS = rho * V * c / mu;

fprintf('=========================================\n');
fprintf('  NACA 4415 - UAS Operating Conditions\n');
fprintf('=========================================\n');
fprintf('  V        = %.1f m/s\n',    V);
fprintf('  Chord    = %.3f m\n',      c);
fprintf('  Density  = %.3f kg/m3\n',  rho);
fprintf('  Re_UAS   = %.4e\n',        Re_UAS);
fprintf('  Highlighted curve: Re = 0.75e6\n');
fprintf('=========================================\n\n');

%% ── Experimental data (OSU/NREL, 1996) ──────────────────────────────────
aoa = [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8, 10, 12, 12.3, ...
        14,  16, 18, 20, 25, 30, 35, 40];

Cl_075 = [-0.62, -0.45, -0.26, -0.07,  0.13,  0.32,  0.52,  0.72, ...
            0.91,  1.07,  1.21,  1.28,  1.26,  1.15,  1.02,  0.92, ...
            0.85,  0.78,  0.73,  0.67,  0.60];  % <-- Re_UAS closest

Cl_100 = [-0.63, -0.46, -0.27, -0.07,  0.13,  0.33,  0.53,  0.73, ...
            0.93,  1.10,  1.24,  1.30,  1.29,  1.18,  1.05,  0.94, ...
            0.87,  0.80,  0.74,  0.68,  0.61];

Cl_125 = [-0.64, -0.46, -0.27, -0.08,  0.13,  0.34,  0.54,  0.74, ...
            0.94,  1.12,  1.27,  1.30,  1.30,  1.20,  1.07,  0.96, ...
            0.89,  0.81,  0.75,  0.69,  0.62];

Cl_150 = [-0.64, -0.47, -0.28, -0.08,  0.13,  0.34,  0.55,  0.75, ...
            0.95,  1.13,  1.28,  1.32,  1.31,  1.21,  1.08,  0.97, ...
            0.90,  0.82,  0.76,  0.70,  0.63];

Cl_LEGR = [-0.52, -0.37, -0.21, -0.04,  0.12,  0.28,  0.45,  0.63, ...
             0.80,  0.95,  1.04,  1.04,  1.03,  0.98,  0.92,  0.88, ...
             0.84,  0.78,  0.73,  0.67,  0.60];

%% ── Colours & line widths ────────────────────────────────────────────────
col_075  = [0.22  0.54  0.87];   % blue        (highlighted)
col_100  = [0.85  0.35  0.19];   % orange-red
col_125  = [0.49  0.62  0.14];   % olive green
col_150  = [0.50  0.47  0.87];   % violet
col_LEGR = [0.53  0.53  0.50];   % grey

lw_dim = 1.2;   lw_hi = 2.8;
ms_dim = 4;     ms_hi = 6;

%% ── Figure & axes ────────────────────────────────────────────────────────
fig = figure('Name','NACA 4415 Cl vs AoA', ...
             'Color','w', 'Units','centimeters', 'Position',[3 3 26 16]);

ax = axes('Parent', fig);
hold(ax, 'on');
box(ax,  'on');
grid(ax, 'on');
ax.GridAlpha      = 0.18;
ax.MinorGridAlpha = 0.08;
ax.FontSize       = 13;
ax.FontName       = 'Helvetica';
ax.LineWidth      = 0.8;
ax.XLim           = [-12 42];
ax.YLim           = [-0.9 1.65];
ax.XTick          = -10:5:40;
ax.YTick          = -0.8:0.2:1.6;
grid(ax, 'minor');

%% ── Plot curves ──────────────────────────────────────────────────────────
% Background curves plotted first
h100 = plot(ax, aoa, Cl_100, '-o', ...
    'Color',col_100, 'LineWidth',lw_dim, 'MarkerSize',ms_dim, ...
    'MarkerFaceColor',col_100, ...
    'DisplayName','Re = 1.0\times10^6 (clean)');

h125 = plot(ax, aoa, Cl_125, '-s', ...
    'Color',col_125, 'LineWidth',lw_dim, 'MarkerSize',ms_dim, ...
    'MarkerFaceColor',col_125, ...
    'DisplayName','Re = 1.25\times10^6 (clean)');

h150 = plot(ax, aoa, Cl_150, '-^', ...
    'Color',col_150, 'LineWidth',lw_dim, 'MarkerSize',ms_dim, ...
    'MarkerFaceColor',col_150, ...
    'DisplayName','Re = 1.50\times10^6 (clean)');

hLEGR = plot(ax, aoa, Cl_LEGR, '--d', ...
    'Color',col_LEGR, 'LineWidth',lw_dim, 'MarkerSize',ms_dim-1, ...
    'MarkerFaceColor',col_LEGR, ...
    'DisplayName','Re = 1.25\times10^6 (LEGR roughness)');

% Highlighted curve on top
h075 = plot(ax, aoa, Cl_075, '-o', ...
    'Color',col_075, 'LineWidth',lw_hi, 'MarkerSize',ms_hi, ...
    'MarkerFaceColor',col_075, ...
    'DisplayName', sprintf('Re = 0.75\\times10^6 (clean)   [Re_{UAS} = %.2f\\times10^6]', Re_UAS/1e6));

% Zero reference lines
yline(ax, 0, 'k:', 'LineWidth',0.8, 'HandleVisibility','off');
xline(ax, 0, 'k:', 'LineWidth',0.8, 'HandleVisibility','off');

% Star marker at Cl,max of highlighted curve
[Cl_max, idx_max] = max(Cl_075);
aoa_max = aoa(idx_max);
plot(ax, aoa_max, Cl_max, 'p', ...
    'Color',col_075, 'MarkerSize',14, 'MarkerFaceColor',col_075, ...
    'HandleVisibility','off');

%% ── Axis labels & title ──────────────────────────────────────────────────
xlabel(ax, 'Angle of Attack,  \alpha  (deg)', 'FontSize',18, 'FontName','Helvetica');
ylabel(ax, 'Lift Coefficient,  C_l',           'FontSize',18, 'FontName','Helvetica');
title(ax, ...
    {'NACA 4415 Aerofoil  –  Lift Coefficient vs Angle of Attack'}, ...
    'FontSize',18, 'FontName','Helvetica', 'FontWeight','bold');

%% ── Legend ───────────────────────────────────────────────────────────────
leg = legend(ax, [h075, h100, h125, h150, hLEGR], ...
    'Location','northwest', ...
    'FontSize',16, ...
    'FontName','Helvetica', ...
    'Box','on', ...
    'EdgeColor',[0.75 0.75 0.75]);
leg.Title.String     = 'Reynolds Number';
leg.Title.FontWeight = 'bold';
leg.Title.FontSize   = 16;

text(ax, 0.98, 0.05, ...
    sprintf('V = %.1f m/s,  c = %.3f m\nRe_{UAS} = %.3f \\times 10^6', ...
             V, c, Re_UAS/1e6), ...
    'Units','normalized', ...
    'FontSize',15, 'FontName','Helvetica', ...
    'Color',[0.25 0.25 0.25], ...
    'BackgroundColor',[0.97 0.97 0.97], ...
    'EdgeColor',[0.72 0.72 0.72], 'Margin',5, ...
    'HorizontalAlignment','right');
%% ── Arrow annotation: Cl,max from right margin ───────────────────────────
drawnow;   % flush renderer so ax.Position is populated

ax_pos = ax.Position;   % [left bottom width height] normalised fig units
xl     = ax.XLim;
yl     = ax.YLim;

% Convert data-space peak to normalised figure coordinates
tip_x = ax_pos(1) + ax_pos(3) * (aoa_max - xl(1)) / diff(xl);
tip_y = ax_pos(2) + ax_pos(4) * (Cl_max  - yl(1)) / diff(yl);

% Tail sits in the right margin, level with the peak
tail_x = ax_pos(1) + ax_pos(3) + 0.11;
tail_y = tip_y;

annotation(fig, 'arrow', [tail_x tip_x], [tail_y tip_y], ...
    'Color',col_075, 'LineWidth',1.6, 'HeadWidth',9, 'HeadLength',8);

annotation(fig, 'textbox', ...
    [tail_x - 0.005, tail_y + 0.012, 0.001, 0.001], ...
    'String', sprintf('C_{l,max} = %.2f\n\\alpha_{stall} = %.1f deg', Cl_max, aoa_max), ...
    'FontSize',11, 'FontName','Helvetica', ...
    'Color',col_075, ...
    'EdgeColor',col_075, ...
    'BackgroundColor',[1 1 1], ...
    'LineWidth',0.9, 'Margin',5, ...
    'FitBoxToText','on', ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment','bottom');

%% ── Export (uncomment to save) ───────────────────────────────────────────
% exportgraphics(fig, 'NACA4415_Cl_AoA.pdf', 'ContentType','vector');
% exportgraphics(fig, 'NACA4415_Cl_AoA.png', 'Resolution',300);

fprintf('Plot generated successfully.\n');
fprintf('Re_UAS = %.4e  ->  highlighted curve: Re = 0.75e6 (blue)\n', Re_UAS);