% Please note: dt is very sensitive. Make sure the bursting behaviour is
% the same for you choice of dt against a smaller dt, before finalising.
dt = 0.00001;
runtime = 10 ;% Desired simulation time in s
num_steps = floor(runtime/dt);

% Generate input current waveform. Currently set up as a step input of 5 mA
amplitude = 5;
I_ext = zeros(num_steps,1);
start_index = floor(num_steps / 6)+1;
I_ext(start_index:num_steps) = amplitude;

% Parameters to hold constant
V_t = 20; %V_threshold, V_reset, Vs_reset, delta_Vus
V_r = -45; %V_threshold, V_reset, Vs_reset, delta_Vus
Vs_r = 7.5; %V_threshold, V_reset, Vs_reset, delta_Vus
d_Vus = 1.3; %V_threshold, V_reset, Vs_reset, delta_Vus

g_f = 1.0; % Conductances
g_s = 0.5; % Conductances
g_us = 0.015; % Conductances

C = 0.82; % Capacitance

% Simulate and plot one simulation
tic
[V_MQIF, Vs, Vus, spikes, time] = simulate_MQIF(num_steps, dt, -52, -50, -52, I_ext, V_t, V_r, Vs_r, d_Vus, g_f, g_s, g_us, 4.3, 278, C);
toc

[f, s, t, d] = characterise_spiketrain(dt, spikes);
fprintf("Frequency: %f Hz, Spikes per Burst: %f, Duration: %f s, Duty Cycle: %f \n",f,s,t,d)


% Run 1 - Bulk simulation to explore behavioural variation with time constants

% Keep voltages constant
v0 =  -52;
vs0 = -50;
vus0 = -52;

% Time constants to vary
T_s = 0.25:0.25:3;
T_us = 20:10:1000;

% Create meshgrid for T_s and T_us
[T_s_grid, T_us_grid] = meshgrid(T_s, T_us);

% Create empty 2D arrays to store results
frequency_grid = zeros(size(T_s_grid));
spikes_per_burst_grid = zeros(size(T_s_grid));
burst_duration_grid = zeros(size(T_s_grid));
duty_cycle_grid = zeros(size(T_s_grid));

length_T_s = length(T_s);
length_T_us = length(T_us);

tic
for i = 1:length_T_s
    tau_s=T_s(i);
    for j = 1:length_T_us
        tau_us = T_us(j);

        [V_MQIF, Vs, Vus, spikes, time] = simulate_MQIF(num_steps, dt, v0, vs0, vus0, I_ext, V_t, V_r, Vs_r, d_Vus, g_f, g_s, g_us, tau_s, tau_us, C);
        [frequency, spikes_per_burst, burst_duration, duty_cycle] = characterise_spiketrain(dt,spikes);

        % Store the computed values in the grid
        frequency_grid(j, i) = frequency;
        spikes_per_burst_grid(j, i) = spikes_per_burst;
        burst_duration_grid(j, i) = burst_duration;
        duty_cycle_grid(j, i) = duty_cycle;
    end
end

toc

% Plotting all the contour plots in one figure

% Create a new figure
figure('Position', [100, 100, 1200, 800]);

