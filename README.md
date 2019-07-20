# AIP Container
A singularity container for NodeJS, SQLite3, MongoDB and VS Code web development.

This is used for the subject Advanced Internet Programming (AIP) at UTS.

# Configuration

Configuration is optional. If there is no configuration file, the default settings shown below will be used.

You can override these defaults by creating a file named ~/.config/aip_container:

    # The existence of base path is checked before starting the container
    BASE_PATH="/tmp"

    # The host path is then created if it doesn't exist
    # (set BASE_PATH and HOST_PATH to be the same if you don't want directories to be created)
    HOST_PATH="/tmp/$USER/aip"

    # This array of files is symlinked to the corresponding files in your $HOME
    SYMLINK=(".gitconfig" ".ssh")

Note that if the path /images/tmp exists and you have no configuration file, then /images/tmp will be used instead of /tmp. This is because on UTS lab computers, /images/tmp has greater capacity.

# Usage

If you are using a lab computer, the container should already be installed for you.

To rebuild the container using your own computer:

    sudo singularity build aip-container_latest.sif Singularity

Or, you can pull the pre-built image from Singularity Hub to your own computer:

    singularity pull shub://benatuts/aip-container

Use run_aip_singularity_container.sh to manually start the container:

    run_aip_singularity_container.sh term      # Start a gnome-terminal
    run_aip_singularity_container.sh vscode    # Start visual studio code
    run_aip_singularity_container.sh fullterm  # Start a gnome-terminal-server and gnome-terminal
