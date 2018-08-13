# Da Vinci Calibration Matlab Auxiliary 
This is a MatLab repository that contains several tools to help the intrinsic calibration of a da Vinci robot Patient Side Manipulator (PSM). 

## Getting Started

### Prerequisites
You need to install MatLab to run the codes. Also, you need to have a da Vinci robot and you need to have related data acquisition codes to gather data for the tools in this repository to process. 

## Tools

### A. [PSM Intrinsic Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool)

The goal of the intrinsic calibration is to partially discover the DH parameters for the PSM. Currently the user is able to find DH frame 0 and 1's full definition, d3, and scale factors of Joint 1, 2 and 3, with the help of this tool.

#### Data Collection Steps & Usage

##### Intrinsic Calibration

You need to first calibrate the Joint 2 scale factor. To do this, you need to position the Polaris sideway and collect the Joint 2 only data. Then you do the rest of the calibration by collecting Joint 1 and 2 arcs, and 5 small spheres of Joint 4 and 5. Normally you would need to reposition the Polaris before you collect the data for them.

1. Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package J2 encoder test script and follow the instructions displayed on your terminal.
1. Collect the Joint 2 Encoder Test data and place them into the /Data folder of this tool.
1. Run [j2_encoder_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/j2_encoder_quality_main.m) to **first** get the Joint 2 scale factor.
1. Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package PSM intrinsic calibration script and follow the instructions displayed on your terminal.
1. Collect the PSM intrinsic calibration data and place them into the /Data folder of this tool.
1. Run [test_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/test_main.m) 
1. Go to your data folder and you can find all the output from the MatLab tool. Note that the Polaris to Base frame transform is also included in the output.
1. You will need to use the values from the *DH_parameters_recommendation.txt* file to update your cwru_davinci_kinematics package's config file.

##### Calibration Quality Test

There are 8 sets of joint space values that would order the Robot to always go to the same points. Their Cartesian space coordinates would change if you have updated your kinematics configuration files. You can read these points from the Polaris as you are not supposed to move the Polaris throughout the entire calibration and testing process. You then use the Polaris to PSM base frame transform, and the updated forward kinematics, to calculate the error between the two points in these 8 pairs. 

1. Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package intrinsic quality test script and follow the instructions displayed on your terminal. 
1. Collect the data and place them into the /Data folder of this tool.
1. Run the [cwru_davinci_kinematics](https://github.com/HutEight/cwru_davinci_kinematics/tree/Mark_II) package PSM calibration auxiliary code and copy the following lines into you [calibration_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/calibration_quality_main.m):
```
    % ---
    wrist_pt_1 = [0.0248715 0.0162037 -0.142505 1];
    wrist_pt_2 = [-0.0105962   0.016136  -0.142282 1];
    wrist_pt_3 = [0.0254538 0.0509432 -0.144848 1];
    wrist_pt_4 = [-0.0105395  0.0507196  -0.143622 1];
    wrist_pt_5 = [0.0260648 0.0160171 -0.182585 1];
    wrist_pt_6 = [-0.0102634  0.0160341  -0.182159 1];
    wrist_pt_7 = [0.0265357 0.0515311 -0.184266 1];
    wrist_pt_8 = [-0.0101344  0.0513824  -0.183878 1];
    % ---
```
4. Run the [calibration_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/calibration_quality_main.m) and get your results.


### B. [Virtual Intrinsic Data Spawner](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_virtual_intrinsic_data_spawner)

This tool mimics the behaviour of a PSM with a given set of DH parameters. You can generate a simulated set of point cloud that can be used by the [PSM Intrinsic Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool)

#### Usage

##### Create the data set

##### Run the Simulated Intrinsic Calibration Tool


### C. [Dual Arm Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool)

This tool dose things that use rigid transform to match 2 sets of data, including registering a PSM base frame to a Polaris frame, or a Camera frame. If you register both PSMs into the same Polaris frame, then you get the transform between the 2 PSMs as well. Some demos (playfiles) can be generated by this tool as well.

#### Data Collection Steps & Usage

##### PSM-Polaris Cube Test

You need to create data collection (cube) playfiles first for both PSMs. Follow the instructions in the code. 

1. Run [generate_PSM1_frozen_grid_playfile_main_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/generate_PSM1_frozen_grid_playfile_main_CUBE.m) and [generate_PSM2_frozen_grid_playfile_main_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/generate_PSM2_frozen_grid_playfile_main_CUBE.m) and copy and paste your newly generated playfiles to the corresponding folder in [Dual Arm Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool).
1. Run the scripts in the [Dual Arm Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool) and copy and paste your collected data back to the same directory containing your generated point mats and playfiles. 
1. Run [process_PSM1_grid_data_CUBE_Tom_polaris.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/process_PSM1_grid_data_CUBE_Tom_polaris.m) and [process_PSM2_grid_data_CUBE_Tom_polaris.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/process_PSM2_grid_data_CUBE_Tom_polaris.m).
1. Run [dual_PSMs_match_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/dual_PSMs_match_CUBE.m) and get the final matching results. 

You can then proceed to do some demo with the transform results you just find from above. 

##### PSM-Camera Cube Test


