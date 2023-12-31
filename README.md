# Welcome to **QuadBot-NeuroMorphic!** 

This repository is dedicated to the "Neuromorphic Control of Quadrupedal Robots" project, which was conducted as part of an undergraduate research opportunity hosted by the Cambridge University Engineering Department.

* Contributor: Prithvi Raj (pr478@cam.ac.uk)
* Supervisors: Dr. Fulvio Forni, Prof. Timothy O'Leary
* Funding Body: MathWorks

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[![View QuadBot-NeuroMorphic on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/135517-quadbot-neuromorphic)


<p align="center">
  <img src="https://github.com/PritRaj1/QuadBot-NeuroMorphic/assets/77790119/83281e7f-eb36-46f4-8208-e5a165300746" width="500">
</p>
<p align="center"><em>Welcome to the repository!</em></p>

## Project Overview

For further contextual details about the project and its goals, please refer to the brief contextual report, **[Ramp Up Guidance/Short Introductory Report.pdf](https://github.com/PritRaj1/QuadBot-NeuroMorphic/blob/main/Ramp%20Up%20Guidance/Short%20Introductory%20Report.pdf)**.

Throughout this README, you will find links to various unlisted YouTube videos providing further guidance. Here is a playlist of all of them for your reference:
**[QuadBot-NeuroMorphic YouTube Playlist](https://www.youtube.com/playlist?list=PLfc7dQtOJL7R3sYg_bDoXvOtagNdkhMTB)**

Thank you for your interest in our project, and feel free to reach out to clarify and learn more about our work in the field of neuromorphic robotics!

[Welcome Video!](https://youtu.be/8BMxn9v1NPU)

---

## Prerequisites

* MATLAB/Simulink R2022b or later
* SOLIDWORKS 2022 or later
* [Simulink Coder Support Package for VEX EDR V5 Robot Brain](https://uk.mathworks.com/help/supportpkg/vexv5/)
* [VEX V5 Advanced Smart Motor Blocks files](https://uk.mathworks.com/matlabcentral/answers/435564-vex-v5-motor-voltage) --has been provided in this repository for convenience
* [VEX V5 Simulink Expansion](https://uk.mathworks.com/matlabcentral/fileexchange/119133-vex-v5-simulink-expansion) --has been provided in this repository for convenience
* [VEX SOLIDWORKS Files](https://github.com/VEX-CAD/VEX-CAD-Solidworks.git) --optional, but useful to have

## Overview of Files
### 'Ramp Up Guidance' Directory
In this directory, you will discover a range of resources designed to facilitate your journey through this project. We recommend starting with 'Short Introductory Report.pdf' to gain contextual information regarding the undergraduate research placement conducted during the summer of 2023.

Additionally, within this directory you will find the 'Neuron Guidance' subfolder, which aims to extend your understanding of the fundamental neuroscience principles underpinning the neuron models implemented in Simulink. This subfolder contains:

* Literature explaining the neuroscience theory underpinning the software contained within this repository.
* The Jupyter Notebook **'Neuron_Introductions.ipynb**', which contains experiments to help you develop a deeper understanding of these models. It does not serve as a replacement to reading neuroscience literature, but hopefully it can present the best practice towards learning the behaviours of the neuron models, which is through experimentation and experience. 
* A Python implementation of the MQIF Neuron, named **'MQIF_Neuron_Python.py'**. If you have previous experience with traditional software languages, (but maybe less experience with Simulink), we recommend exploring this file. Although it may appear daunting at first glance, the majority of the code consists of comments to assist you! This Python script is provided to facilitate your understanding of the MQIF neuron through standard coding practices, as the majority of the software in this project was developed in Simulink.
  * The script also contains a function for tracking spikes within the MQIF neuron's output burst. This concept is expanded upon in 'Simulink Neurons/Characterising' simulations, so developing some familiarity with this function is recommended.


Once you have gained confidence with the Python/Notebook implementations of the neurons, consider examining the corresponding Simulink implementations available in the 'Simulink Neurons/Core Neurons' directory. The most important model is the 'MQIF_Neuron_Synapse.slx' file, as it serves as the foundational neuron for all central pattern generator circuits within this repository. In support of this, a video lecture has been recorded to aid your understanding: [MQIF_Synapse Explanation](https://youtu.be/Tk5bJmx7L14).


We also recommend the following resources:
* https://neuronaldynamics.epfl.ch/index.html
* http://www.scholarpedia.org/article/Conductance-based_models
* https://en.wikipedia.org/wiki/Spiking_neural_network
* https://en.wikipedia.org/wiki/Neural_coding
* https://en.wikipedia.org/wiki/Hodgkin%E2%80%93Huxley_model

---

### 'Simulink Neurons' Directory
Within the Simulink Neurons directory, you will discover the following subfolders:

* **Core Neurons:** This folder houses individual neurons used as building blocks for constructing derived neural circuits. Notably, "MQIF_Neuron_Synapse" stands out as the key neuron adapted for synaptic connections and circuit construction. The other two neurons include the standard MQIF neuron based on its foundational paper and the Hodgkin-Huxley neuron, included for educational purposes. As mentioned in the 'Ramp Up Guidance' section, the following video has been provided to assist your understanding: [MQIF_Synapse Explanation](https://youtu.be/Tk5bJmx7L14).

* **Derived Networks:** In this folder, you'll find the simplest central pattern generator circuits that can be assembled using individual MQIF neurons. These are included because they serve as fundamental components that can be interconnected to create more intricate neuronal circuits.

* **Derived Oscillators:** This folder contains the aforementioned "Derived Network" objects connected with feedback in a manner that yields a stable sine wave after double integration. These examples showcase how a neuromorphic gaiting waveform can be employed to control sinusoidal gaiting, and have been included as inspiration for future developers.

* **Characterising:** In this folder is a collection of MATLAB scripts for characterising neural output in relation to its governing parameters. Particular MQIF parameters can be optimised to achieve specfic pulse shapes, frequencies, durations, etc. These scripts have been included to aid future developers explore the parameter space. 

These components (hopefully) enable the straightforward assembly of neuromorphic circuits for locomotive control. Individual neurons can be used to build central pattern generator circuits. When central pattern generator circuits are combined with feedback neurons, they can produce oscillators. These oscillators, in turn, allow for the encoding of stable gait patterns. For a brief and explanatory demonstration of this, you can watch the video here: [Neuromorphic Gaiting](https://youtu.be/aiv5ElMc6nQ).

---

### 'SOLIDWORKS' Directory
All the custom CAD files used to contruct the two robots have been included in this directory. Here is a general rule-of-thumb-guide how each part of the existing robot was manufactured:
* Brown (MDF wood) - Lasercut
* White (PLA) - 3D Printed
* Shiny/Colourful (Aluminium/Plastic) - Provided by VEX

---

### NeuroPup & Synapider
NeuroPup is the dog-like robot. Synapider is the spider-like robot. 

Both are quadrupedal robots that were developed as part of the 10-week undergraduate research program completed during summer 2023. As previously stated, both have been built out of a combination of VEX hardware, lasercut MDF wood, and 3D-printed parts.

| <img src="https://github.com/PritRaj1/QuadBot-NeuroMorphic/blob/main/NeuroPup%20-%20Dog%20Robot/NeuroPup.jpg" width="350" alt="NeuroPup"> | <img src="https://github.com/PritRaj1/QuadBot-NeuroMorphic/blob/main/Synapider%20-%20Spider%20Robot/Synapider.jpg" width="350" alt="Synapider"> |
|:--:|:--:|
| *NeuroPup* | *Synapider* |


Please also watch the video linked [here](https://youtu.be/NR2hcypiejE), which serves as a brief introduction regarding the use of the VEX robots. Pay close attention to the process of 'waking up' the Brain after powering it down. It's important to note that executing a program immediately after powering down the Brain will not yield any behavior. In such cases, you must restart the program. This behavior is observed specifically after power cycling the VEX Brain. However, if you avoid powering it down between program executions, there is no need to restart the program; it will run successfully on the first attempt.

**Please be aware that the VEX Brain imposes a minimum flashable sampling time of 0.001 seconds. Consequently, before uploading any Simulink models that incorporate the MQIF Neuron to the VEX Brain, please ensure that the fixed time-step solver is configured with a time step of 1e-3. This time step is also specifically stable for solving the MQIF ODEs. Using a larger time step may result in incorrect solutions/instability, while a smaller time step will not load onto the VEX Brain.**

You may also find [this video](https://youtu.be/GqSq24PBeaw) helpful - which demonstrates how to flash to the V5 Brain.

Two videos have been recorded to introduce you to the two robots. They are recommended viewing, as some advice is also provided regarding their usage:
1. [Introducing NeuroPup!](https://youtu.be/5darLvzCVpE)
2. [Introducing Synapider!](https://youtu.be/WLrbr75hk20)

#### 'NeuroPup - Dog Robot' Directory
Contained within this directory are various Simulink models that were flashed onto the dog-like robot. 

* **'DogGait_sine.slx':** This file contains a basic gait pattern composed of sinusoidal movements, which can be replicated using MQIF neuronal circuits. To see this gait in action, use the 'stand' and 'walk' buttons, as demonstrated in the [Introducing NeuroPup!](https://youtu.be/5darLvzCVpE) video.
* **'DogHalfCentre_SingleLeg.slx':** This program serves as a simple demonstration of how an oscillator, constructed using a half-center central pattern generator, can leverage the particular mechanical design of NeuroPup's legs to produce rhythmic extension-contraction movements.
* **'NeuromorphicDogGait_WalksBackwards.slx':** This file showcases the application of a more intricate circuit, which we have started calling the 'Quad-centre CPG' (Central Pattern Generator), to generate a complex gait pattern. In this specific example, the gaiting pattern is designed to make the dog walk in reverse. For a brief explanation of how this was achieved, please watch the [Neuromorphic Gaiting](https://youtu.be/aiv5ElMc6nQ) video.

#### 'Synapider - Spider Robot' Directory 
Within this directory are various Simulink models that were flashed onto the spider-like robot. 

* **'SpiderGait_Sine.slx'**: This file showcases a fundamental gait pattern using sinusoidal movements, replicable through MQIF neuronal circuits. 
* **'SpiderGait_Better.slx'**: This is a small evolution on the SpiderGait_Sine.slx, in which the sinusoidal signals have undergone some post-processing to produce motions more akin to 'stepping'. In particular, this is the gait deomstrated in the [Introducing Synapider!](https://youtu.be/WLrbr75hk20) video.
* **'SpiderHalfCentre_SingleLeg.slx'**: This program provides a straightforward illustration of how an oscillator, created using a half-center central pattern generator, make use of Synapider's leg mechanics to generate rhythmic motions.

## Future Work

Amidst the demands of attending lectures and the pressing deadlines for my Master's thesis, I aim to focus on enhancing this repository by achieving the following objectives:

1. **Library Integration:** I hope to streamline the use of neurons, CPGs (Central Pattern Generators), and oscillators within Simulink by encapsulating them within a dedicated Simulink library. This modification will eliminate the need for repetitive copying and pasting of neurons into Simulink models, facilitating a more seamless and efficient integration process.

2. **Parallelization of Characterization Scripts:** The current characterisation scripts encounter performance bottlenecks due to the extensive simulations required to analyze the behaviors of neurons under various parameter variations. To enhance efficiency, I intend to parallelise these scripts, thereby significantly reducing the execution time and enabling quicker assessments.

3. **Versatile CPG Development:** My goal is to expand the capabilities of the Central Pattern Generators (CPGs). Specifically, I am interested in creating a "tri-center" CPG as it holds the potential for generating versatile sine-like outputs. By leveraging the three spike trains at its output, this configuration might be able to synthesise diverse sinusoidal signals without the intricacies associated with a "quad-center" CPG. Hopefully, this approach may also lead to a more manageable feedback mechanism.

Godspeed, and enjoy tinkering!






