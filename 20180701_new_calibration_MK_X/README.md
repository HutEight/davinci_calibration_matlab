# Da Vinci Calibration Matlab Auxiliary 
This is a MatLab repository that contains several tools to help the intrinsic calibration of a da Vinci robot Patient Side Manipulator (PSM). 

## Getting Started

### Prerequisites
You need to install MatLab to run the codes. Also, you need to have a da Vinci robot and you need to have related data acquisition codes to gather data for the tools in this repository to process. 

## Tools

### PSM Intrinsic Calibration Tool
The goal of the intrinsic calibration is to partially discover the DH parameters for the PSM. Currently the user is able to find DH frame 0 and 1's full definition, d3, and scale factors of Joint 1, 2 and 3, with the help of this tool.

#### Data Collection Steps & Usage

##### Intrinsic Calibration
You need to first calibrate the Joint 2 scale factor. To do this, you need to position the Polaris sideway and collect the Joint 2 only data. Then you do the rest of the calibration by collecting Joint 1 and 2 arcs, and 5 small spheres of Joint 4 and 5. 

1. Run the *rn_davinci_automatic_calibration* package J2 encoder test script and follow the instructions displayed on your terminal.
1. Collect the Joint 2 Encoder Test data and place them into the /Data folder of this tool.
1. Run [j2_encoder_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/j2_encoder_quality_main.m) to **first** get the Joint 2 scale factor.
1. Run the *rn_davinci_automatic_calibration* package PSM intrinsic calibration script and follow the instructions displayed on your terminal.
1. Collect the PSM intrinsic calibration data and place them into the /Data folder of this tool.
1. Run [test_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/test_main.m) 
1. Go to your data folder and you can find all the output from the MatLab tool. Note that the Polaris to Base frame transform is also included in the output.
1. You will need to use the values from the *DH_parameters_recommendation.txt* file to update your cwru_davinci_kinematics package's config file.

##### Calibration Quality Test
There are 8 sets of joint space values that would order the Robot to always go to the same points. Their Cartesian space coordinates would change if you have updated your kinematics configuration files. You can read these points from the Polaris as you are not supposed to move the Polaris throughout the entire calibration and testing process. You then use the Polaris to PSM base frame transform, and the updated forward kinematics, to calculate the error between the two points in these 8 pairs. 

1. Run the *rn_davinci_automatic_calibration* package intrinsic quality test script and follow the instructions displayed on your terminal. 
1. Collect the data and place them into the /Data folder of this tool.
1. Run the *cwru_davinci_kinematics* package PSM calibration auxiliary code and keep the terminal alive.
1. Run the [calibration_quality_main.m](https://github.com/HutEight/davinci_calibration_matlab/blob/Mark_X/20180701_new_calibration_MK_X/Tool_PSM_intrinsic_calibration_tool/calibration_quality_main.m) and get your results.


### Virtual Intrinsic Data Spawner



### Dual Arm Calibration Tool