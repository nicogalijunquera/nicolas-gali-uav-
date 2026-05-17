% Clear workspace
clear; clc; close all;

% Create a generic range
V = linspace(0.15, 1, 1000); 

% Normalized constants for the "Perfect U" balance
Dp = 0.5 * V.^2;      % Parasite Drag
Di = 0.01 ./ V.^2;    % Induced Drag
Dt = Dp + Di;         % Total Drag

% Find the minimum point for dashed lines
[minD, idx] = min(Dt);
Vmd = V(idx);

% --- Plotting ---
figure('Color', 'w', 'Units', 'inches', 'Position', [1, 1, 10, 7]);
hold on; grid on;

% Plot curves
p_ind = plot(V, Di, 'Color', [0.85 0.33 0.1], 'LineWidth', 3, 'DisplayName', 'Induced Drag');
p_par = plot(V, Dp, 'Color', [0 0.45 0.74], 'LineWidth', 3, 'DisplayName', 'Parasite Drag');
p_tot = plot(V, Dt, 'k', 'LineWidth', 4, 'DisplayName', 'Total Drag');

% Dashed lines for Min Drag Point
line([Vmd Vmd], [0 minD], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 2, 'HandleVisibility', 'off');
line([0 Vmd], [minD minD], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 2, 'HandleVisibility', 'off');

% --- Legend (Bigger Font) ---
lgd = legend('Location', 'northeast');
set(lgd, 'FontSize', 16, 'FontWeight', 'bold');

% --- Proportionality Boxes (Fixed Subscripts and Bigger Font) ---
% Note: Using 'Interpreter', 'latex' ensures fractions and subscripts look perfect
text(0.75, 0.3, '$D_p \propto V^2$', 'FontSize', 22, 'Color', [0 0.45 0.74], ...
    'FontWeight', 'bold', 'EdgeColor', [0 0.45 0.74], 'LineWidth', 2, ...
    'BackgroundColor', [1 1 1 0.8], 'Margin', 8, 'Interpreter', 'latex');

text(0.25, 0.25, '$D_i \propto \frac{1}{V^2}$', 'FontSize', 22, 'Color', [0.85 0.33 0.1], ...
    'FontWeight', 'bold', 'EdgeColor', [0.85 0.33 0.1], 'LineWidth', 2, ...
    'BackgroundColor', [1 1 1 0.8], 'Margin', 8, 'Interpreter', 'latex');

% --- Axis Labels and Title (Bigger Font) ---
xlabel('Airspeed ($V$) $\rightarrow$', 'FontSize', 20, 'Interpreter', 'latex');
ylabel('Drag ($D$) $\rightarrow$', 'FontSize', 20, 'Interpreter', 'latex');
title('Conceptual Aerodynamic Drag Relationships', 'FontSize', 24, 'FontWeight', 'bold');

% Remove numbers and clean up axes
set(gca, 'XTick', [], 'YTick', [], 'Box', 'off', 'LineWidth', 1.5);
axis([0 1.05 0 0.5]);

% --- Custom Axis Markers (Bigger Font) ---
text(Vmd, -0.02, '$V_{md}$', 'HorizontalAlignment', 'center', 'FontSize', 22, 'Interpreter', 'latex');
text(-0.02, minD, '$D_{min}$', 'HorizontalAlignment', 'right', 'FontSize', 22, 'Interpreter', 'latex');

hold off;