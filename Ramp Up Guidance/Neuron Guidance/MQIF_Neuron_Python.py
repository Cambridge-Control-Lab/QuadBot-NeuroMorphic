# -*- coding: utf-8 -*-
"""
The following Python script runs simulations of the MQIF Neuron model, 
with the aims of characterising its bursting patterns.
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d
plt.style.use('seaborn')
plt.rcParams['figure.edgecolor'] = 'blue'
plt.rcParams['scatter.marker'] = 'x'
import time as clock

#ODEs governing MQIF model
def Vs_dot(V, Vs, tau_s):
  return 250*(V - Vs) / tau_s

def Vus_dot(V, Vus, tau_us):
  return 250*(V - Vus) / tau_us

def V_dot(V, Vs, Vus, I_ext, # Current values
          V0, Vs0, Vus0, #Intial values
          g_f, g_s, g_us, # Conductances
          C): #Capacitance

  return 250*(I_ext + g_f*((V-V0)**2) - g_s*((Vs-Vs0)**2) - g_us*((Vus-Vus0)**2)) / C


def simulate_MQIF(num_steps, dt, V0, Vs0, Vus0, I_ext,
                  V_threshold=20, V_reset=-45, Vs_reset=7.5, delta_Vus=1.7,
                  g_f = 1.0, g_s = 0.5, g_us = 0.015,
                  tau_s = 4.3, tau_us = 278,
                  C = 0.82):
    """
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
        Array to keep track of the time in seconds. Useful for plotting.

    """
    time = np.arange(0, num_steps * dt, dt)
      
    # Initialise array to store spike log
    spikes = np.zeros(num_steps)
    timer = 0
    num_in_burst = 0
      
    # Initialise arrays to store results
    V_values = np.zeros(num_steps)
    V_values[0] = V0
      
    Vs_values = np.zeros(num_steps)
    Vs_values[0] = Vs0
      
    Vus_values = np.zeros(num_steps)
    Vus_values[0] = Vus0
      
    # Perform forward Euler integration
    for i in range(0, num_steps-1): 
        # Set current value
        V_i, Vs_i, Vus_i = V_values[i], Vs_values[i], Vus_values[i]
        I_i = I_ext[i]
          
        # Update step
        Vs_new = Vs_i + dt * Vs_dot(V_i, Vs_i, tau_s)
        Vus_new = Vus_i + dt * Vus_dot(V_i, Vus_i, tau_us)
          
        V_new = V_i + dt * V_dot(V_i, Vs_i, Vus_i, I_i,
                                 V0, Vs0, Vus0,
                                 g_f, g_s, g_us,
                                 C)
          
        # Update array
        if V_new > V_threshold:
            # Reset after spike  
            V_values[i+1] = V_reset
            Vs_values[i+1] = Vs_reset
            Vus_values[i+1] = Vus_new + delta_Vus
            
            # Log spike according to its number in the burst.
            num_in_burst += 1
            spikes[i] = num_in_burst
            timer=0
          
        else:
            V_values[i+1] = V_new
            Vs_values[i+1] = Vs_new
            Vus_values[i+1] = Vus_new
            timer += 1
          
        # If the timer exceeds 4% of the total runtime, then the burst has ended.
        if timer > 0.04*num_steps:
            num_in_burst = 0
      
    return V_values, Vs_values, Vus_values, spikes, time

def plot_MQIF(time, I_ext, V, Vs, Vus, state_variables=False, phase_portrait=False):
    """
    Function for plotting a single simulation. Feed this function the generated 
    arrays from simulate_MQIF to view the dynamics.
    
    Parameters
    ----------
    time : ARRAY
        Array to keep track of the time in milliseconds. 
        
    I_ext : ARRAY
        Input current waveform.
        
    V, Vs, Vus : ARRAY
        Contains the values of each state variable at each time-step. V is the 
        most important here - membrane potential. The others are state variables
        used in the ODEs.

    state_variables : BOOLEAN
        Set to true if you also want to plot the state variables, Vs and Vus, 
        with respect to time. 
        
    phase_portrait : BOOLEAN
        Set to true if you also want to plot phase portraits of Vs against V and
        Vus against V.

    """
    fig1, axes = plt.subplots(1, 2, figsize=(12,4))
    
    axes[0].plot(time, I_ext, color='blue')
    axes[0].set_title('Current Input')
    axes[0].set_xlabel('time (s)')
    axes[0].set_ylabel('I_ext (mA/nF)')
    
    axes[1].plot(time, V, color='crimson')
    axes[1].set_title(f'MQIF Membrane Potential, dt={time[1]}')
    axes[1].set_xlabel('time (s)')
    axes[1].set_ylabel('V (mV)')
    
    if state_variables:
        fig2, axes = plt.subplots(1, 2, figsize=(8,3))
          
        axes[0].plot(time, Vs, color='mediumorchid')
        axes[0].set_xlabel('time (ms)')
        axes[0].set_ylabel('Vs (mV)')
          
        axes[1].plot(time, Vus, color='mediumorchid')
        axes[1].set_xlabel('time (ms)')
        axes[1].set_ylabel('Vus (mV)')
          
        axes[0].set_title('STATE VARIABLES MQIF', loc='left')
        
        plt.show()
    
    if phase_portrait:
        fig3, axes = plt.subplots(1, 2, figsize=(8,3))
          
        axes[0].plot(V, Vs, color='mediumorchid')
        axes[0].set_xlabel('V (mV)')
        axes[0].set_ylabel('Vs (mV)')
          
        axes[1].plot(V, Vus, color='mediumorchid')
        axes[1].set_xlabel('V (mV)')
        axes[1].set_ylabel('Vus (mV)')
          
        axes[0].set_title('PHASE PORTRAITS MQIF', loc='left')
        
        plt.show()

def characterise_spiketrain(dt, spike_array):
    """
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
    """
    # Indexes of when each burst begins 
    burst_times = np.where(spike_array == 1)[0] 
    
    # Initialise
    spikes_per_burst = 0
    burst_duration = 0
    frequency = 0
    time_period = 1

    if len(burst_times) > 2:
        """
        The following script runs if there are more than two "initial" spikes, 
        i.e. if there are multiple spikes with logged values > 1, then we have 
        bursting behaviour,not just continous spiking. 
        
        We need at least 3 bursts to be able to characterise the pattern, since
        the initial burst is generally unrepresentative of the others, which
        are uniform copies of one another. Hence, 'len(burst_times) > 2'
        
        'burst_times[0]' is avoided for the same reason - the initial burst is 
        usually not representative of the other bursts.
        """
        
        # Time between initial spikes = time period of bursts
        time_period = (burst_times[2]-burst_times[1])*dt
        frequency = 1/time_period
        
        # Extract a short array looking at a singular burst for analysis
        single_burst = spike_array[burst_times[1]:burst_times[2]]
        
        # The spikes were counted within spike_array, so the final value
        # corresponds to the number of spikes per burst.
        spikes_per_burst = max(single_burst) 
        
        # We extracted single_burst out of the overall spike train
        # to use as a close-up of one burst. Therefore, the index of the 
        # final spike within single_burst corresponds to the burst duration. 
        burst_duration = np.argmax(single_burst)*dt
    
    # We have spiking, but not bursting.
    elif len(burst_times) == 1:
        spikes_per_burst = 1
        frequency=0 # Set frequency to zero to indicate there are no bursts.
    
    duty_cycle = burst_duration*100/time_period
    
    return frequency, spikes_per_burst, burst_duration, duty_cycle

# Please note: dt = 0.1 is too big unfortunately. The simulation becomes inaccurate.
dt = 0.0001
runtime =10 # Desired simulation time in s
num_steps = int(runtime/dt)

# Generate input current waveform. Currently set up as a step input of 5 mA
amplitude = 5
I_ext = np.zeros(num_steps) 
start_index = num_steps // 6
I_ext[start_index:num_steps] = amplitude

# Parameters to hold constant 
V_t, V_r, Vs_r, d_Vus = 20, -45, 7.5, 1.3 #V_threshold, V_reset, Vs_reset, delta_Vus
# g_f, g_s, g_us = 1.0, 0.5, 0.015 # Conductances
g_f, g_s, g_us = 1.0, 0.5, 0.015 # Conductance
C = 0.82 # Capacitance

# Simulate and charactersise
t1 = clock.time()
V_MQIF, Vs, Vus, spikes, time = simulate_MQIF(num_steps, dt, -52, -50, -52, I_ext, V_t, V_r, Vs_r, d_Vus, g_f, g_s, g_us, 4.3, 278, C)
f, s, t, d = characterise_spiketrain(dt, spikes)
elapsed2 = clock.time() - t1

#print(f"A simulation plus characterisation takes {elapsed2} seconds.")
print(f"Frequency: {f} Hz, Spikes per Burst: {s}, Duration: {t} s, Duty Cycle: {d} %")
plot_MQIF(time, I_ext, V_MQIF, Vs, Vus)
f, s, t, d = characterise_spiketrain(dt, spikes)
