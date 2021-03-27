Linux Nvidia GPU Controller

This script is tested only on Ubuntu 20.04.2
It will NOT work on Windows, either through command line, WSL 2, or a linux VM.
Please verify that you have the latest Nvidia Driver installed for your GPU.
This script will NOT work with AMD GPUs.

Run the following commands prior to use:
Allows manual fan control of GPU fans:
sudo nvidia-xconfig --allow-empty-initial-configuration --enable-all-gpus --cool-bits=7

The data.txt file contains the information to be inputted for the fan curve. The first column are indices for the temperatures for all 3 modes. The second column are the fan speed values for the quiet mode. The third column contains the fan speed values for the normal mode, and the fourth column contains the fan speed values for the performance mode. These values can be adjusted to set a personalized fan curve.
