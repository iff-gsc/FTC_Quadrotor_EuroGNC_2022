# Incremental Passive Fault-Tolerant Control for Quadrotors With up to Three Successive Rotor Failures

This repository contains the source code used for the research results in Ref. [1].
The publication is about passive fault-tolerant control of quadrotors subject to complete rotor failures. 
Passive means that the error does not have to be detected.
The controller presented here is based on the methods of Incremental Nonlinear Dynamic Inversion (INDI) and Control Allocation (CA) with prioritization of roll and pitch attitude over yaw.
This code can be used to reproduce the figures from Ref. [1], on the one hand, and to investigate other rotor failures in simulation, on the other.
For further information see Ref. [1].

<div align="center">
<h3>Flight Test Video</h3>
  <a href="https://youtu.be/g6vfgj2IRvE">
    <img 
      src="https://img.youtube.com/vi/g6vfgj2IRvE/0.jpg" 
      alt="Flight test" 
      style="width:50%;">
  </a>
</div>


## Reference

[1] Beyer, Y., G&uuml;cker, F., Bremers, E., Steen, M., & Hecker, P. (2022). Incremental Passive Fault-Tolerant Control for Quadrotors With up to Three Successive Rotor Failures. In _6th CEAS Conference on Guidance, Navigation and Control (EuroGNC) 2022_.

If you use this code in an academic work, please cite:

    @inproceedings{beyer2022incremental,
      title={Incremental Passive Fault-Tolerant Control for Quadrotors With up to Three Successive Rotor Failures},
      author={Beyer, Yannic, G\"ucker, Fabian, Bremers, Eike, Steen, Meiko and Hecker, Peter},
      booktitle={6th CEAS Conference on Guidance, Navigation and Control (EuroGNC) 2022},
      year={2022}
     }


## Installation

- **MATLAB:**  
  - You need MATLAB/Simulink 2018b or later (older versions may work but they are not supported).
  - You also need the following MATLAB toolboxes:
    - Curve Fitting Toolbox (purpose: propeller map interpolation; if you don't have it, you can replace the propeller map interpolation with the simple propeller model in Ref. [1])  
    - Aerospace Blockset, Aerospace Toolbox (purpose: receive ground altitude from FlightGear visualization; if you don't have it, you can comment out the Simulink block _Environment/From FlightGear_)  
    - Simulink Coder, MATLAB Coder (purpose: only for code generation for flight tests; if you don't have it, you can still run the simulations)

- **This repository:**  
  Clone this project including the submodules LADAC and LADAC-Example-Data:
  ```
  git clone --recursive https://github.com/iff-gsc/ftc_quadrotor_eurognc_2022.git
  ```

- **FlightGear (optional; for visualization):** 
  - You should install FlightGear for visualization.
  Tested versions are FlightGear 3.4.0 and FlightGear 2019.1.1 but others should also work.
  - On Windows you have to copy and paste the folder _<ftc_quadrotor_eurognc_2022>/libraries/ladac-examples-data/FlightGear/<models>_ into _$FG_HOME/Aircraft/_

- **ArduPilot SITL (optional; for software in the loop (SITL) tests):**  
  - You can install [ArduPilot SITL](https://ardupilot.org/dev/docs/sitl-simulator-software-in-the-loop.html) if you want to do software in the loop simulations.
  - The controller of this project was implemented in an ArduPilot fork. Clone it: 
    ```
    git clone --recursive -b EuroGNC_2022_flight_test https://github.com/ybeyer/ardupilot.git
    ```
  - Ground control station: You may install a ground control station like QGroundControl or MissionPlanner for communication with ArduPilot SITL.



## Example

Open and run `paper_plots` in _<ftc_quadrotor_eurognc_2022>/scripts/_ in MATLAB (if it is not on the MATLAB path already, click _Change Folder_ or _Add to Path_).
After some time the figures of Ref. [1] will appear.

If you want to visualize the quadrotor, start FlightGear by executing `runfg_IRIS.sh` (Linux) or `runfg_IRIS.bat` which are located in _<ftc_quadrotor_eurognc_2022>/libraries/ladac-examples-data/FlightGear/_.


## How to use?

- Customize simulation:  
  - You can initialize the simulation (quadrotor model and controller) by running `init_Minnie_Loiter_FTC` in _<ftc_quadrotor_eurognc_2022>/scripts/_.
  - You can change the parameters `failure_...` in order to create different failure scenarios.

- ArduCopter SITL:  
  - In MATLAB run `init_Minnie_ArduPilot_SITL` in the _scripts_ subfolder.
  - Start the Simulink model `QuadcopterSimModel_ArduPilot_SITL`.
  - Go to the ArduPilot fork (tag EuroGNC_2022_flight_test) and run in terminal (assuming this repo is located beside the ArduPilot fork on your machine):
    ```
    Tools/autotest/sim_vehicle.py --vehicle=ArduCopter --add-param-file=../ftc_quadrotor_eurognc_2022/ardupilot_implementation/params/Minnie.parm --model=gazebo
    ```
  - Enter the MATLAB/Simulink flight mode by entering the following in the same terminal:
    ```
    mode 29
    ```
  - You can use a remote control (via ground control station) or MAVProxy commands to control the quadrotor or to inject rotor failures.
  Rotor failures can be trigger with RC 7 and RC 8 (see `ArduCopter_MinnieLoiterFtc`).

- Update ArduCopter controller:  
  - run `initInterfacesBuses`
  - update the controller in `ArduCopter_MinnieLoiterFtc` located in the _<ftc_quadrotor_eurognc_2022>/ardupilot_implementation_ subfolder
  - Build `ArduCopter_MinnieLoiterFtc`.
  - Proceed as described in the [LADAC documentation](https://github.com/iff-gsc/LADAC/tree/3ed2e0b20c86ccebbe3ed9ab1a3854286af4b962/utilities/interfaces_external_programs/ArduPilot_custom_controller).


## What to do in case of problems?

If something does not work or if you get stuck, please submit an [issue](https://github.com/iff-gsc/FTC_Quadrotor_EuroGNC_2022/issues).






