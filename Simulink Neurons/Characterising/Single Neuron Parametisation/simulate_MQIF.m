function [V_values, Vs_values, Vus_values, spikes, time ] = simulate_MQIF(num_steps, dt, V0, Vs0, Vus0, I_ext,...
                  V_threshold, V_reset, Vs_reset, delta_Vus,...
                  g_f, g_s, g_us,...
                  tau_s, tau_us,...
                  C)
    %{
    Function that generate arrays holding the values of each variable as a time-series.
    Integrates the ODEs and fire spikes.
    
    Parameters
    ----------
    num_steps, dt : INTEGER
        Governs the timebase of the simulation. num_steps denotes the total 
        number of updates steps for the whole simulation. dt is the time spacing 
        between these steps.
        
    V0, Vs0, Vus0 : INTEGER/FLOAT
        The initial/equilibrium values in the ODEs. This is passed into the 
        'v_dot' ODE function. V governs membrane potential. Vs governs the slow
        currents within the ODEs. Vus governs the ultraslow currents.
        
    I_ext : ARRAY
        Input current waveform.
        
    V_threshold, V_reset, VS_reset, delta_Vus : INTEGER/FLOAT
        Paramters governing the reset characteristics. When membrane potential 
        reaches V_threshold, a spike occurs, and the state variables are reset 
        using these paramters.
        
    g_f, g_s, g_us : FLOAT
        Paramters governing the associated conductances of each of the potential 
        differences that arise within the 'v_dot' ODE function.
        
    tau_s, tau_us : INTEGER/FLOAT
        Time constants governing the slow and ultraslow charactersitics, as set
        in the Vs and Vus ODEs.
    
    C : FLOAT
        Capactiance used in the V ODE.

    Returns
    -------
    V_values, Vs_values, Vus_values : ARRAY
        Timeseries containing the values of each of the state variables at each
        time-step. Each element is separated by 'dt' milliseconds of time.
        
    spikes : ARRAY
        Array of integers used to relay the number of spikes within a burst. 
        When a burst begins, the first spike is logged as '1', in an array element
        whose index corresponds to the time step at which it occured. The next
        spike is logged as '2', then '3', and so on until the burst ends and 
        the counter is reset. 
    
    time : ARRAY
        Array to keep track of the time in milliseconds. Useful for plotting.

    %}
    time = 0:dt:(num_steps-1)*dt;
      
    % Initialise array to store spike log
    spikes = zeros(num_steps,1);
    timer = 0;
    num_in_burst = 0;
      
    % Initialise arrays to store results
    V_values = zeros(num_steps,1);
    V_values(1) = V0;
      
    Vs_values = zeros(num_steps,1);
    Vs_values(1) = Vs0;
      
    Vus_values = zeros(num_steps,1);
    Vus_values(1) = Vus0;
      
    % Perform forward Euler integration
    for i = 1:num_steps-1 
        % Set current value
        V_i = V_values(i);
        Vs_i = Vs_values(i);
        Vus_i = Vus_values(i);

        I_i = I_ext(i);
          
        % Update step
        Vs_new = Vs_i + dt * Vs_dot(V_i, Vs_i, tau_s);
        Vus_new = Vus_i + dt * Vus_dot(V_i, Vus_i, tau_us);
          
        V_new = V_i + dt * V_dot(V_i, Vs_i, Vus_i, I_i,...
                                 V0, Vs0, Vus0,...
                                 g_f, g_s, g_us,...
                                 C);
          
        % Update array
        if V_new > V_threshold
            % Reset after spike  
            V_values(i+1) = V_reset;
            Vs_values(i+1) = Vs_reset;
            Vus_values(i+1) = Vus_new + delta_Vus;
            
            % Log spike according to its number in the burst.
            num_in_burst = num_in_burst + 1;
            spikes(i) = num_in_burst;
            timer = 0;
          
        else
            V_values(i+1) = V_new;
            Vs_values(i+1) = Vs_new;
            Vus_values(i+1) = Vus_new;
            timer = timer + 1;
        end
          
        % If the timer exceeds 4% of the total runtime, then the burst has ended.
        if timer > 0.04*num_steps
            num_in_burst = 0;
        end
    end

end