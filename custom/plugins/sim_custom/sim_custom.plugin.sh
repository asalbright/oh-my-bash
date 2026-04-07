#! bash oh-my-bash.module
## Robot simulation workflow aliases for Isaac Sim and MuJoCo

## Optional: activate the IsaacLab conda/venv environment on shell start
# conda activate isaaclab
# source /workspace/IsaacLab/.venv/bin/activate

## Isaac Sim
alias workbench="python /workspace/IsaacLab/source/design_lab/scripts/workbench/cli.py"
alias gantry="python /workspace/IsaacLab/source/design_lab/scripts/gantry/cli.py"
alias isaac="/workspace/IsaacLab/isaaclab.sh -s --allow-root"
alias isaac-headless="/workspace/IsaacLab/isaaclab.sh -s --allow-root --headless"
alias isaacpython="/workspace/IsaacLab/isaaclab.sh -p"
alias isaactest="/workspace/IsaacLab/isaaclab.sh -t"

## Isaac workspace navigation
alias cdisaac="cd /workspace/IsaacLab"
alias cddesignlab="cd /workspace/IsaacLab/source/design_lab"

## MuJoCo
alias mujoco="python -m mujoco.viewer"
alias mujoco-model="python -m mujoco.viewer --mjcf"
