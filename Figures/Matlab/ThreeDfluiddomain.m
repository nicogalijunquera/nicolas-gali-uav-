clear; clc; close all;

% =========================================================================
% FIGURE 1: 3D CFD DOMAIN WITH BOUNDARY CONDITIONS AND DIMENSIONS
% =========================================================================
figure('Color','w','Units','pixels','Position',[50 50 1100 800],'Name','Figure 1: 3D CFD Domain');
hold on; axis equal; view(3); grid on;
chord_val = 1; % Normalized chord for dimensioning

% Set domain size based on "10c" rule from LE/TE/Tip
up_dist = 10 * chord_val;   % Upstream of LE
down_dist = 10 * chord_val; % Downstream of TE
wing_span = 1 * chord_val;   % Physical span (e.g., c=1)
vert_dist = 10 * chord_val;  % Above/Below
far_dist = 10 * chord_val;   % Farfield (spanwise)

x_domain = [-up_dist, down_dist + chord_val];
y_domain = [-vert_dist, vert_dist];
z_domain = [0, far_dist];

% 1. Create a simplified, slightly thicker wing schematic
t = linspace(0, 2*pi, 80);
x_airfoil = (cos(t)+1)/2 * chord_val;
y_airfoil = 0.2*(0.2969*sqrt(x_airfoil/chord_val) - 0.1260*(x_airfoil/chord_val) - 0.3516*(x_airfoil/chord_val).^2 + 0.2843*(x_airfoil/chord_val).^3 - 0.1015*(x_airfoil/chord_val).^4);
[X, Z] = meshgrid(x_airfoil, [0 wing_span]);
[Y, ~] = meshgrid(y_airfoil, [0 wing_span]);
% Root color (Gray - on Symm wall)
patch(X(:,1), Y(:,1), Z(:,1), [0.6 0.6 0.6], 'EdgeColor', 'k', 'LineWidth', 1.5);
% Surface color (Orange)
surf(X, Y, Z, 'FaceColor', [1 0.5 0], 'EdgeColor', 'none', 'FaceAlpha', 0.9);

% 2. Create Domain Box Walls with requested colors
% Inlet (Red - Face at -up_dist)
patch([x_domain(1) x_domain(1) x_domain(1) x_domain(1)], [y_domain(1) y_domain(2) y_domain(2) y_domain(1)], [z_domain(1) z_domain(1) z_domain(2) z_domain(2)], ...
    [1 0 0], 'FaceAlpha', 0.3, 'EdgeColor', 'r', 'LineWidth', 1.5, 'DisplayName', 'Inlet');

% Symmetry Plane (Gray - Plane at z=0)
patch([x_domain(1) x_domain(2) x_domain(2) x_domain(1)], [y_domain(1) y_domain(1) y_domain(2) y_domain(2)], [z_domain(1) z_domain(1) z_domain(1) z_domain(1)], ...
    [0.7 0.7 0.7], 'FaceAlpha', 0.5, 'EdgeColor', [0.4 0.4 0.4], 'LineWidth', 1.5, 'DisplayName', 'Symmetry Plane (Root)');

% Outlet (Blue - Face at +down_dist+c)
patch([x_domain(2) x_domain(2) x_domain(2) x_domain(2)], [y_domain(1) y_domain(2) y_domain(2) y_domain(1)], [z_domain(1) z_domain(1) z_domain(2) z_domain(2)], ...
    [0 0 1], 'FaceAlpha', 0.3, 'EdgeColor', 'b', 'LineWidth', 1.5, 'DisplayName', 'Outlet');

