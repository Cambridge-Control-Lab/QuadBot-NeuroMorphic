function [frequency, spikes_per_burst, burst_duration, duty_cycle] = characterise_spiketrain(dt, spike_array)
    %{
    Function for characterising the bursting behaviour of a generated spike train.
    
    Parameters
    ----------
    dt : FLOAT
        Time_step used in simulation
        
    spike_array : ARRAY
        Array containing logged spikes, as described in the simulate_MQIF docstring.

    Returns
    -------
    frequency : FLOAT
        Describes the burst frequency. i.e. the reciprocal of the
        time period of the bursts.
        
    spikes_per_burst : INTEGER
        Reflects the number of spikes contatined within a single 
        burst.
        
    burst_duration : FLOAT
        The amount of time each burst lasts for.
        
    duty_cycle : FLOAT
        The ratio between the burst duration and the time period of the membrane
        potential. i.e. how long for the time period is the neuron bursting for?
    %}
    % Indexes of when each burst begins 
    burst_times = find(spike_array == 1); 
    
    % Initialise
    spikes_per_burst = 0;
    burst_duration = 0;
    frequency = 0;
    time_period = 1;

    if length(burst_times) > 2
        %{
        The following script runs if there are more than two "initial" spikes, 
        i.e. if there are multiple spikes with logged values > 1, then we have 
        bursting behaviour,not just continous spiking. 
        
        We need at least 3 bursts to be able to characterise the pattern, since
        the initial burst is generally unrepresentative of the others, which
        are uniform copies of one another. Hence, 'len(burst_times) > 2'
        
        'burst_times[0]' is avoided for the same reason - the initial burst is 
        usually not representative of the other bursts.
        %}
        
        % Time between initial spikes = time period of bursts
        time_period = (burst_times(3)-burst_times(2))*dt; %
        frequency = 1/time_period;
        
        % Extract a short array looking at a singular burst for analysis
        single_burst = spike_array(burst_times(2):burst_times(3)-1);
        
        % The spikes were counted within spike_array, so the final value
        % corresponds to the number of spikes per burst.
        [spikes_per_burst,k] = max(single_burst);
        
        % We extracted single_burst out of the overall spike train
        % to use as a close-up of one burst. Therefore, the index of the 
        % final spike within single_burst corresponds to the burst duration. 
        burst_duration = (k-1)*dt;
    
    % We have spiking, but not bursting.
    elseif length(burst_times) == 1
        spikes_per_burst = 1;
        frequency=0; % Set frequency to zero to indicate there are no bursts.
    end
    
    duty_cycle = burst_duration*100/time_period;
end