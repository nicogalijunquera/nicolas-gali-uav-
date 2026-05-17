%% 3D Mesh Independence Study – Enhanced Plot
%  Lift and Drag convergence with successive percentage change annotations
% -------------------------------------------------------------------------

clear; clc; close all;

%% ── Data ─────────────────────────────────────────────────────────────────
meshID   = {'DP 0','DP 1','DP 2','DP 3'};
elements = [2944166, 4744524, 8793536, 11942783];
drag     = [7.7555706, 6.7844811, 6.6661231, 6.6185834];
lift     = [139.97456, 136.49034, 134.98708, 134.93048];
x        = 1:numel(meshID);

%% ── Successive percentage differences ───────────────────────────────────
drag_diff = nan(size(drag));
lift_diff = nan(size(lift));
for i = 2:numel(drag)
    drag_diff(i) = abs((drag(i) - drag(i-1)) / drag(i-1)) * 100;
    lift_diff(i) = abs((lift(i) - lift(i-1)) / lift(i-1)) * 100;
end

% Extract only the transition values (indices 2,3,4)
ld = lift_diff(2:end);   % [lift DP0->1,  DP1->2,  DP2->3]
dd = drag_diff(2:end);   % [drag DP0->1,  DP1->2,  DP2->3]

fprintf('Lift diffs:  %.4f%%  %.4f%%  %.4f%%\n', ld(1), ld(2), ld(3));
fprintf('Drag diffs:  %.4f%%  %.4f%%  %.4f%%\n', dd(1), dd(2), dd(3));

%% ── Colour palette ───────────────────────────────────────────────────────
col_lift = [0.216  0.541  0.867];
col_drag = [0.847  0.353  0.188];
col_grid = [0.88   0.88   0.88 ];
col_txt  = [0.30   0.30   0.30 ];

fnt = 'Helvetica';

%% ── Figure ───────────────────────────────────────────────────────────────
fig = figure('Color','w','Units','centimeters','Position',[2 2 30 22], ...
             'Name','3D Mesh Independence Study — Model 2');
tl = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
title(tl,'3D Mesh Independence Study — Model 1', ...
    'FontSize',22,'FontWeight','bold','FontName',fnt);
subtitle(tl,'AR = 10  |  RANS CFD  |  Successive mesh refinement', ...
    'FontSize',18,'FontName',fnt,'Color',col_txt);

%% ── Panel 1: Lift convergence ────────────────────────────────────────────
ax1 = nexttile(1);
hold(ax1,'on'); box(ax1,'on'); grid(ax1,'on');
ax1.GridColor      = col_grid;
ax1.MinorGridAlpha = 0.06;
ax1.FontSize       = 14;
ax1.FontName       = fnt;
ax1.LineWidth      = 0.9;
ax1.XTick          = x;
ax1.XTickLabel     = meshID;
ax1.XLim           = [0.6  4.4];
grid(ax1,'minor');

fill(ax1, [x fliplr(x)], ...
    [lift ones(1,numel(x))*(min(lift)-0.4)], ...
    col_lift, 'FaceAlpha',0.07, 'EdgeColor','none');

plot(ax1, x, lift, '-o', ...
    'Color',col_lift, 'LineWidth',2.8, 'MarkerSize',9, ...
    'MarkerFaceColor',col_lift);

