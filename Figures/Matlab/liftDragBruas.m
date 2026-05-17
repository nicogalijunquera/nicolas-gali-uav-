%% BrUAS 2022 aerodynamic analysis: Lift & Drag vs Iterations (dual axis)
% Excel file must contain columns named exactly:
% ITERATION | LIFT | DRAG

% ====== PLACEHOLDER: set your Excel file path here ======
filePath = 'C:\PATH\TO\YOUR\FILE.xlsx';   % <-- change this

% --- Read data ---
T = readtable(filePath);

iter = T.ITERATION;
lift = T.LIFT;
drag = T.DRAG;

% --- Converged values (last iteration assumed converged) ---
L_conv = lift(end);
D_conv = drag(end);
LD_conv = L_conv / D_conv;

% --- Compute axis margins (5%) ---
lift_margin = 0.05 * (max(lift) - min(lift));
drag_margin = 0.05 * (max(drag) - min(drag));

% --- Plot ---
figure('Color','w'); hold on; grid on;

% ----- Lift (left axis) -----
yyaxis left
hL = plot(iter, lift, 'LineWidth', 1.6);
ylabel('Lift')
ylim([min(lift)-lift_margin , max(lift)+lift_margin])

% ----- Drag (right axis) -----
yyaxis right
hD = plot(iter, drag, 'LineWidth', 1.6);
ylabel('Drag')
ylim([min(drag)-drag_margin , max(drag)+drag_margin])

xlabel('Iteration')
title('BrUAS 2022 Aerodynamic Analysis: Lift and Drag Convergence')

% --- Legend with converged values + L/D ---
legendTextL = sprintf('Lift (conv = %.6g)', L_conv);
legendTextD = sprintf('Drag (conv = %.6g)  |  L/D = %.6g', D_conv, LD_conv);

legend([hL, hD], {legendTextL, legendTextD}, 'Location', 'best');

set(gca,'FontSize',11);
box on;
