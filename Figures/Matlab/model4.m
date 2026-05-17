%% 3D Mesh Independence Study – Model 4: AR=10 + Optimised Aerofoil
%  Lift and Drag convergence with successive percentage change annotations
%  Data source: Ansys Meshing parameter study
% -------------------------------------------------------------------------
clear; clc; close all;

%% ── Data ─────────────────────────────────────────────────────────────────
meshID   = {'DP 0','DP 1','DP 2','DP 3'};
elements = [2522556,   5107552,  9028753,  12487903];
drag     = [8.1889765, 6.9729135, 6.5740629, 6.5241];
lift     = [142.148,   138.552,   136.349,   135.640];
x        = 1:numel(meshID);

%% ── Successive percentage differences ───────────────────────────────────
drag_diff = nan(size(drag));
lift_diff = nan(size(lift));
for i = 2:numel(drag)
    drag_diff(i) = abs((drag(i)-drag(i-1))/drag(i-1))*100;
    lift_diff(i) = abs((lift(i)-lift(i-1))/lift(i-1))*100;
end
ld = lift_diff(2:end);
dd = drag_diff(2:end);

fprintf('==============================================\n');
fprintf('  Model 4 — AR=10 + Optimised Aerofoil\n');
fprintf('==============================================\n');
fprintf('  DP0->DP1 :  Lift %.4f%%   Drag %.4f%%\n', ld(1), dd(1));
fprintf('  DP1->DP2 :  Lift %.4f%%   Drag %.4f%%\n', ld(2), dd(2));
fprintf('  DP2->DP3 :  Lift %.4f%%   Drag %.4f%%\n', ld(3), dd(3));
fprintf('==============================================\n\n');

%% ── Colour palette ───────────────────────────────────────────────────────
col_lift = [0.216  0.541  0.867];
col_drag = [0.847  0.353  0.188];
col_grid = [0.88   0.88   0.88 ];
col_txt  = [0.30   0.30   0.30 ];
fnt      = 'Helvetica';

%% ── Figure ───────────────────────────────────────────────────────────────
fig = figure('Color','w','Units','centimeters','Position',[2 2 30 22], ...
             'Name','3D Mesh Independence Study — Model 4');
tl = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');
title(tl,'3D Mesh Independence Study — Model 4', ...
    'FontSize',22,'FontWeight','bold','FontName',fnt);
subtitle(tl,'AR = 10 + Optimised Aerofoil  |  RANS CFD  |  Successive mesh refinement', ...
    'FontSize',18,'FontName',fnt,'Color',col_txt);

ax1 = nexttile(1);
hold(ax1,'on'); box(ax1,'on'); grid(ax1,'on');
ax1.GridColor=col_grid; ax1.MinorGridAlpha=0.06; ax1.FontSize=14;
ax1.FontName=fnt; ax1.LineWidth=0.9; ax1.XTick=x;
ax1.XTickLabel=meshID; ax1.XLim=[0.6 4.4]; grid(ax1,'minor');
fill(ax1,[x fliplr(x)],[lift ones(1,4)*(min(lift)-0.4)], ...
    col_lift,'FaceAlpha',0.07,'EdgeColor','none');
plot(ax1,x,lift,'-o','Color',col_lift,'LineWidth',2.8, ...
    'MarkerSize',9,'MarkerFaceColor',col_lift);
