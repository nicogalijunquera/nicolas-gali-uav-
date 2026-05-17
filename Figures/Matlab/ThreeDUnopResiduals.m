clear; clc; close all;

%% File path (UPDATED for your system)
filename = 'C:/Users/joaqu/OneDrive - Brunel University London/TERM 5 & 6/DISSERTATION/3D/my_residuals.txt';

%% Read file
fid = fopen(filename,'r');
raw = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
raw = raw{1};

%% Function to extract residuals
function [iter, values] = extract_residual(raw, varname)
    start_idx = find(contains(raw, ['"' varname '"']));
    
    data = [];
    for i = start_idx+1:length(raw)
        line = strtrim(raw{i});
        
        % Stop when next block starts
        if isempty(line) || contains(line,'((')
            break
        end
        
        nums = sscanf(line,'%f %f');
        if length(nums)==2
            data = [data; nums'];
        end
    end
    
    iter = data(:,1);
    values = data(:,2);
end

%% Extract variables
[it_c, cont] = extract_residual(raw,'continuity');
[it_u, ux]   = extract_residual(raw,'x-velocity');
[it_v, uy]   = extract_residual(raw,'y-velocity');
[it_k, k]    = extract_residual(raw,'k');
[it_w, omg]  = extract_residual(raw,'omega');

%% Plot residuals
figure;

semilogy(it_c, cont, 'LineWidth',4); hold on;
semilogy(it_u, ux,   'LineWidth',4);
semilogy(it_v, uy,   'LineWidth',4);
semilogy(it_k, k,    'LineWidth',4);
semilogy(it_w, omg,  'LineWidth',4);

grid on;
xlabel('Iterations','FontSize',40);
ylabel('Residual (log scale)','FontSize',40);

legend('Continuity','X-Velocity','Y-Velocity','k','\omega',...
    'Location','southwest');

title('CFD Residual Convergence History','FontSize',20);

set(gca,'FontSize',18);

%% Optional: improve axis limits
xlim([0 max(it_c)])

%% Optional: save high-quality figure
exportgraphics(gcf,'residuals_plot.png','Resolution',300);