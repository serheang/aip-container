#!/usr/bin/env bash

# First parameter to this script is the container app name, defaulting to term
APP=${1:-term}

# Singularity image to use
SIF=aip.sif

# Setup defaults to use if .config/aip_container is not present
BASE_PATH="/tmp"
HOST_PATH="/tmp/$USER/aip"
SYMLINK=(".gitconfig")

# Read the config file in ~/.config/aip_container
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/aip_container"
if [ -f "$CONFIG_FILE" ]
then
    source "$CONFIG_FILE"
fi

# Only create a workspace if BASE_PATH exists (i.e., is mounted)
if [ -d "$BASE_PATH" ]
then
    # Ensure the HOST_PATH exists
    export SINGULARITYENV_HOST_PATH="$HOST_PATH"
    (umask 077 && mkdir -p "$SINGULARITYENV_HOST_PATH")

    # Create symlinks for important files
    for f in "${SYMLINK[@]}"
    do
        if [ ! -e "$HOST_PATH/$f" ] && [ ! -L "$HOST_PATH/$f" ]
        then
            ln -s "/host$HOME/$f" "$HOST_PATH/$f"
        fi
    done

    # Create a default .bashrc, if none exists
    if [ ! -e "$HOST_PATH/.bashrc" ] && [ ! -L "$HOST_PATH/.bashrc" ]
    then

        cat > "$HOST_PATH/.bashrc" <<EOM
echo
echo "You are using a container."
echo "Your home is bound to $(tput bold)$HOST_PATH$(tput sgr0) on the host."
if [[ $HOST_PATH == *"/tmp/"* ]]; then
    echo "Ensure your changes are saved or committed before leaving."
fi
echo
export PS1="[container \W]\\$ "
EOM

    fi

    # Because we've bound a custom home, we need to handle .Xauthority
    XAUTH="$SINGULARITYENV_HOST_PATH/.Xauthority"
    touch "$XAUTH"
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -

    # Launch the container
    singularity run --app $APP -B /home:/host/home -B "$SINGULARITYENV_HOST_PATH":/home/$USER -B /run $SIF
else
    echo "BASE_PATH ($BASE_PATH) does not exist, will not create HOST_PATH."
    echo "Container start failed"
    
    # Show a GUI dialog
    python2 -c "import Tkinter;r=Tkinter.Tk();r.withdraw();import sys;import tkMessageBox;tkMessageBox.showerror('Cannot start container', 'Container base path does not exist:\n' + sys.argv[1] + '\n\nPlease check any required disk drives (or USB memory sticks) are mounted.\n\nYour base path is configured in:\n' + sys.argv[2]);" "$BASE_PATH" "$CONFIG_FILE"
    
    exit 1
fi