% Wireframe of boundaries only for other walls
line([x_domain(1) x_domain(2) x_domain(2) x_domain(1) x_domain(1)], [y_domain(2) y_domain(2) y_domain(1) y_domain(1) y_domain(2)], [z_domain(2) z_domain(2) z_domain(2) z_domain(2) z_domain(2)], 'Color', [0.5 0.5 0.5]);
line([x_domain(1) x_domain(1)], [y_domain(1) y_domain(1)], [0 z_domain(2)], 'Color', [0.5 0.5 0.5]);
line([x_domain(2) x_domain(2)], [y_domain(1) y_domain(1)], [0 z_domain(2)], 'Color', [0.5 0.5 0.5]);
line([x_domain(1) x_domain(1)], [y_domain(2) y_domain(2)], [0 z_domain(2)], 'Color', [0.5 0.5 0.5]);
line([x_domain(2) x_domain(2)], [y_domain(2) y_domain(2)], [0 z_domain(2)], 'Color', [0.5 0.5 0.5]);

% 3. Draw Dimension Arrows and Labels (10c)
arr_color = 'r'; arr_width = 2; font_dim = 14;

% D1: Leading Edge to Inlet
quiver3(0,0,0, -up_dist, 0, 0, 'Color', arr_color, 'LineWidth', arr_width, 'MaxHeadSize', 0.1);
text(-up_dist/2, 0.2*chord_val, 0, '10c', 'Color', arr_color, 'FontSize', font_dim, 'FontWeight', 'bold');

% D2: Trailing Edge to Outlet
quiver3(chord_val,0,0, down_dist, 0, 0, 'Color', arr_color, 'LineWidth', arr_width, 'MaxHeadSize', 0.1);
text(chord_val + down_dist/2, 0.2*chord_val, 0, '10c', 'Color', arr_color, 'FontSize', font_dim, 'FontWeight', 'bold');

% D3: LE to Upper Sky
quiver3(0,0,0, 0, vert_dist, 0, 'Color', arr_color, 'LineWidth', arr_width, 'MaxHeadSize', 0.1);
text(0.1*chord_val, vert_dist/2, 0, '10c', 'Color', arr_color, 'FontSize', font_dim, 'FontWeight', 'bold');

% D4: TE to Ground
quiver3(chord_val,0,0, 0, -vert_dist, 0, 'Color', arr_color, 'LineWidth', arr_width, 'MaxHeadSize', 0.1);
text(chord_val+0.1*chord_val, -vert_dist/2, 0, '10c', 'Color', arr_color, 'FontSize', font_dim, 'FontWeight', 'bold');

% D5: LE to Farfield (spanwise)
quiver3(0,0,0, 0, 0, far_dist, 'Color', arr_color, 'LineWidth', arr_width, 'MaxHeadSize', 0.1);
text(0.1*chord_val, 0, far_dist/2, '10c', 'Color', arr_color, 'FontSize', font_dim, 'FontWeight', 'bold');

% Formatting Figure 1
title('CFD Domain Boundary Conditions and Dimensions (10c Rule)', 'FontSize', 18, 'FontWeight', 'bold');
xlabel('x (Streamwise) [c]', 'FontSize', 12); ylabel('y (Vertical) [c]', 'FontSize', 12); zlabel('z (Spanwise) [c]', 'FontSize', 12);
set(gca, 'FontSize', 12, 'LineWidth', 1.5);
lgd1 = legend('Location', 'southoutside', 'FontSize', 11, 'Orientation', 'horizontal');
axis([x_domain y_domain z_domain]);

% =========================================================================
% FIGURE 2: CONCEPTUAL AERODYNAMIC DRAG POLAR (With Wing and Proper Math)
% =========================================================================
figure('Color', 'w', 'Units', 'pixels', 'Position', [100 100 1100 700], 'Name', 'Figure 2: Drag Polar');
hold on; grid on;

% Create Normalized Data
V = linspace(0.1, 1.0, 1000);
Dp = 0.55 * V.^2;
Di = 0.01 ./ V.^2;
Dt = Dp + Di;

% Find Min Drag Point
[minD, idx] = min(Dt);
Vmd = V(idx);

