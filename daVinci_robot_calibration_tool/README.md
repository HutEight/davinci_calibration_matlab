# Da Vinci Calibration Matlab Auxiliary 
This is a MatLab repository that contains several tools to help the intrinsic calibration of a da Vinci robot Patient Side Manipulator (PSM). 

## Getting Started

### Prerequisites
You need to install MatLab to run the codes. Also, you need to have a da Vinci robot and you need to have related data acquisition codes to gather data for the tools in this repository to process. 

## Tools

### A. [PSM Intrinsic Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool)

The goal of the intrinsic calibration is to partially discover the DH parameters for the PSM. Currently the user is able to find DH frame 0 and 1's full definition, d3, and scale factors of Joint 1, 2 and 3, with the help of this tool.

#### Pipeline

1. Collect the PSM's Joint 2 encoder calibration data.
2. Collect the PSM's intrinsic calibration data.
3. Collect the PSM's calibration quality test data.
4. Run the Matlab programmes that analysis the above data


#### Data Collection Steps & Usage

##### Intrinsic Calibration

You need to first calibrate the Joint 2 scale factor. To do this, you need to **position the Polaris sideway** and collect the Joint 2 only data. Next, you do the rest of the PSM intrinsic calibration by collecting Joint 1 and 2 arcs, and 5 small spheres of Joint 4 and 5, to determine the DH 0 and 1 parameters and Joint 3 scale factor. Normally you would need to **reposition** the Polaris before you collect the data depending on the script you run.

1. Data set #1: Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package J2 encoder test script and follow the instructions displayed on your terminal.
1. Collect the Joint 2 Encoder Test data and place them into the /Data folder of this tool.
1. Run [j2_encoder_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/j2_encoder_quality_main.m) to **first** get the Joint 2 scale factor. You can do this after you collect all three data sets as well.
1. Data set #2: Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package PSM intrinsic calibration script and follow the instructions displayed on your terminal.
1. Collect the PSM intrinsic calibration data and place them into the /Data folder of this tool. 
1. Run [test_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/test_main.m) You can do this after you collect all three data sets as well.
1. Go to your data folder and you can find all the output from the MatLab tool. Note that the Polaris to Base frame transform is also included in the output.
1. You will need to use the values from the *DH_parameters_recommendation.txt* file to update your cwru_davinci_kinematics package's config file. You will also find the Base to Polaris transform for the current lab configuration in *DH_frames_info.txt*.

Note that if you rotate the passive joints so that the base z is not (anti)parallel to gravity then you can expect to see significant (arund 1 mm) changes in DH a2, d2, and d3.

##### Calibration Quality Test

There are 8 sets of joint space values that would order the Robot to always go to the same points. Their Cartesian space coordinates would change if you have updated your kinematics configuration files. You can read these points from the Polaris as you are not supposed to move the Polaris throughout the entire calibration and testing process. You then use the Polaris to PSM base frame transform, and the updated forward kinematics, to calculate the error between the two points in these 8 pairs. 

1. Data set #3: Run the [rn_davinci_automatic_calibration](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II) package intrinsic quality test script and follow the instructions displayed on your terminal. 
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

#### Data Collection and Analysis Steps & Usage

You need to create data collection (cube) playfiles first for both PSMs. And then use the data to first get the transform between the Polaris to PSMs. Then you can calculate the transformation between the PSMs. Then you will need to verify the result you get by running a new palyfile that asks both PSMs to go to the same cube. Finally you can see how well the matching is and opt to improve that with the verification data as well. 

Follow the instructions in the scripts. 

**Make sure you use Frozen Wrist Version of Kinematics while running the data acquisition playfiles.** 

1. Run [generate_PSM1_frozen_grid_playfile_main_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_XI/daVinci_robot_calibration_tool/Tool_dual_arm_calibration_tool/generate_PSM1_frozen_grid_playfile_main_CUBE.m) and [generate_PSM2_frozen_grid_playfile_main_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_XI/daVinci_robot_calibration_tool/Tool_dual_arm_calibration_tool/generate_PSM2_frozen_grid_playfile_main_CUBE.m) and copy and paste your newly generated playfiles to the corresponding folder in [Dual Arm Calibration Tool](https://github.com/HutEight/davinci_calibration_matlab/tree/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool). This step will produce the following:
* psm1_pts_generated_cube

* psm2_pts_generated_cube

2. Run the scripts in the [Da Vinci Automatic Calibration Tool](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II/scripts) and copy and paste your collected data back to the same directory containing your generated point mats and playfiles. 

3. Run [process_PSM1_grid_data_CUBE_Tom_polaris.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_XI/daVinci_robot_calibration_tool/Tool_dual_arm_calibration_tool/process_PSM1_grid_data_CUBE_Tom_polaris.m) and [process_PSM2_grid_data_CUBE_Tom_polaris.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_XI/daVinci_robot_calibration_tool/Tool_dual_arm_calibration_tool/process_PSM2_grid_data_CUBE_Tom_polaris.m). This step will produce the following:
* psm1_pts_Polaris_cube

* psm2_pts_Polaris_cube

4. Run [dual_PSMs_match_CUBE.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_dual_arm_calibration_tool/dual_PSMs_match_CUBE.m) and get the initial matching results. This step will use the above 4 parameters yielded by previous steps to produce the following:
* affine_psm2_wrt_psm1

* affine_psm1_wrt_polaris

* affine_psm2_wrt_polaris

5. Run [Generate_dual_arm_calibration_polaris_evaluation_main.m]() and get the new playfile printed on the console. Copy and paste the playfiles to the [Da Vinci Automatic Calibration Tool](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II/scripts) and collect the data. 

6. Run [process_DUAL_evaluation_data_CUBE.m]() and it will refine the PSM1 PSM2 transform and produce:
* additional_affine_psm_2_init_to_2_refined_in_polaris_frame

7. Re-run [Generate_dual_arm_calibration_polaris_evaluation_main.m]() and get:
* adjusted_affine_psm1_wrt_psm2

8. You should get a new PMS2 playfile from step 7. Copy and paste the playfiles to the [Da Vinci Automatic Calibration Tool](https://github.com/HutEight/rn_davinci_automatic_calibration/tree/MK_II/scripts) and collect the data. 

9. Re-run [process_DUAL_evaluation_data_CUBE.m]() and see if you are satisfied with the result. If not, repeat step 6 - 9. Once you get your desired result, you should use **adjusted_affine_psm1_wrt_psm2** to describe the relationship between the two PSMs. 

You can then proceed to do some demo with the transform results you just find from above. 

#### PSM-Camera Cube Test

You need to collect the camera data of 3D coordinates of a piece of marker, or a retro-reflective tape 

#### Dual PSM calibration Demos



