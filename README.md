# QuadBot-NeuroMorphic
Software library developed as part of a undergraduate research project at the University of Cambridge, aimed at advancing the study of robotic locomotion neuromorphic control principles.

## Repository Overview
### Ramp Up Guidance
In this directory, you will discover a range of resources designed to facilitate your journey through this project. We recommend starting with 'Short Introductory Report.pdf' to gain valuable contextual insights into the undergraduate research placement conducted during the summer of 2023.

Additionally, you will find the 'Neuron Guidance' subfolder, which aims to extend your understanding of the fundamental neuroscience principles underpinning the neuron models implemented in Simulink. To inspire your exploration, we've included the Jupyter Notebook 'NeuronIntroductions.ipynb,' which contains experiments to help you develop a deeper understanding of these models. It does not serve as a replacement to reading neuroscience literature, but hopefully it can present the best practice towards learning the behaviours of the neuron models, which is through experimentation and experience.

We also recommend the following resources:
* https://neuronaldynamics.epfl.ch/index.html
* http://www.scholarpedia.org/article/Conductance-based_models
* https://en.wikipedia.org/wiki/Spiking_neural_network
* https://en.wikipedia.org/wiki/Neural_coding
* https://en.wikipedia.org/wiki/Hodgkin%E2%80%93Huxley_model

### Simulink Neurons Directory
Within the Simulink Neurons directory, you will discover the following subfolders:

* **Core Neurons:** This folder houses individual neurons used as building blocks for constructing derived neural circuits. Notably, "MQIF_Neuron_Synapse" stands out as the key neuron adapted for synaptic connections and circuit construction. The other two neurons include the standard MQIF neuron based on its foundational paper and the Hodgkin-Huxley neuron, included for educational purposes.

* **Derived Networks:** In this folder, you'll find the simplest central pattern generator circuits that can be assembled using individual MQIF neurons. These are included because they serve as fundamental components that can be interconnected to create more intricate neuronal circuits.

* **Derived Oscillators:** This folder contains the aforementioned "Derived Network" objects connected with feedback in a manner that yields a stable sine wave after double integration. These examples showcase how a neuromorphic gaiting waveform can be employed to control sinusoidal gaiting, and have been included as inspiration for future developers.

* **Characterising:** In this folder is a collection of MATLAB scripts for characterising neural output in relation to its governing parameters. Particular MQIF parameters can be optimised to achieve a specfic pulse shapes, frequencies, durations, etc. These scripts have been included to aid future developers explore the parameter space. 

### Solidworks
All the custom CAD files used to contruct the two robots have been included in this directory. Here is a general rule-thumb-guide how each part of the existing robot was manufactured:
* Brown (MDF wood) - Lasercut
* White (PLA) - 3D Printed
* Shiny/Colourful (Aluminium/Plastic) - Provided by VEX

### SynaPooch & ArachNeuron
SynaPooch is the dog-like robot. ArachNeuron is the spider-like robot.

![Dog Robot](https://github.com/PritRaj1/QuadBot-NeuroMorphic/blob/main/Ramp%20Up%20Guidance/SynaPooch.jpg)
![Spider Robot](https://github.com/PritRaj1/QuadBot-NeuroMorphic/blob/main/Ramp%20Up%20Guidance/ArachNeuron.jpg)

Please watch the video located in the 'Ramp Up Guidance' directory. Pay close attention to the process of 'waking up' the Brain after powering it down. It's important to note that executing a program immediately after powering down the Brain will not yield any behavior. In such cases, you must restart the program. This behavior is observed specifically after power cycling the VEX Brain. However, if you avoid powering it down between program executions, there is no need to restart the program; it will run successfully on the first attempt.