% First subplot - Frequency Contour Plot
subplot(2, 2, 1);
contourf(T_s_grid, T_us_grid, frequency_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('\tau_s');
ylabel('\tau_{us}');
title('Burst Frequency (Hz)', 'FontSize', 10, 'Interpreter', 'latex');


% Second subplot - Number of Spikes per Burst Contour Plot
subplot(2, 2, 2);
contourf(T_s_grid, T_us_grid, spikes_per_burst_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('\tau_s');
ylabel('\tau_{us}');
title('Spike Count per Burst (-)', 'FontSize', 10, 'Interpreter', 'latex');


% Third subplot - Duration per Burst Contour Plot
subplot(2, 2, 3);
contourf(T_s_grid, T_us_grid, burst_duration_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('\tau_s');
ylabel('\tau_{us}');
title('Burst Width/Duration (s)', 'FontSize', 10, 'Interpreter', 'latex');


% Fourth subplot - Duty Cycle Contour Plot
subplot(2, 2, 4);
contourf(T_s_grid, T_us_grid, duty_cycle_grid, 'LineColor', 'none', 'LineStyle', 'none');
colorbar;
xlabel('\tau_s');
ylabel('\tau_{us}');
title('Duty Cycle (\%)', 'FontSize', 10, 'Interpreter', 'latex');
colormap('parula');

% Adjust the layout of subplots
sgtitle('Variations with $\tau_s$ and $\tau_{us}$; ($V^{(0)} = -52$, $V_{s}^{(0)} = -50$, $V_{us}^{(0)} = -52$)', 'FontSize', 14, 'Interpreter', 'latex');

set(gcf, 'Color', 'w');
set(findall(gcf, 'type', 'axes'), 'FontSize', 10);

% % Run 2 - Behavioural changes with varying Ultraslow Constants
% 
% % Parameters to hold constant
% tau_s = 4.3;
% T_us = 20:10:1000; % Time constants
% 
% % Parameters we would like to vary
% v0 = -52;
% vs0 = -50;
% vus0 = -63:0.5:-42;
% 
% % Create meshgrid for Vs0 and Vus0
% [T_us_grid, Vus_grid] = meshgrid(T_us, vus0);
% 
% % Create empty 2D arrays to store results
% frequency_grid = zeros(size(Vus_grid));
% spikes_per_burst_grid = zeros(size(Vus_grid));
% burst_duration_grid = zeros(size(Vus_grid));
% duty_cycle_grid = zeros(size(Vus_grid));
% 
% length_T_us = length(T_us);
% length_vus0 = length(vus0);
% 
% tic
% for i = 1:length_T_us
%     tau_us = T_us(i);
%     for j = 1:length_vus0
%         Vus0_i = vus0(j);
% 
%         [V_MQIF, Vs, Vus, spikes, time] = simulate_MQIF(num_steps, dt, v0, vs0, Vus0_i, I_ext, V_t, V_r, Vs_r, d_Vus, g_f, g_s, g_us, tau_s, tau_us, C);
%         [frequency, spikes_per_burst, burst_duration, duty_cycle] = characterise_spiketrain(dt,spikes);
% 
%         % Store the computed values in the grid
%         frequency_grid(j, i) = frequency;
%         spikes_per_burst_grid(j, i) = spikes_per_burst;
%         burst_duration_grid(j, i) = burst_duration;
%         duty_cycle_grid(j, i) = duty_cycle;
%     end
% end
% toc
% % Plotting all the contour plots in one figure
% 
% % Create a new figure
% figure('Position', [100, 100, 1200, 800]);
% 
% % First subplot - Frequency Variations with Ultraslow Parameters
% subplot(2, 2, 1);
% contourf(T_us_grid, Vus_grid, frequency_grid, 'LineColor', 'none', 'LineStyle', 'none');
% colorbar;
% xlabel('\tau_{us} (ms)');
% ylabel('V_{us}^{(0)} (mV)');
% title('Burst Frequency (Hz)', 'FontSize', 10, 'Interpreter', 'latex');
% colormap('parula');
% 
% % Second subplot - Number of Spikes per Burst varying with Ultraslow Parameters
% subplot(2, 2, 2);
% contourf(T_us_grid, Vus_grid, spikes_per_burst_grid, 'LineColor', 'none', 'LineStyle', 'none');
% colorbar;
% xlabel('\tau_{us} (ms)');
% ylabel('V_{us}^{(0)} (mV)');
% title('Spike Count per Burst (-)', 'FontSize', 10, 'Interpreter', 'latex');
% colormap('parula');
% 
% % Third subplot - Duration per Burst against Ultraslow Parameters
% subplot(2, 2, 3);
% contourf(T_us_grid, Vus_grid, burst_duration_grid, 'LineColor', 'none', 'LineStyle', 'none');
% colorbar;
% xlabel('\tau_{us} (ms)');
% ylabel('V_{us}^{(0)} (mV)');
% title('Burst Width/Duration (s)', 'FontSize', 10, 'Interpreter', 'latex');
% colormap('parula');
% 
% % Fourth subplot - Duty Cycle varying with Ultraslow Parameters
% subplot(2, 2, 4);
% contourf(T_us_grid, Vus_grid, duty_cycle_grid, 'LineColor', 'none', 'LineStyle', 'none');
% colorbar;
% xlabel('\tau_{us} (ms)');
% ylabel('V_{us}^{(0)} (mV)');
% title('Duty Cycle (\%)', 'FontSize', 10, 'Interpreter', 'latex');
% colormap('parula');
% 
% % Adjust the layout of subplots
% sgtitle('Variations with $\tau_{us}$ and $V_{us}^{(0)}$, ($V^{(0)} = -52$, $V_{s}^{(0)} = -50$, $\tau_s = 4.2$)', 'FontSize', 14, 'Interpreter', 'latex');
% set(gcf, 'Color', 'w');
% set(findall(gcf, 'type', 'axes'), 'FontSize', 10);
% 
% 