% Plot Lines
p_tot = plot(V, Dt, 'k', 'LineWidth', 4, 'DisplayName', 'Total Drag');
p_ind = plot(V, Di, 'Color', [0.85 0.33 0.1], 'LineWidth', 3, 'DisplayName', 'Induced Drag');
p_par = plot(V, Dp, 'Color', [0 0.45 0.74], 'LineWidth', 3, 'DisplayName', 'Parasite Drag');

% Dashed lines for Vmd
plot([Vmd Vmd], [0 minD], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot([0 Vmd], [minD minD], 'Color', [0.5 0.5 0.5], 'LineStyle', '--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Proportionality Boxes (Fixed math formatting)
text(0.75, 0.30, '$D_p \propto V^2$', 'FontSize', 18, 'Color', [0 0.45 0.74], 'EdgeColor', [0 0.45 0.74], 'LineWidth', 2, ...
    'BackgroundColor', [1 1 1 0.8], 'Margin', 8, 'Interpreter', 'latex', 'FontWeight', 'bold');
text(0.25, 0.35, '$D_i \propto \frac{1}{V^2}$', 'FontSize', 18, 'Color', [0.85 0.33 0.1], 'EdgeColor', [0.85 0.33 0.1], 'LineWidth', 2, ...
    'BackgroundColor', [1 1 1 0.8], 'Margin', 8, 'Interpreter', 'latex', 'FontWeight', 'bold');

% --- NEW: Wing Schematic in Bottom Right ---
w_x = 0.70; w_y = 0.02; w_w = 0.25; w_h = 0.12;
annotation('rectangle', [w_x w_y w_w w_h], 'FaceColor', 'none', 'EdgeColor', [0.5 0.5 0.5]);
axes('Position', [w_x w_y w_w w_h], 'Visible', 'off'); hold on;
% Draw wing schematic (Top view)
patch([0.1 0.1 0.9 0.9], [0.3 0.7 0.7 0.3], [1 0.5 0], 'EdgeColor', 'k', 'LineWidth', 1);
plot([0.1 0.1], [0.2 0.8], 'Color', [0.6 0.6 0.6], 'LineWidth', 3); % Symm
line([0.9 0.9], [0.2 0.8], 'Color', [0.5 0.5 0.5]); % Tip
quiver(0.3, 0.5, 0.4, 0, 'Color', 'k', 'LineWidth', 1, 'MaxHeadSize', 1); % Airflow
text(0.4, 0.10, 'Root (Symm.)', 'HorizontalAlignment', 'right', 'FontSize', 10);
text(1.0, 0.10, 'Tip (Farfield)', 'HorizontalAlignment', 'left', 'FontSize', 10);
text(0.5, 0.90, 'Airflow V', 'HorizontalAlignment', 'center', 'FontSize', 10);
text(0.5, 0.50, 'WING', 'HorizontalAlignment', 'center', 'FontSize', 11, 'Color', 'k', 'FontWeight', 'bold');
% Revert to main axes
axes(gcf, 'CurrentAxes', findobj(gcf, 'Type', 'axes', 'Tag', 'MainAxesTag'));

% Formatting Figure 2
title('Conceptual Aerodynamic Drag Relationships', 'FontSize', 22, 'FontWeight', 'bold');
xlabel('Airspeed (V) $\rightarrow$', 'FontSize', 18, 'Interpreter', 'latex');
ylabel('Drag (D) $\rightarrow$', 'FontSize', 18, 'Interpreter', 'latex');
set(gca, 'XTick', [], 'YTick', [], 'Box', 'off', 'LineWidth', 1.5, 'Tag', 'MainAxesTag');
axis([0 1.05 0 0.55]);
text(Vmd, -0.02, '$V_{md}$', 'HorizontalAlignment', 'center', 'FontSize', 20, 'Interpreter', 'latex');
text(-0.02, minD, '$D_{min}$', 'HorizontalAlignment', 'right', 'FontSize', 20, 'Interpreter', 'latex');
lgd2 = legend('Location', 'northeast', 'FontSize', 14); lgd2.ItemTokenSize = [30 18]; lgd2.FontWeight = 'bold';

hold off;