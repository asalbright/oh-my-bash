# Project: dds_profiles

# Overview

This repo provides some useful DDS profiles to alleviate some of the issues we've seen with excessive DDS network traffic and lack of transparency on developer machines. 

There are two primary DDS setups we've used within the DRT: FastDDS and CycloneDDS. DDS profiles by their nature are vendor-specific and change over time, so profiles are divided up first by ROS2 release, then by vendor and function. The vendor name is part of the profile filename so that when a profile is referenced in the environment it is clear which vendor is in play. It is recommended that profiles with similar goals are named similarly: fastdds_localhost_only.xml and cyclonedds_localhost_only.xml, for example. 

When adding a profile, please include some comments in the file explaining what the profile is intended to achieve. See fastdds_localhost_only.xml for an example.

# Deploying a Profile

In general, it is strongly preferred to keep profiles within this repo and check out the repo into a git area (e.g. ~/git). This makes it easy to update the profile if a bug is found or vendor semantics change. This also sets up a common understanding of where to look to help in diagnosing problems.

So far as using a profile goes, this is done by setting an environment variable pointing to the profile of interest. Note that this variable needs to be set in every terminal where a ros2 node or command may be run. For this reason, it is typically easiest to set the profile in ~/.bashrc or in some environment file that sourced as a matter of course before bringing up nodes.

For FastDDS, ```export FASTRTPS_DEFAULT_PROFILES_FILE=<path to profile file>```

For CycloneDDS, ```export CYCLONEDDS_URI=<path to profile file>```

```<path to profile file>``` should be an absolute path since we will not always have control of where a node is launched.

## Authors and acknowledgment

Emma Zemler <emma.zemler@nasa.gov> and Mark Paterson <mark.paterson@nasa.gov>.

## License

N/A -- there's no source code here.
