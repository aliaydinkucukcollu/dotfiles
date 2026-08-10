# =========================
# Color
# =========================
RED='\033[0;31m'        # red
GREEN='\033[0;32m'      # green
YELLOW='\033[1;33m'     # yellow
BLUE='\033[1;34m'       # blue
NC='\033[0m'            # no color

# =========================
# Git branch
# =========================
git_branch() {
    # -- Finds and outputs the current branch name by parsing the list of
    #    all branches
    # -- Current branch is identified by an asterisk at the beginning
    # -- If not in a Git repository, error message goes to /dev/null and
    #    no output is produced
    git branch --no-color 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

git_status() {
    # Outputs a series of indicators based on the status of the
    # working directory:
    # + changes are staged and ready to commit
    # ! unstaged changes are present
    # ? untracked files are present
    # S changes have been stashed
    # P local commits need to be pushed to the remote
    local status="$(git status --porcelain 2>/dev/null)"
    local output=''
    [[ -n $(egrep '^[MADRC]' <<<"$status") ]] && output="$output+"
    [[ -n $(egrep '^.[MD]' <<<"$status") ]] && output="$output!"
    [[ -n $(egrep '^\?\?' <<<"$status") ]] && output="$output?"
    [[ -n $(git stash list) ]] && output="${output}S"
    [[ -n $(git log --branches --not --remotes) ]] && output="${output}P"
    [[ -n $output ]] && output="|$output"  # separate from branch name
    echo $output
}

git_color() {
    # Receives output of git_status as argument; produces appropriate color
    # code based on status of working directory:
    # - White if everything is clean
    # - Green if all changes are staged
    # - Red if there are uncommitted changes with nothing staged
    # - Yellow if there are both staged and unstaged changes
    local staged=$([[ $1 =~ \+ ]] && echo yes)
    local dirty=$([[ $1 =~ [!\?] ]] && echo yes)
    if [[ -n $staged ]] && [[ -n $dirty ]]; then
        echo -e '\033[0;33m'  # bold yellow
    elif [[ -n $staged ]]; then
        echo -e '\033[0;32m'  # bold green
    elif [[ -n $dirty ]]; then
        echo -e '\033[0;31m'  # bold red
    else
        echo -e '\033[0;37m'  # bold white
    fi
}

git_prompt() {
    # First, get the branch name...
    local branch=$(git_branch)
    # Empty output? Then we're not in a Git repository, so bypass the rest
    # of the function, producing no output
    if [[ -n $branch ]]; then
        local state=$(git_status)
        local color=$(git_color $state)
        # Now output the actual code to insert the branch and status
        #echo -e "\x01$color\x02[$branch$state]\x01\033[00m\x02"  # last bit resets color
	echo -e "\x01$color\x02($branch$state)\x01\033[00m\x02 "  # last bit resets color
    fi
}


# =========================
# ROS environment
# =========================
parse_ros_distro() {
    if [[ -n "$ROS_VERSION" && -n "$ROS_DISTRO" ]]; then
        echo "[ROS${ROS_VERSION}-${ROS_DISTRO}] "
    fi
}

# =========================
# Compiler
# =========================
parse_compiler() {
    if command -v clang++ &>/dev/null; then
        echo "Clang $(clang++ --version | head -n1 | awk '{print $3}')"
    elif command -v g++ &>/dev/null; then
        echo "GCC $(g++ -dumpversion)"
    fi
}

# =========================
# ROS2 Settings
# =========================
source /opt/ros/humble/setup.bash

# ros2 commands arg complete
source /opt/ros/humble/share/ros2cli/environment/ros2-argcomplete.bash

export RMW_IMPLEMENTATION=rmw_fastrtps_cpp # options: rmw_cyclonedds_cpp | rmw_fastrtps_cpp | rmw_connext_cpp |rmw_gurumdds_cpp
export ROS_DOMAIN_ID=9
export ROS_LOCALHOST_ONLY=0

source /usr/share/colcon_cd/function/colcon_cd.sh
export _colcon_cd_root=/opt/ros/humble/

# =========================
# Configs
# =========================
# export CC=gcc
# export CXX=g++

export CC=clang
export CXX=clang++

export EDITOR='vim'

export CLICOLOR=1

# =========================
# Bash prompt
# =========================
# export PS1='[$CXX] $(parse_ros_distro)\u@\h:\[\e[33m\]\W\[\e[0m\]$(git_prompt)\$ '
export PS1='\[\e[36m\][$CXX]\[\e[0m\] \[\e[34m\]$(parse_ros_distro)\[\e[0m\]\u@\h:\[\e[33m\]\W\[\e[0m\]\[\e[35m\]$(git_prompt)\[\e[0m\]\$ '
