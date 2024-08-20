## Attempt to source a ros2 distro setup.bash
ROS_DISTROS_DIR=($(ls /opt/ros/))
# Try and source them in an order according to newest to oldest release
INSTALLED_DISTROS=("humble" "galactic" "foxy")
for distro in "${INSTALLED_DISTROS[@]}"
do
    if [[ " ${ROS_DISTROS_DIR[@]} " =~ " ${distro} " ]]; then
        source /opt/ros/${distro}/setup.bash >/dev/null 2>&1
    fi
done 

# Check to make sure ROS_DISTRO is set
if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set. Cannot really make use of the ROS2 Custom Oh My Bash plugin ..."
    return
fi

## ROS Aliases
alias sisb="source install/setup.bash"
alias $ROS_DISTRO="source /opt/ros/${ROS_DISTRO}/setup.bash"

## DDS Implementation

# Get the directory to the DDS Profiles
THIS_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DDS_PROFILES_DIR=$THIS_SCRIPT_DIR/dds_profiles

################################ PICK ONE OF THE BELOW ################################
# Use fastrtps as the DDS implementation
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp

# Use cyclonedds as the DDS implementation
# export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
########################################################################################

################################ PICK ONE OF THE BELOW ################################
# Export the DDS_PROFILES_DIR
export FASTRTPS_DEFAULT_PROFILES_FILE="$DDS_PROFILES_DIR/fastdds_localhost_only.xml"
# export FASTRTPS_DEFAULT_PROFILES_FILE="$DDS_PROFILES_DIR/fast_dds_docker_to_host.xml"

# Export the Cyclone DDS profile
# Make sure ROS_DISTRO is set
# export CYCLONEDDS_URI="$DDS_PROFILES_DIR/cyclone_${ROS_DISTRO}_localhost_only.xml"
########################################################################################