for i = 2:numel(x)
    text(ax1, x(i), lift(i) + 0.15, ...
        sprintf('\\Delta = %.2f%%', lift_diff(i)), ...
        'FontSize',16, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',col_lift, 'FontWeight','bold');
end

for i = 1:numel(x)
    text(ax1, x(i), min(lift)-0.32, ...
        sprintf('%.2fM', elements(i)/1e6), ...
        'FontSize',15, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',[0.5 0.5 0.5]);
end

ylabel(ax1, 'Lift (N)', 'FontSize',20, 'FontName',fnt);
xlabel(ax1, 'Mesh ID',  'FontSize',20, 'FontName',fnt);
title(ax1,  'Lift Convergence', 'FontSize',15, 'FontName',fnt, 'FontWeight','bold');
ax1.YLim = [min(lift)-0.6  max(lift)+0.6];

%% ── Panel 2: Drag convergence ────────────────────────────────────────────
ax2 = nexttile(2);
hold(ax2,'on'); box(ax2,'on'); grid(ax2,'on');
ax2.GridColor      = col_grid;
ax2.MinorGridAlpha = 0.06;
ax2.FontSize       = 14;
ax2.FontName       = fnt;
ax2.LineWidth      = 0.9;
ax2.XTick          = x;
ax2.XTickLabel     = meshID;
ax2.XLim           = [0.6  4.4];
grid(ax2,'minor');

fill(ax2, [x fliplr(x)], ...
    [drag ones(1,numel(x))*(min(drag)-0.05)], ...
    col_drag, 'FaceAlpha',0.07, 'EdgeColor','none');

plot(ax2, x, drag, '-s', ...
    'Color',col_drag, 'LineWidth',2.8, 'MarkerSize',9, ...
    'MarkerFaceColor',col_drag);

for i = 2:numel(x)
    text(ax2, x(i), drag(i) + 0.05, ...
        sprintf('\\Delta = %.2f%%', drag_diff(i)), ...
        'FontSize',16, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',col_drag, 'FontWeight','bold');
end

for i = 1:numel(x)
    text(ax2, x(i), min(drag)-0.04, ...
        sprintf('%.2fM', elements(i)/1e6), ...
        'FontSize',14, 'FontName',fnt, ...
        'HorizontalAlignment','center', 'Color',[0.5 0.5 0.5]);
end

ylabel(ax2, 'Drag (N)', 'FontSize',16, 'FontName',fnt);
xlabel(ax2, 'Mesh ID',  'FontSize',16, 'FontName',fnt);
title(ax2,  'Drag Convergence', 'FontSize',15, 'FontName',fnt, 'FontWeight','bold');
ax2.YLim = [min(drag)-0.15  max(drag)+0.25];

%% ── Panel 3: Percentage change bar chart ─────────────────────────────────
ax3 = nexttile(3, [1 2]);
hold(ax3,'on'); box(ax3,'on'); grid(ax3,'on');
ax3.GridColor      = col_grid;
ax3.FontSize       = 14;
ax3.FontName       = fnt;
ax3.LineWidth      = 0.9;
grid(ax3,'minor');

xb = [1 2 3];
bw = 0.30;

bL = bar(ax3, xb - bw/2, ld, bw, ...
    'FaceColor',col_lift, 'EdgeColor','none', 'FaceAlpha',0.88);
bD = bar(ax3, xb + bw/2, dd, bw, ...
    'FaceColor',col_drag, 'EdgeColor','none', 'FaceAlpha',0.88);

% ── Value labels computed directly from ld/dd arrays ─────────────────────
offset = max(dd) * 0.025;   % 2.5% of the tallest bar – scales automatically
for i = 1:3
    text(ax3, xb(i) - bw/2, ld(i) + offset, ...
        sprintf('%.2f%%', ld(i)), ...
        'FontSize',16, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_lift);

    text(ax3, xb(i) + bw/2, dd(i) + offset, ...
        sprintf('%.2f%%', dd(i)), ...
        'FontSize',16, 'FontName',fnt, 'FontWeight','bold', ...
        'HorizontalAlignment','center', 'Color',col_drag);
end

% 1% convergence threshold line
yline(ax3, 1.0, '--', 'LineWidth',1.6, 'Color',[0.4 0.4 0.4], ...
    'Label','  1% convergence threshold', ...
    'LabelHorizontalAlignment','left', ...
    'FontSize',16, 'FontName',fnt);

labels_pct = {'DP 0 \rightarrow DP 1', ...
               'DP 1 \rightarrow DP 2', ...
               'DP 2 \rightarrow DP 3'};

ax3.XTick      = xb;
ax3.XTickLabel = labels_pct;
ax3.XLim       = [0.4   3.6];
ax3.YLim       = [0     max(dd) * 1.18];   % headroom above tallest bar

ylabel(ax3, 'Successive Change (%)', 'FontSize',20, 'FontName',fnt);
xlabel(ax3, 'Mesh Transition',       'FontSize',20, 'FontName',fnt);
title(ax3, 'Successive Percentage Change in Lift & Drag', ...
    'FontSize',22, 'FontName',fnt, 'FontWeight','bold');

leg = legend(ax3, [bL bD], {'Lift','Drag'}, ...
    'Location','northeast', 'FontSize',14, 'FontName',fnt, ...
    'Box','on', 'EdgeColor',[0.78 0.78 0.78]);
leg.Title.String    = 'Force';
leg.Title.FontSize  = 17;
leg.Title.FontWeight = 'bold';

