# QuadBot-NeuroMorphic
Software library developed as part of a undergraduate research project at the University of Cambridge, aimed at advancing the study of robotic locomotion neuromorphic control principles.

## Prerequisites
* MATLAB/Simulink R2022b or later
* SOLIDWORKS 2022 or later
* [VEX V5 Brain Support Package](https://uk.mathworks.com/help/supportpkg/vexv5)
* AdvancedSmartMotorBlocks_18b_v2 --included in repo
* Vex_V5_Simulink_Expansion --included in repo
* [VEX CAD Master Files](https://github.com/VEX-CAD/VEX-CAD-Solidworks) --optional but useful

## Simulink Neurons Directory
Within the SimulinkNeurons directory, you will discover the following subfolders:

* **Core Neurons:** This folder houses individual neurons used as building blocks for constructing derived neural circuits. Notably, "MQIF_Neuron_Synapse" stands out as the key neuron adapted for synaptic connections and circuit construction. The other two neurons include the standard MQIF neuron based on its foundational paper and the Hodgkin-Huxley neuron, included for educational purposes.

* **Derived Networks:** In this folder, you'll find the simplest central pattern generator circuits that can be assembled using individual MQIF neurons. These are included because they serve as fundamental components that can be interconnected to create more intricate neuronal circuits.

* **Derived Oscillators:** This folder contains the aforementioned "Derived Network" objects connected with feedback in a manner that yields a stable sine wave after double integration. These examples showcase how a neuromorphic gaiting waveform can be employed to control sinusoidal gaiting, and have been included as inspiration for future developers.

* **Characterising:** In this folder is a collection of MATLAB scripts for characterising neural output in relation to its governing parameters. Particular MQIF parameters can be optimised to achieve a specfic pulse shapes, frequencies, durations, etc. These scripts have been included to aid future developers explore the parameter space. 

