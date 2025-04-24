## Attempt to source a ros2 distro setup.bash
ROS_DISTROS_DIR=/opt/ros
INSTALLED_DISTROS=("rolling" "jazzy" "humble") # newest to oldest

# Check if any of the distros are installed
if [ ! -d "$ROS_DISTROS_DIR" ]; then
    echo "ROS2 is not installed. Cannot really make use of the ROS2 Custom Oh My Bash plugin ..."
    return
fi

# Try and source them in an order according to newest to oldest release
ROS_DISTROS_DIRS=($(ls $ROS_DISTROS_DIR))
for distro in "${INSTALLED_DISTROS[@]}"
do
    if [[ " ${ROS_DISTROS_DIRS[@]} " =~ " ${distro} " ]]; then
        source $ROS_DISTROS_DIR${distro}/setup.bash >/dev/null 2>&1
    fi
done 

## ROS Aliases
alias sisb="source install/setup.bash"
alias $ROS_DISTRO="source /opt/ros/${ROS_DISTRO}/setup.bash"

## DDS Implementation

# Get the directory to the DDS Profiles
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DDS_PROFILES_DIR=$THIS_SCRIPT_DIR/dds_profiles

################################ PICK ONE OF THE BELOW ################################
# Use fastrtps as the DDS implementation
# export RMW_IMPLEMENTATION=rmw_fastrtps_cpp

# Use cyclonedds as the DDS implementation
# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
########################################################################################

################################ PICK ONE OF THE BELOW ################################
# Export the DDS_PROFILES_DIR
# export FASTRTPS_DEFAULT_PROFILES_FILE="$DDS_PROFILES_DIR/fastdds_localhost_only.xml"
# export FASTRTPS_DEFAULT_PROFILES_FILE="$DDS_PROFILES_DIR/fast_dds_docker_to_host.xml"

# Export the Cyclone DDS profile
# Make sure ROS_DISTRO is set
# export CYCLONEDDS_URI="$DDS_PROFILES_DIR/cyclone_${ROS_DISTRO}_localhost_only.xml"
########################################################################################

# Colcon Completion
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# Colcon Build Flags
export RCUTILS_COLORIZED_OUTPUT=1