for i=2:4
    text(ax1,x(i),lift(i)+0.18,sprintf('\\Delta = %.2f%%',lift_diff(i)), ...
        'FontSize',16,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',col_lift);
end
for i=1:4
    text(ax1,x(i),min(lift)-0.35,sprintf('%.2fM',elements(i)/1e6), ...
        'FontSize',15,'FontName',fnt,'HorizontalAlignment','center','Color',[0.5 0.5 0.5]);
end
ylabel(ax1,'Lift (N)','FontSize',20,'FontName',fnt);
xlabel(ax1,'Mesh ID','FontSize',20,'FontName',fnt);
title(ax1,'Lift Convergence','FontSize',15,'FontName',fnt,'FontWeight','bold');
ax1.YLim=[min(lift)-0.7 max(lift)+0.7];

ax2 = nexttile(2);
hold(ax2,'on'); box(ax2,'on'); grid(ax2,'on');
ax2.GridColor=col_grid; ax2.MinorGridAlpha=0.06; ax2.FontSize=14;
ax2.FontName=fnt; ax2.LineWidth=0.9; ax2.XTick=x;
ax2.XTickLabel=meshID; ax2.XLim=[0.6 4.4]; grid(ax2,'minor');
fill(ax2,[x fliplr(x)],[drag ones(1,4)*(min(drag)-0.02)], ...
    col_drag,'FaceAlpha',0.07,'EdgeColor','none');
plot(ax2,x,drag,'-s','Color',col_drag,'LineWidth',2.8, ...
    'MarkerSize',9,'MarkerFaceColor',col_drag);
for i=2:4
    text(ax2,x(i),drag(i)+0.025,sprintf('\\Delta = %.2f%%',drag_diff(i)), ...
        'FontSize',16,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',col_drag);
end
for i=1:4
    text(ax2,x(i),min(drag)-0.018,sprintf('%.2fM',elements(i)/1e6), ...
        'FontSize',15,'FontName',fnt,'HorizontalAlignment','center','Color',[0.5 0.5 0.5]);
end
ylabel(ax2,'Drag (N)','FontSize',20,'FontName',fnt);
xlabel(ax2,'Mesh ID','FontSize',20,'FontName',fnt);
title(ax2,'Drag Convergence','FontSize',15,'FontName',fnt,'FontWeight','bold');
ax2.YLim=[min(drag)-0.06 max(drag)+0.12];

ax3 = nexttile(3,[1 2]);
hold(ax3,'on'); box(ax3,'on'); grid(ax3,'on');
ax3.GridColor=col_grid; ax3.FontSize=14; ax3.FontName=fnt;
ax3.LineWidth=0.9; grid(ax3,'minor');
xb=[1 2 3]; bw=0.30;
bL=bar(ax3,xb-bw/2,ld,bw,'FaceColor',col_lift,'EdgeColor','none','FaceAlpha',0.88);
bD=bar(ax3,xb+bw/2,dd,bw,'FaceColor',col_drag,'EdgeColor','none','FaceAlpha',0.88);
offset=max([ld dd])*0.03;
for i=1:3
    text(ax3,xb(i)-bw/2,ld(i)+offset,sprintf('%.2f%%',ld(i)), ...
        'FontSize',16,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',col_lift);
    text(ax3,xb(i)+bw/2,dd(i)+offset,sprintf('%.2f%%',dd(i)), ...
        'FontSize',16,'FontName',fnt,'FontWeight','bold', ...
        'HorizontalAlignment','center','Color',col_drag);
end
yline(ax3,1.0,'--','LineWidth',1.6,'Color',[0.4 0.4 0.4], ...
    'Label','  1% convergence threshold', ...
    'LabelHorizontalAlignment','left','FontSize',16,'FontName',fnt);
ax3.XTick=xb;
ax3.XTickLabel={'DP 0 \rightarrow DP 1','DP 1 \rightarrow DP 2','DP 2 \rightarrow DP 3'};
ax3.XLim=[0.4 3.6]; ax3.YLim=[0 max([ld dd])*1.20];
ylabel(ax3,'Successive Change (%)','FontSize',16,'FontName',fnt);
xlabel(ax3,'Mesh Transition','FontSize',16,'FontName',fnt);
title(ax3,'Successive Percentage Change in Lift & Drag', ...
    'FontSize',15,'FontName',fnt,'FontWeight','bold');
leg=legend(ax3,[bL bD],{'Lift','Drag'},'Location','northeast', ...
    'FontSize',14,'FontName',fnt,'Box','on','EdgeColor',[0.78 0.78 0.78]);
leg.Title.String='Force'; leg.Title.FontSize=13; leg.Title.FontWeight='bold';

exportgraphics(fig,'mesh_independence_model4.png','Resolution',300);
exportgraphics(fig,'mesh_independence_model4.pdf','ContentType','vector');
fprintf('Saved mesh_independence_model4.png and .pdf\n');