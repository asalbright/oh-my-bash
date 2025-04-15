# If /entrypoint.sh is available, source it
if [ -f /entrypoint.sh ]; then
    source /entrypoint.sh
fi

if [ -f /entrypoint.bash ]; then
    source /entrypoint.bash
fi