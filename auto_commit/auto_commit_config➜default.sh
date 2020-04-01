# The first time you add a file here and run the script (./auto_commit.sh) it will
# generate the md5, but it will not send to your repository. And the second time
# (when there are changes)  and the next times the script will send to the repository.
# Usage: After you configure this file, run: ./auto_commit.sh
# You must have set up SSH keys for the script does not need password.
# SAMPLE CONFIGURATION FILE ----------------------------------------------------

# This gets the current date.
now=$(date +"%Y.%m.%d")

# USAGE: watch "PATH/FILE" "Commit message." "FOLDER_TO_COPY_THE_FILE"
# If the folder to copy the file is the same folder as the GitHub project,
# then no argument must be passed (the 3rd argument).
# ATTENTION! Commits must be a maximum of 50 characters.
files() {
  watch "$HOME/.zshrc" "ZSH config ⇿ $now auto backup" "/mnt/home2/auto-dotfiles"
  watch "$HOME/.bashrc" "BASH config ⇿ $now auto backup" "/mnt/home2/auto-dotfiles"
  watch "$HOME/.config/Code - OSS/User/settings.json" "VS Code Config ⇿ $now auto backup" "/mnt/home2/auto-dotfiles"
}

# ------------------------------------------------------------------------------
