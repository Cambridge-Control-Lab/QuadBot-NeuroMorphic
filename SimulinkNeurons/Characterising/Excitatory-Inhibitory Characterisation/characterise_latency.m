function [latency, phase_diff] = characterise_latency(dt, spike_array_X, spike_array_Y)

% Indexes of when each burst begins 
burst_times_X = find(spike_array_X == 1);
burst_times_Y = find(spike_array_Y == 1);

latency = 0;
phase_diff = 0;

if length(burst_times_X) > 6 && length(burst_times_Y) > 6
    time_period = (burst_times_X(7) - burst_times_X(6)) * dt; 
    % Time lag between bursts
    latency = (burst_times_Y(6) - burst_times_X(6)) * dt;
    phase_diff = 360 * latency / time_period;

    while phase_diff > 360
        phase_diff = phase_diff - 360;
    end
    while phase_diff < -360
        phase_diff = phase_diff + 360;
    end
end

end
