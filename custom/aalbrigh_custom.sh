# Java versioning
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# For my development containers
export USER_UID=$(id -u $USER)
export USER_GID=$(id -g $USER)

# AFAICT this is the default for most (all?) prebuilt images
export CONTAINER_USER_UID=1000
export CONTAINER_USER_GID=1001

# For ROS2
export RCUTILS_COLORIZED_OUTPUT=1
