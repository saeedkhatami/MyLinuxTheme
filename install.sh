#!/bin/bash

# Function to install a Grub theme
install_grub_theme() {
    # Replace "python_script.py" with the actual filename of your Python script
    python_script="grub/4rch-gurb-th3m3.py"

    # Add commands to install Grub theme here
    echo "Installing Grub theme..."
    # Assuming the Python script requires some parameters or options, you can pass them like this:
    python3 "$python_script" --install
}
uninstall_grub_theme() {
    # Replace "python_script.py" with the actual filename of your Python script
    python_script="grub/4rch-gurb-th3m3.py"

    # Add commands to install Grub theme here
    echo "Uninstalling Grub theme..."
    # Assuming the Python script requires some parameters or options, you can pass them like this:
    python3 "$python_script" --uninstall
}

# Function to install AestheticStuff theme
install_aestheticstuff_theme() {    # Set the repository URL and destination folder
    repo_url="https://github.com/rxyhn/AestheticStuff.git"
    destination_folder="/usr/share/themes"

    # Clone the GitHub repository
    echo "Cloning AestheticStuff theme from GitHub..."
    git clone "$repo_url" /tmp/aestheticstuff_theme

    # Check if cloning was successful
    if [ $? -eq 0 ]; then
        echo "AestheticStuff theme cloned successfully."

        # Check if the destination folder exists or create it
        if [ ! -d "$destination_folder" ]; then
            sudo mkdir -p "$destination_folder"
        fi

        # Copy the 'Aesthetic-Night' folder to the theme folder with sudo (if needed)
        source_folder="/tmp/aestheticstuff_theme/gtk/Aesthetic-Night"
        if [ -d "$source_folder" ]; then
            echo "Copying Aesthetic-Night folder to $destination_folder..."
            sudo cp -r "$source_folder" "$destination_folder"
            echo "Aesthetic-Night folder copied successfully."
        else
            echo "Aesthetic-Night folder not found in the repository."
        fi

        # Clean up the temporary clone folder
        rm -rf /tmp/aestheticstuff_theme

        echo "AestheticStuff theme installed in $destination_folder."
    else
        echo "Failed to clone the AestheticStuff theme. Please check the repository URL and try again."
    fi
}

# Function to install Papiros Icon theme
install_papiros_icon() {
        # Check if yay is installed
    if ! command -v yay &> /dev/null; then
        echo "yay not found. Please install yay or use your preferred AUR package manager."
        return 1
    fi

    # Install the Papirus Icon theme using yay with sudo (if needed)
    echo "Installing Papirus Icon theme..."
    yay -S --noconfirm papirus-icon-theme

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Papirus Icon theme installed successfully."
    else
        echo "Failed to install the Papirus Icon theme. Please check your AUR package manager and try again."
    fi
}

# Function to install Nerd Fonts
install_nerd_fonts() {
        # Check if yay is installed
    if ! command -v yay &> /dev/null; then
        echo "yay not found. Please install yay or use your preferred AUR package manager."
        return 1
    fi

    # Install Nerd Fonts using the nerd-fonts-git package from the AUR
    echo "Installing Nerd Fonts..."
    yay -S --noconfirm nerd-fonts-git

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "Nerd Fonts installed successfully."
    else
        echo "Failed to install Nerd Fonts. Please check your AUR package manager and try again."
    fi
}

# Function to install Zsh
install_zsh() {
    # Check if zsh is installed
    if command -v zsh &> /dev/null; then
        echo "zsh is already installed."
    else
        # Install zsh using your package manager here (for example, on Arch-based distros using yay)
        echo "Installing zsh..."
        yay -S --noconfirm zsh

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "zsh installed successfully."
        else
            echo "Failed to install zsh. Please check your package manager and try again."
        fi
    fi
}

# Function to install Oh My Zsh, Zsh plugins, and Starship prompt
install_zsh_oh_my_zsh() {
    # Check if zsh is installed
    if ! command -v zsh &> /dev/null; then
        echo "zsh is not installed. Please install zsh first before proceeding."
        return 1
    fi

    # Check if Oh My Zsh is already installed
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
        return 0
    fi

    # Install Oh My Zsh
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Check if Oh My Zsh installation was successful
    if [ $? -eq 0 ]; then
        echo "Oh My Zsh installed successfully."
    else
        echo "Failed to install Oh My Zsh. Please check your internet connection and try again."
        return 1
    fi

    # Install zap (Zsh plugin manager)
    echo "Installing zap (Zsh plugin manager)..."
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin

    # Check if zap installation was successful
    if [ $? -eq 0 ]; then
        echo "zap (Zsh plugin manager) installed successfully."
    else
        echo "Failed to install zap (Zsh plugin manager). Please check your internet connection and try again."
        return 1
    fi

    # Install Starship prompt
    echo "Installing Starship prompt..."
    sh -c "$(curl -fsSL https://starship.rs/install.sh)"

    # Check if Starship installation was successful
    if [ $? -eq 0 ]; then
        echo "Starship prompt installed successfully."
    else
        echo "Failed to install Starship prompt. Please check your internet connection and try again."
        return 1
    fi

    # Install exa (alternative to ls command with more features)
    echo "Installing exa..."
    yay -S --noconfirm exa

    # Check if exa installation was successful
    if [ $? -eq 0 ]; then
        echo "exa installed successfully."
    else
        echo "Failed to install exa. Please check your AUR package manager and try again."
        return 1
    fi

    cp starship.toml ~/.config
    cp .zshrc $HOME
    # Check if the copying was successful
    if [ $? -eq 0 ]; then
        echo "zshrc and starship config installed successfully."
    else
        echo "Failed to install zshrc and starship config. Please check the source file and try again."
    fi

    echo "Oh My Zsh, zap, Starship prompt, and exa are now installed and configured."
}

