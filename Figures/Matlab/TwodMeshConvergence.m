clear; clc; close all;

% Data
CL = [0.42467824, 0.42825769, 0.42229139, 0.42201287];
CD = [0.010849602, 0.010116886, 0.010312725, 0.010308971];

mesh_levels = {'Coarse','Medium','Fine','Very Fine'};
x = 1:length(mesh_levels);

% Create figure
figure('Color','w','Position',[200 200 900 520])

% ---- CL axis ----
yyaxis left
plot(x, CL,'-o','LineWidth',2,'MarkerSize',7)
ylabel('Lift Coefficient, C_L')
ylim([0.4218 0.4305])

% ---- CD axis ----
yyaxis right
plot(x, CD,'-s','LineWidth',2,'MarkerSize',7)
ylabel('Drag Coefficient, C_D')
ylim([0.0101 0.0109])

% Axis formatting
xticks(x)
xticklabels(mesh_levels)
xlabel('Mesh Resolution')

title('2D Mesh Independence Study')
grid on
set(gca,'FontSize',12,'LineWidth',1.2)

% Add point labels
yyaxis left
for i = 1:length(CL)
    text(x(i),CL(i),['  ' mesh_levels{i}],...
        'FontSize',10,'VerticalAlignment','bottom')
end

% Save figure
exportgraphics(gcf,'mesh_independence_2D.png','Resolution',600)
exportgraphics(gcf,'mesh_independence_2D.pdf','ContentType','vector')