%% 2D Mesh Independence Study – CL & CD Convergence
%  Coarse mesh excluded; successive differences computed from Medium onwards
%  Data: Mesh study with Cell 1 Height refinement
% -------------------------------------------------------------------------

clear; clc; close all;

%% ── Data ─────────────────────────────────────────────────────────────────
meshID   = {'Medium','Fine','Very Fine'};
elements = [79900, 434100, 554100];
CL       = [0.42826, 0.42229, 0.42201];
CD       = [0.01012, 0.01031, 0.01031];
x        = 1:numel(meshID);

%% ── Successive percentage differences ───────────────────────────────────
CL_diff = nan(size(CL));
CD_diff = nan(size(CD));
for i = 2:numel(CL)
    CL_diff(i) = abs((CL(i) - CL(i-1)) / CL(i-1)) * 100;
    CD_diff(i) = abs((CD(i) - CD(i-1)) / CD(i-1)) * 100;
end

ld = CL_diff(2:end);   % Medium->Fine, Fine->VeryFine
dd = CD_diff(2:end);

fprintf('==============================================\n');
fprintf('  Mesh Independence – Percentage Changes\n');
fprintf('==============================================\n');
fprintf('  Medium -> Fine      :  dCL = %.4f%%   dCD = %.4f%%\n', ld(1), dd(1));
fprintf('  Fine   -> Very Fine :  dCL = %.4f%%   dCD = %.4f%%\n', ld(2), dd(2));
fprintf('==============================================\n\n');

%% ── Colour palette ───────────────────────────────────────────────────────
col_CL   = [0.216  0.541  0.867];   % blue
col_CD   = [0.847  0.353  0.188];   % coral-red
col_grid = [0.88   0.88   0.88 ];
col_txt  = [0.30   0.30   0.30 ];
fnt      = 'Helvetica';

%% ── Figure ───────────────────────────────────────────────────────────────
fig = figure('Color','w','Units','centimeters','Position',[2 2 30 22], ...
             'Name','2D Mesh Independence Study');

tl = tiledlayout(2, 2, 'TileSpacing','compact', 'Padding','compact');

title(tl, '2D Mesh Independence Study', ...
    'FontSize',22, 'FontWeight','bold', 'FontName',fnt);
subtitle(tl, 'RANS CFD  |  Successive mesh refinement', ...
    'FontSize',18, 'FontName',fnt, 'Color',col_txt);

%% ── Helper: style an axes ────────────────────────────────────────────────
function style_ax(ax, meshID, x, col_grid, fnt)
    box(ax,'on'); grid(ax,'on');
    ax.GridColor      = col_grid;
    ax.MinorGridAlpha = 0.06;
    ax.FontSize       = 14;
    ax.FontName       = fnt;
    ax.LineWidth      = 0.9;
    ax.XTick          = x;
    ax.XTickLabel     = meshID;
    ax.XLim           = [0.6  numel(x)+0.4];
    grid(ax,'minor');
end

%% ── Panel 1: CL convergence ──────────────────────────────────────────────
ax1 = nexttile(1);
hold(ax1,'on');
style_ax(ax1, meshID, x, col_grid, fnt);

fill(ax1, [x fliplr(x)], ...
    [CL ones(1,numel(x))*(min(CL)-0.001)], ...
    col_CL, 'FaceAlpha',0.07, 'EdgeColor','none');

plot(ax1, x, CL, '-o', ...
    'Color',col_CL, 'LineWidth',2.8, 'MarkerSize',9, ...
    'MarkerFaceColor',col_CL);

% Delta labels above points (skip first – no predecessor)
for i = 2:numel(x)
    text(ax1, x(i), CL(i) + 0.0005, ...
        sprintf('\\Delta = %.2f%%', CL_diff(i)), ...
        'FontSize',16, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_CL);
end