# Function to install Neofetch
install_neofetch() {
        # Check if neofetch is installed
    if command -v neofetch &> /dev/null; then
        echo "neofetch is already installed."
    else
        # Install neofetch using your package manager here (for example, on Arch-based distros using yay)
        echo "Installing neofetch..."
        yay -S --noconfirm neofetch

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "neofetch installed successfully."
        else
            echo "Failed to install neofetch. Please check your package manager and try again."
        fi
    fi
}

# Function to install Neofetch config
install_neofetch_config() {
    # Check if neofetch is installed
    if ! command -v neofetch &> /dev/null; then
        echo "neofetch is not installed. Please install neofetch first before installing the config."
        return 1
    fi

    # Define the source and destination paths for the config file
    source_config_file="neofetch/config.conf"
    destination_config_dir="$HOME/.config/neofetch/"

    # Check if the source config file exists
    if [ ! -f "$source_config_file" ]; then
        echo "Config file not found: $source_config_file"
        return 1
    fi

    # Check if the destination config directory exists or create it
    if [ ! -d "$destination_config_dir" ]; then
        mkdir -p "$destination_config_dir"
    fi

    # Copy the config file to the neofetch config directory
    echo "Installing neofetch config..."
    cp "$source_config_file" "$destination_config_dir"

    # Check if the copying was successful
    if [ $? -eq 0 ]; then
        echo "neofetch config installed successfully."
    else
        echo "Failed to install neofetch config. Please check the source file and try again."
    fi
}

# Function to install Rofi
install_rofi() {
        # Check if rofi is installed
    if command -v rofi &> /dev/null; then
        echo "rofi is already installed."
    else
        # Install rofi using your package manager here (for example, on Arch-based distros using yay)
        echo "Installing rofi..."
        yay -S --noconfirm rofi

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "rofi installed successfully."
        else
            echo "Failed to install rofi. Please check your package manager and try again."
        fi
    fi
}

# Function to install Rofi theme
install_rofi_theme() {
    # Check if rofi is installed
    if ! command -v rofi &> /dev/null; then
        echo "rofi is not installed. Please install rofi first before installing the config."
        return 1
    fi

    # Define the source and destination paths for the config file
    source_config_file="rofi/style.rasi"
    destination_config_dir="$HOME/.config/rofi/"

    # Check if the source config file exists
    if [ ! -f "$source_config_file" ]; then
        echo "Config file not found: $source_config_file"
        return 1
    fi

    # Check if the destination config directory exists or create it
    if [ ! -d "$destination_config_dir" ]; then
        mkdir -p "$destination_config_dir"
    fi

    # Copy the config file to the rofi config directory
    echo "Installing rofi config..."
    cp "$source_config_file" "$destination_config_dir"

    # Check if the copying was successful
    if [ $? -eq 0 ]; then
        echo "rofi config installed successfully."
        echo "create a hotkey and set the command to"
        echo "rofi -show drun -theme ~/.config/rofi/style.rasi"


    else
        echo "Failed to install rofi config. Please check the source file and try again."
    fi
}

# Main menu function
show_menu() {
    clear
    echo "====================="
    echo "    My Arch Linux Theme    "
    echo "====================="
    echo "1. Install Grub theme"
    echo "1. Uninstall Grub theme"
    echo "2. Install AestheticStuff theme"
    echo "3. Install Papiros Icon theme"
    echo "4. Install Nerd Fonts"
    echo "5. Install Zsh"
    echo "6. Install Oh My Zsh, Zsh plugins, and Starship prompt"
    echo "7. Install Neofetch"
    echo "8. Install Neofetch config"
    echo "9. Install Rofi"
    echo "10. Install Rofi theme"
    echo "0. Exit"
}

# Main logic
while true; do
    show_menu
    read -p "Enter your choice (0-10): " choice

    case $choice in
        1) install_grub_theme ;;
        2) install_aestheticstuff_theme ;;
        3) install_papiros_icon ;;
        4) install_nerd_fonts ;;
        5) install_zsh ;;
        6) install_zsh_oh_my_zsh ;;
        7) install_neofetch ;;
        8) install_neofetch_config ;;
        9) install_rofi ;;
        10) install_rofi_theme ;;
        0) echo "Exiting. Goodbye!"; exit ;;
        *) echo "Invalid choice. Please enter a number from 0 to 10." ;;
    esac

    echo "Press Enter to continue..."
    read -r
done
