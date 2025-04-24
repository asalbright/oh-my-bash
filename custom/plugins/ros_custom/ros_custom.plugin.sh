## Attempt to source a ros2 distro setup.bash
ROS_DISTROS_DIR=/opt/ros/
INSTALLED_DISTROS=("noetic")

# Check if any of the distros are installed
if [ ! -d "$ROS_DISTROS_DIR" ]; then
    echo "ROS is not installed. Cannot really make use of the ROS Custom Oh My Bash plugin ..."
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
alias sdsb="source devel/setup.bash"
alias $ROS_DISTRO="source /opt/ros/${ROS_DISTRO}/setup.bash"