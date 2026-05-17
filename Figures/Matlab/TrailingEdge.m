%% Trailing Edge Conceptual Illustration — clean version
clear; clc; close all;

% -------------------------------------------------------------------------
% NACA 4415 normalised coordinates
% -------------------------------------------------------------------------
naca_coords = [
1.00000  0.00000; 0.99893  0.00039; 0.99572  0.00156; 0.99039  0.00349;
0.98296  0.00610; 0.97347  0.00932; 0.96194  0.01303; 0.94844  0.01716;
0.93301  0.02166; 0.91573  0.02652; 0.89668  0.03171; 0.87592  0.03717;
0.85355  0.04283; 0.82967  0.04863; 0.80438  0.05453; 0.77779  0.06048;
0.75000  0.06642; 0.72114  0.07227; 0.69134  0.07795; 0.66072  0.08341;
0.62941  0.08858; 0.59755  0.09341; 0.56526  0.09785; 0.53270  0.10185;
0.50000  0.10538; 0.46730  0.10837; 0.43474  0.11076; 0.40245  0.11248;
0.37059  0.11345; 0.33928  0.11361; 0.30866  0.11294; 0.27886  0.11141;
0.25000  0.10903; 0.22221  0.10584; 0.19562  0.10190; 0.17033  0.09726;
0.14645  0.09195; 0.12408  0.08607; 0.10332  0.07970; 0.08427  0.07283;
0.06699  0.06541; 0.05156  0.05753; 0.03806  0.04937; 0.02653  0.04118;
0.01704  0.03303; 0.00961  0.02489; 0.00428  0.01654; 0.00107  0.00825;
0.00000  0.00075; 0.00107 -0.00566; 0.00428 -0.01102; 0.00961 -0.01590;
0.01704 -0.02061; 0.02653 -0.02502; 0.03806 -0.02915; 0.05156 -0.03281;
0.06699 -0.03582; 0.08427 -0.03817; 0.10332 -0.03991; 0.12408 -0.04106;
0.14645 -0.04166; 0.17033 -0.04177; 0.19562 -0.04147; 0.22221 -0.04078;
0.25000 -0.03974; 0.27886 -0.03845; 0.30866 -0.03700; 0.33928 -0.03547;
0.37059 -0.03390; 0.40245 -0.03229; 0.43474 -0.03063; 0.46730 -0.02891;
0.50000 -0.02713; 0.53270 -0.02529; 0.56526 -0.02340; 0.59755 -0.02149;
0.62941 -0.01958; 0.66072 -0.01772; 0.69134 -0.01596; 0.72114 -0.01430;
0.75000 -0.01277; 0.77779 -0.01136; 0.80438 -0.01006; 0.82967 -0.00886;
0.85355 -0.00775; 0.87592 -0.00674; 0.89668 -0.00583; 0.91573 -0.00502;
0.93301 -0.00431; 0.94844 -0.00364; 0.96194 -0.00297; 0.97347 -0.00227;
0.98296 -0.00156; 0.99039 -0.00092; 0.99572 -0.00042; 0.99893 -0.00011;
1.00000  0.00000];

chord = 318; % [mm]

xn = naca_coords(:,1) * chord;
yn = naca_coords(:,2) * chord;

[~, le_n]  = min(xn);
xn_u = flip(xn(1:le_n));
yn_u = flip(yn(1:le_n));
xn_l = xn(le_n:end);
yn_l = yn(le_n:end);

xq = linspace(0, chord, 3000);
yu_base = interp1(xn_u, yn_u, xq, 'pchip');
yl_base = interp1(xn_l, yn_l, xq, 'pchip');

% -------------------------------------------------------------------------
% Optimised: smooth drooped trailing edge from 72% chord
% Upper surface barely moves, lower surface drops more — classic camber droop
% -------------------------------------------------------------------------
x_droop_start = 0.72 * chord;
droop_upper   = -1.8;   % mm — subtle upper droop
droop_lower   = -6.5;   % mm — more pronounced lower droop

blend = zeros(size(xq));
idx   = xq >= x_droop_start;
t     = (xq(idx) - x_droop_start) / (chord - x_droop_start);
blend(idx) = (1 - cos(pi * t)) / 2;

yu_opt = yu_base + droop_upper * blend;
yl_opt = yl_base + droop_lower * blend;

% -------------------------------------------------------------------------
% Crop to show x = 0.68c → slightly past TE tip
% -------------------------------------------------------------------------
x_start = 0.68 * chord;
x_end   = chord + 6;    % show a few mm past TE so tip is clearly visible
mask    = xq >= x_start & xq <= chord;
xp      = xq(mask);

yu_b = yu_base(mask);
yl_b = yl_base(mask);
yu_o = yu_opt(mask);
yl_o = yl_opt(mask);

% -------------------------------------------------------------------------
% PLOT
% -------------------------------------------------------------------------
figure('Color','w','Units','pixels','Position',[100 100 950 430]);
hold on;

% Draw NACA 4415 first (behind) — grey filled
fill([xp, fliplr(xp)], [yu_b, fliplr(yl_b)], ...
    [0.78 0.78 0.78], 'EdgeColor','none', 'FaceAlpha', 0.55);
plot(xp, yu_b, '-', 'Color',[0.45 0.45 0.45], 'LineWidth', 2.2);
plot(xp, yl_b, '-', 'Color',[0.45 0.45 0.45], 'LineWidth', 2.2);

% Draw Optimised on top — blue filled
fill([xp, fliplr(xp)], [yu_o, fliplr(yl_o)], ...
    [0.78 0.90 0.97], 'EdgeColor','none', 'FaceAlpha', 0.80);
plot(xp, yu_o, 'k-', 'LineWidth', 2.5);
plot(xp, yl_o, 'k-', 'LineWidth', 2.5);

% TE tip markers — dot at each trailing edge tip
plot(chord, yu_base(end), 'o', 'MarkerSize', 6, ...
    'MarkerFaceColor',[0.45 0.45 0.45], 'MarkerEdgeColor','none');
plot(chord, yl_base(end), 'o', 'MarkerSize', 6, ...
    'MarkerFaceColor',[0.45 0.45 0.45], 'MarkerEdgeColor','none');
plot(chord, yu_opt(end), 'o', 'MarkerSize', 6, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','none');
plot(chord, yl_opt(end), 'o', 'MarkerSize', 6, ...
    'MarkerFaceColor','k', 'MarkerEdgeColor','none');



% Labels
text(0.695*chord, 10, 'NACA 4415', ...
    'FontSize', 15, 'FontWeight', 'bold', 'Color', [0.40 0.40 0.40]);
text(0.695*chord, -9, 'General C_L Optimisation', ...
    'FontSize', 15, 'FontWeight', 'bold', 'Color', [0.05 0.35 0.62]);


% -------------------------------------------------------------------------
% Clean formatting
% -------------------------------------------------------------------------
axis equal;
axis off;

xlim([x_start - 4,  x_end]);
ylim([-chord*0.075, chord*0.075]);

title('Trailing Edge Profile Comparison', ...
    'FontSize', 20, 'FontWeight', 'bold', 'Color', 'k');

hold off;