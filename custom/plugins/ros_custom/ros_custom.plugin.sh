## Attempt to source a ros2 distro setup.bash
ROS_DISTROS_DIR=($(ls /opt/ros/))
# Try and source them in an order according to newest to oldest release
INSTALLED_DISTROS=("noetic")
for distro in "${INSTALLED_DISTROS[@]}"
do
    if [[ " ${ROS_DISTROS_DIR[@]} " =~ " ${distro} " ]]; then
        source /opt/ros/${distro}/setup.bash >/dev/null 2>&1
    fi
done 

# Check to make sure ROS_DISTRO is set
if [ -z "$ROS_DISTRO" ]; then
    echo "ROS_DISTRO is not set. Cannot really make use of the ROS Custom Oh My Bash plugin ..."
    return
fi

## ROS Aliases
alias sdsb="source devel/setup.bash"
alias $ROS_DISTRO="source /opt/ros/${ROS_DISTRO}/setup.bash"