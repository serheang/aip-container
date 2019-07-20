# AIP Container
A singularity container for NodeJS, SQLite3, MongoDB and VS Code web development.

This is used for the subject Advanced Internet Programming (AIP) at UTS.

# Configuration

Configuration is stored in the file ~/.config/aip_container:

    # The existence of base path is checked before starting the container
    BASE_PATH="/tmp"

    # The host path is then created if it doesn't exist
    # (set BASE_PATH and HOST_PATH to be the same if you don't want directories to be created)
    HOST_PATH="/tmp/$USER/aip"

    # This array of files is symlinked to the corresponding files in your $HOME
    SYMLINK=(".gitconfig" ".ssh")

# Usage

Use run_aip_singularity_container.sh to start the container:

    run_aip_singularity_container.sh term      # Start a gnome-terminal
    run_aip_singularity_container.sh vscode    # Start visual studio code
    run_aip_singularity_container.sh fullterm  # Start a gnome-terminal-server and gnome-terminal
