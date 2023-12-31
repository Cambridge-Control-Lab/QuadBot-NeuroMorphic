dt = 1e-3;
runtime=16;
num_steps=floor(runtime/dt);

t1=2.5;
t2=220;

% Constants to vary
G = 35:2.5:45;
Tsyn = 15:2.5:25;

% Create meshgrids
[Ge_grid,Te_grid] = meshgrid(G, Tsyn);
[Gi_grid,Ti_grid] = meshgrid(G, Tsyn);

% Create empty 2D arrays to store results
excite_latency_grid = zeros(size(Ge_grid));
excite_phase_diff_grid = zeros(size(Ge_grid));
inhibit_latency_grid = zeros(size(Gi_grid));
inhibit_phase_diff_grid = zeros(size(Gi_grid));

length_G = length(Ge_grid);
length_T = length(Te_grid);


for i = 1:length_G
    g_syn = G(i);
    for j = 1:length_T
        tauSyn = Tsyn(j);
        
        % Simulate
        simOutexcite = sim('ExcitatoryConnection.slx');
        simOutinhibit = sim('InhibitoryConnection.slx');
        
        % Extract data from the simulation output
        excite_data_A = simOutexcite.spikes_A.data;
        excite_data_B = simOutexcite.spikes_B.data;
        inhibit_data_A = simOutinhibit.spikes_A.data;
        inhibit_data_B = simOutinhibit.spikes_B.data;
        
        [excite_latency, excite_phase_diff] = characterise_latency(dt, excite_data_A, excite_data_B);
        [inhibit_latency, inhibit_phase_diff] = characterise_latency(dt, inhibit_data_A, inhibit_data_B);

        % Store the computed values in the grid
        excite_latency_grid(j, i) = excite_latency;
        excite_phase_diff_grid(j, i) = excite_phase_diff;
        inhibit_latency_grid(j, i) = inhibit_latency;
        inhibit_phase_diff_grid(j, i) = inhibit_phase_diff;
    end
end

% Plotting all the contour plots in one figure

% Create a new figure
figure('Position', [100, 100, 800, 800]);

subplot(1, 2, 1);
contourf(Ge_grid, Te_grid, excite_latency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Excitatory Conductance, g\_syn\_excitatory');
ylabel('Excitatory Time Constant, tauSyn\_excitatory');
title('Excitatory Connection Burst Latency (s)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(1, 2, 2);
contourf(Ge_grid, Te_grid, excite_phase_diff_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Excitatory Conductance, g\_syn\_excitatory');
ylabel('Excitatory Time Constant, tauSyn\_excitatory');
title('Excitatory Connection Phase Difference (deg)', 'FontSize', 10, 'Interpreter', 'latex');

% Adjust the layout of subplots
sgtitle(sprintf('Excitatory Behaviour for different g_syn and $\\tau_{syn}$, ($\\tau_s = %.1f, \\tau_{us} = %.1f$)', t1, t2), 'FontSize', 14, 'Interpreter', 'latex');

% Create a new figure
figure('Position', [100, 100, 800, 800]);

subplot(1, 2, 1);
contourf(Gi_grid, Ti_grid, inhibit_latency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Inhibitory Conductance, g\_syn\_inhibitory');
ylabel('Inhibitory Time Constant, tauSyn\_inhibitory');
title('Inhibitory Connection Burst Latency (s)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(1, 2, 2);
contourf(Gi_grid, Ti_grid, inhibit_phase_diff_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Inhibitory Conductance, g\_syn\_inhibitory');
ylabel('Inhibitory Time Constant, tauSyn\_inhibitory');
title('Inhibitory Connection Phase Difference (deg)','FontSize', 10);
colormap('parula');

% Adjust the layout of subplots
sgtitle(sprintf('Inhibitory Behaviour for different g_syn and $\\tau_{syn}$, ($\\tau_s = %.1f, \\tau_{us} = %.1f$)', t1, t2), 'FontSize', 14, 'Interpreter', 'latex');

set(gcf, 'Color', 'w');
set(findall(gcf, 'type', 'axes'), 'FontSize', 10);