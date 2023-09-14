# QuadBot-NeuroMorphic
Software library developed as part of a undergraduate research project at the University of Cambridge, aimed at advancing the study of robotic locomotion neuromorphic control principles.

## SimulinkNeurons Directory
Within the SimulinkNeurons directory, you will discover the following subfolders:

* **Core Neurons:** This folder houses individual neurons used as building blocks for constructing derived neural circuits. Notably, "MQIF_Neuron_Synapse" stands out as the key neuron adapted for synaptic connections and circuit construction. The other two neurons include the standard MQIF neuron based on its foundational paper and the Hodgkin-Huxley neuron, included for educational purposes.

* **Derived Networks:** In this folder, you'll find the simplest central pattern generator circuits that can be assembled using individual MQIF neurons. These are included because they serve as fundamental components that can be interconnected to create more intricate neuronal circuits.

* **Derived Oscillators:** This folder contains the aforementioned "Derived Network" objects connected with feedback in a manner that yields a stable sine wave after double integration. These examples showcase how a neuromorphic gaiting waveform can be employed to control sinusoidal gaiting, and have been included as inspiration for future developers.
