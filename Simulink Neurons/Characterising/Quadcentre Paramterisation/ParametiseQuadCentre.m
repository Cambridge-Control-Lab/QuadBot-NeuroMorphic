dt = 1e-3;
runtime=30;
num_steps=floor(runtime/dt);

t1=1.5;
t2=190;

% Constants to vary. Please refer to 'QuadCentreForCharacterising.slx'
P=-40; % GB_B
Q_array = -40:2:-20; % GB_C
R_array = -40:2:-20; % GB_D
S=-40; % GB_A
g_syn=0.5;
tauSyn=50;

% Create meshgrid for Q and R
[Q_grid,R_grid] = meshgrid(Q_array, R_array);

% Create empty 2D arrays to store results
AC_latency_grid = zeros(size(Q_grid));
AC_phase_diff_grid = zeros(size(Q_grid));
AD_latency_grid = zeros(size(Q_grid));
AD_phase_diff_grid = zeros(size(Q_grid));

% Lengths to track for loops
length_Q = length(Q_grid);
length_R = length(R_grid);

for i = 1:length_Q
    Q = Q_array(i);
    for j = 1:length_R
        R = R_array(j);
        disp([Q,R]);
        % Simulate
        simOut = sim('QuadCentreForCharacterising.slx');
        
        % Extract data from the simulation output
        spike_data_A = simOut.spikes_A.data;
        spike_data_C = simOut.spikes_C.data;
        spike_data_D = simOut.spikes_D.data;
        
        % Characterise the spike trains
        [AC_latency, AC_phase_diff] = characterise_latency(dt, spike_data_A, spike_data_C);
        [AD_latency, AD_phase_diff] = characterise_latency(dt, spike_data_A, spike_data_D);

        % Store the computed values in the grid
        AC_latency_grid(j, i) = AC_latency;
        AC_phase_diff_grid(j, i) = AC_phase_diff;
        AD_latency_grid(j, i) = AD_latency;
        AD_phase_diff_grid(j, i) = AD_phase_diff;
    end
end

% Plotting all the contour plots in one figure

% Create a new figure
figure('Position', [100, 100, 1200, 800]);

% Plot
subplot(2, 2, 1);
contourf(Q_grid, R_grid, AC_latency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Synaptic Gate Threshold C, GB\_C');
ylabel('Synaptic Gate Threshold, GB\_D');
title('AC Burst Latency (s)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(2, 2, 2);
contourf(Q_grid, R_grid, AC_phase_diff_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Synaptic Gate Threshold C, GB\_C');
ylabel('Synaptic Gate Threshold, GB\_D');
title('AC Phase Difference (deg)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(2, 2, 3);
contourf(Q_grid, R_grid, AD_latency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Synaptic Gate Threshold C, GB\_C');
ylabel('Synaptic Gate Threshold, GB\_D');
title('AD Burst Latency (s)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(2, 2, 4);
contourf(Q_grid, R_grid, AD_phase_diff_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('Synaptic Gate Threshold C, GB\_C');
ylabel('Synaptic Gate Threshold, GB\_D');
title('AD Phase Difference (deg)','FontSize', 10);
colormap('parula');

% Adjust Layout
sgtitle(['QuadCentre Variations with GB\_C and GB\_D, ($\tau_s = ', num2str(t1), ', \tau_{us} = ', num2str(t2), ')$'], 'FontSize', 14, 'Interpreter', 'latex');
set(gcf, 'Color', 'w');
set(findall(gcf, 'type', 'axes'), 'FontSize', 10);

P=-40; % GB_B
Q_array = -20; % GB_C
R_array = -20; % GB_D
S=-40; % GB_A

% Constants to vary
G = 0:1:10;
Tsyn = 45:1:55;

% Create meshgrids
[G_grid,T_grid] = meshgrid(G, Tsyn);

% Create empty 2D arrays to store results
AC_latency_grid = zeros(size(G_grid));
AC_phase_diff_grid = zeros(size(G_grid));

length_G = length(G);
length_T = length(Tsyn);

for i = 1:length_G
    g_syn = G(i);
    for j = 1:length_T
        tauSyn = Tsyn(j);
        disp([g_syn, tauSyn]);
        
        % Simulate
        simOut = sim('QuadCentreForCharacterising.slx');
        
        % Extract data from the simulation output
        spike_data_A = simOut.spikes_A.data;
        spike_data_C = simOut.spikes_C.data;
        
        % Characterise the spike trains
        [AC_latency, AC_phase_diff] = characterise_latency(dt, spike_data_A, spike_data_C);

        % Store the computed values in the grid
        AC_latency_grid(j, i) = AC_latency;
        AC_phase_diff_grid(j, i) = AC_phase_diff;
    end
end

% Plotting all the contour plots in one figure

% Create a new figure
figure('Position', [100, 100, 800, 800]);

subplot(1, 2, 1);
contourf(G_grid, T_grid, AC_latency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('MQIF C Inhibitory Conductance, g\_syn\_inhibitory\_C');
ylabel('MQIF C Inhibitory Time Constant, tauSyn\_inhibitory\_C');
title('AC Burst Latency (s)', 'FontSize', 10, 'Interpreter', 'latex');

subplot(1, 2, 2);
contourf(G_grid, T_grid, AC_phase_diff, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('MQIF C Inhibitory Conductance, g\_syn\_inhibitory\_C');
ylabel('MQIF C Inhibitory Time Constant, tauSyn\_inhibitory\_C');
title('AC Phase Difference (deg)', 'FontSize', 10, 'Interpreter', 'latex');

% Adjust the layout of subplots
sgtitle(sprintf('Quadcentre Wavforms for different g_syn and $\\tau_{syn}$, ($\\tau_s = %.1f, \\tau_{us} = %.1f$)', t1, t2), 'FontSize', 14, 'Interpreter', 'latex');
set(gcf, 'Color', 'w');
set(findall(gcf, 'type', 'axes'), 'FontSize', 10);