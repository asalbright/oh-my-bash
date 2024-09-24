#! bash oh-my-bash.module
# Author: Enzo Arroyo <enzo@arroyof.com>

# Functions
function vagrant-version() {
  vagrant --version
}

function vagrant-init() {
  if [[ $1 ]]; then
    _omb_util_print "Vagrant init for : $1 Creating...."
    vagrant init -m "$1"
  else
    _omb_util_print "Usage : vai <box name>" >&2
    _omb_util_print "Example : vai centos/7" >&2
    return 2
  fi
}

function vagrant-up() {
  if [[ $1 ]]; then
    _omb_util_print "Vagrant up for provider : $1 Running...."
    vagrant up --provider "$1"
  else
    _omb_util_print "Vagrant up for provider : virtualbox Running...."
    vagrant up
  fi
}

function vagrant-plugin-vm() {
  case "$1" in
  "virtualbox")
    _omb_util_print "Vagrant plugin install for provider : $1 Running...."
    vagrant plugin install vagrant-vbguest
    ;;
  "libvirt")
    _omb_util_print "Vagrant plugin install for provider : $1 Running...."
    vagrant plugin install vagrant-libvirt
    ;;
  *)
    _omb_util_print "Usage : vapvm <provider name>" >&2
    _omb_util_print "Example : vapvm virtualbox" >&2
    return 2
    ;;
  esac
}

function vagrant-status() {
  if [[ -f Vagrantfile ]]; then
    vagrant status
  else
    vagrant global-status
  fi
}

function vagrant-ssh() {
  local VMCOUNT
  VMCOUNT=$(vagrant status | grep -c running)
  local VMDEFAULT
  VMDEFAULT=$(vagrant status | grep -w default | grep -c running)

  if ((VMDEFAULT == 1)); then
    if [[ $1 ]]; then
      _omb_util_print "SKIP : $1 Server...."
    fi
    _omb_util_print "Login to : default Server...."
    vagrant ssh
  elif [[ $1 ]] && ((VMCOUNT > 1)); then
    _omb_util_print "Login to : $1 Server...."
    vagrant ssh "$1"
  elif ((VMCOUNT == 0)); then
    _omb_util_print "Seems like that not there running servers" >&2
    return 1
  else
    _omb_util_put $'Please choose a server from this list:\n\n'
    vagrant status | awk '/running/{print $1}'
    _omb_util_put $'\nThen fill: vagrant ssh [ option ]\n'
  fi
}


# Aliases
alias va='vagrant'
alias vaver='vagrant-version'
alias vaconf='vagrant ssh-config'
alias vastat='vagrant-status'
alias vacheck='vagrant validate'
alias vaport='vagrant port'
alias vapvm='vagrant-plugin-vm'
alias vapi='vagrant plugin install'
alias vapr='vagrant plugin uninstall'
alias vau='vagrant-up'
alias vah='vagrant halt'
alias vat='vagrant destroy -f'
alias vai='vagrant-init'
alias varel='vagrant reload'
alias vassh='vagrant-ssh'
alias vaba='vagrant box add'
alias vabr='vagrant box remove'
alias vavl='vagrant box list'