% Element count below x-axis
for i = 1:numel(x)
    text(ax1, x(i), min(CL)-0.0009, ...
        sprintf('%.0fk', elements(i)/1e3), ...
        'FontSize',15, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',[0.5 0.5 0.5]);
end

ylabel(ax1, 'Lift Coefficient,  C_L',  'FontSize',20, 'FontName',fnt);
xlabel(ax1, 'Mesh',                     'FontSize',20, 'FontName',fnt);
title(ax1,  'C_L Convergence',          'FontSize',18, 'FontName',fnt, 'FontWeight','bold');
ax1.YLim = [min(CL)-0.002  max(CL)+0.002];
ax1.YAxis.Exponent = 0;
ax1.TickLabelInterpreter = 'tex';

%% ── Panel 2: CD convergence ──────────────────────────────────────────────
ax2 = nexttile(2);
hold(ax2,'on');
style_ax(ax2, meshID, x, col_grid, fnt);

fill(ax2, [x fliplr(x)], ...
    [CD ones(1,numel(x))*(min(CD)-0.00005)], ...
    col_CD, 'FaceAlpha',0.07, 'EdgeColor','none');

plot(ax2, x, CD, '-s', ...
    'Color',col_CD, 'LineWidth',2.8, 'MarkerSize',9, ...
    'MarkerFaceColor',col_CD);

for i = 2:numel(x)
    text(ax2, x(i), CD(i) + 0.000035, ...
        sprintf('\\Delta = %.2f%%', CD_diff(i)), ...
        'FontSize',16, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_CD);
end

for i = 1:numel(x)
    text(ax2, x(i), min(CD)-0.000045, ...
        sprintf('%.0fk', elements(i)/1e3), ...
        'FontSize',15, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',[0.5 0.5 0.5]);
end

ylabel(ax2, 'Drag Coefficient,  C_D',  'FontSize',16, 'FontName',fnt);
xlabel(ax2, 'Mesh',                     'FontSize',16, 'FontName',fnt);
title(ax2,  'C_D Convergence',          'FontSize',15, 'FontName',fnt, 'FontWeight','bold');
ax2.YLim = [min(CD)-0.00015  max(CD)+0.00012];

%% ── Panel 3: Percentage change bar chart ─────────────────────────────────
ax3 = nexttile(3, [1 2]);
hold(ax3,'on'); box(ax3,'on'); grid(ax3,'on');
ax3.GridColor      = col_grid;
ax3.FontSize       = 14;
ax3.FontName       = fnt;
ax3.LineWidth      = 0.9;
grid(ax3,'minor');

xb = [1 2];
bw = 0.28;

bL = bar(ax3, xb - bw/2, ld, bw, ...
    'FaceColor',col_CL, 'EdgeColor','none', 'FaceAlpha',0.88);
bD = bar(ax3, xb + bw/2, dd, bw, ...
    'FaceColor',col_CD, 'EdgeColor','none', 'FaceAlpha',0.88);

% Value labels – offset scales with tallest bar
offset = max([ld dd]) * 0.03;
for i = 1:2
    text(ax3, xb(i) - bw/2, ld(i) + offset, ...
        sprintf('%.2f%%', ld(i)), ...
        'FontSize',17, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_CL);

    text(ax3, xb(i) + bw/2, dd(i) + offset, ...
        sprintf('%.2f%%', dd(i)), ...
        'FontSize',16, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_CD);
end

% 1% convergence threshold
yline(ax3, 1.0, '--', 'LineWidth',1.6, 'Color',[0.4 0.4 0.4], ...
    'Label','  1% convergence threshold', ...
    'LabelHorizontalAlignment','left', ...
    'FontSize',16, 'FontName',fnt);

labels_pct = {'Medium \rightarrow Fine', ...
               'Fine \rightarrow Very Fine'};

ax3.XTick      = xb;
ax3.XTickLabel = labels_pct;
ax3.XLim       = [0.4   2.6];
ax3.YLim       = [0     max([ld dd]) * 1.22];

ylabel(ax3, 'Successive Change (%)', 'FontSize',20, 'FontName',fnt);
xlabel(ax3, 'Mesh Transition',       'FontSize',20, 'FontName',fnt);
title(ax3, 'Successive Percentage Change in C_L & C_D', ...
    'FontSize',18, 'FontName',fnt, 'FontWeight','bold');

leg = legend(ax3, [bL bD], {'C_L','C_D'}, ...
    'Location','northeast', 'FontSize',14, 'FontName',fnt, ...
    'Box','on', 'EdgeColor',[0.78 0.78 0.78]);
leg.Title.String     = 'Coefficient';
leg.Title.FontSize   = 18;
leg.Title.FontWeight = 'bold';

%% ── Export ───────────────────────────────────────────────────────────────
exportgraphics(fig, 'mesh_independence_2D.png', 'Resolution',300);
exportgraphics(fig, 'mesh_independence_2D.pdf', 'ContentType','vector');
fprintf('Saved mesh_independence_2D.png and .pdf\n');