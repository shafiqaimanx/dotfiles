#!/bin/bash

# Define color variables using ANSI escape codes
RESET="\033[0m"
RED="\033[38;5;196m"
BLUE="\033[38;5;39m"
GREEN="\033[38;5;48m"
YELLOW="\033[38;5;226m"
OKAY="[${GREEN}OKAY${RESET}]"
WARN="[${YELLOW}WARN${RESET}]"
INFO="[${BLUE}INFO${RESET}]"
ERROR="[${RED}ERRO${RESET}]"
RESULT="[${RED}RSLT${RESET}]"

# Backup any config files
backup_config_files() {
	echo -e "${INFO} ${YELLOW}Backup any config files...${RESET}"
	dot_config_file=("$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.config/nvim/init.nvim")
	nvim_pathconf="$HOME/.config/nvim/"

	if [ ! -d "$nvim_pathconf" ]; then
		mkdir -p "$nvim_pathconf"
	fi

	for file in "${dot_config_file[@]}"; do
		if [ -f "$file" ]; then
			mv "$file" "$file.bak"
		fi
	done
}

# Get all the dotfiles
get_all_the_dotfiles() {
	echo -e "${INFO} ${YELLOW}Downloading the dotfiles...${RESET}"
	config_file=("$HOME/zshrc" "$HOME/tmux.conf" "$HOME/init.vim")
	wget -q https://raw.githubusercontent.com/shafiqaimanx/dotfiles/main/Kali/zshrc
	wget -q https://raw.githubusercontent.com/shafiqaimanx/dotfiles/main/Kali/tmux.conf
	wget -q https://raw.githubusercontent.com/shafiqaimanx/dotfiles/main/Kali/init.vim

	for file in "${config_file[@]}"; do
		if [ -f "$file" ]; then
			filename=$(basename "$file")
			mv "$file" ".$filename"
		fi
	done
	mv $HOME/.init.vim $nvim_pathconf
	filename=$(basename "$nvim_pathconf")
	mv $HOME/.config/nvim/.init.vim $HOME/.config/nvim/init.vim
}

# Installing updated rust
installing_rust() {
	if ! command -v rustc &> /dev/null; then
		echo -e "${INFO} ${YELLOW}Installing Rust...${RESET}"
		yes '' | curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path > /dev/null 2>&1
		#source $HOME/.cargo/env #yng ni bleh comment klu aku pakai dotfiles .zshrc aku
		echo -e "${OKAY} ${GREEN}rustc${RESET} is installed."
	else
		echo -e "${INFO} ${GREEN}rustc${RESET} is already installed."
	fi
}

# Installing golang v1.21.3
installing_golang() {
	echo -e "${INFO} ${YELLOW}Installing Golang...${RESET}"
	wget -q https://go.dev/dl/go1.21.3.linux-amd64.tar.gz
	sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz
	rm -rf $HOME/go1.21.3.linux-amd64.tar.gz
	echo -e "${OKAY} ${GREEN}golang${RESET} is installed."
}

# Installing (essential tools)
installing_essential_tools() {
	echo -e "${INFO} ${YELLOW}Updating package repository...${RESET}"
	sudo apt update -qq > /dev/null 2>&1

	# nishang seclists gobuster
	# chsh -s $(which zsh)
	essential_tools=("bat" "vim" "grc" "zsh" "tmux" "most")
	echo -e "${INFO} ${YELLOW}Installing essential tools...${RESET}"
	sudo apt install -y -qq "${essential_tools[@]}" > /dev/null 2>&1

	# Customization third plugin
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm > /dev/null 2>&1
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' > /dev/null 2>&1

	for tool in "${essential_tools[@]}"; do
		if dpkg-query -l "$tool" &> /dev/null; then
			echo -e "${OKAY} ${GREEN}$tool${RESET} is installed."
		else
			echo -e "${ERROR} Failed to install ${GREEN}$tool${RESET}."
		fi
	done
	chsh -s $(which zsh)
	echo -e "${OKAY} ${GREEN}tpm${RESET} is installed."
	echo -e "${OKAY} ${GREEN}plug${RESET} is installed."
}

# Installing fonts
installing_fonts() {
	echo -e "${INFO} ${YELLOW}Installing fonts...${RESET}"
	fonts_path="$HOME/.fonts"

	if [ ! -d "$fonts_path" ]; then
		mkdir -p "$fonts_path"
	fi

	wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
	unzip JetBrainsMono.zip -d $fonts_path > /dev/null 2>&1
	rm $fonts_path/readme.md $fonts_path/OFL.txt JetBrainsMono.zip
	echo -e "${OKAY} ${GREEN}fonts${RESET} is installed."
}

# Installing themes
installing_themes() {
	echo -e "${INFO} ${YELLOW}Installing themes...${RESET}"
	themes_path="$HOME/.themes"

	if [ ! -d "$themes_path" ]; then
		mkdir -p "$themes_path"
	fi

	# GTK theme
	wget -q https://github.com/catppuccin/gtk/releases/download/v0.7.0/Catppuccin-Mocha-Standard-Mauve-Dark.zip
	unzip Catppuccin-Mocha-Standard-Mauve-Dark.zip -d $themes_path > /dev/null 2>&1
	rm Catppuccin-Mocha-Standard-Mauve-Dark.zip
	# terminal theme
	wget -q https://raw.githubusercontent.com/catppuccin/qterminal/main/src/Catppuccin-Mocha.colorscheme
	sudo mv Catppuccin-Mocha.colorscheme /usr/share/qtermwidget5/color-schemes
	echo -e "${OKAY} ${GREEN}themes${RESET} is installed."
}

# Installing wallpapers
installing_wallpapers() {
	echo -e "${INFO} ${YELLOW}Installing wallpapers...${RESET}"
	wallpaper_path="$HOME/Pictures"

	if [ ! -d "$wallpaper_path" ]; then
		mkdir -p "$wallpaper_path"
	fi

	wget -q https://raw.githubusercontent.com/Gingeh/wallpapers/main/minimalistic/hearts.png
	mv hearts.png $wallpaper_path
	echo -e "${OKAY} ${GREEN}wallpapers${RESET} is installed."
}

# Setting up terminal theme
setting_up_terminal() {
	echo -e "${INFO} ${YELLOW}Setting up terminal themes...${RESET}"
	terminal_theme="$HOME/.config/qterminal.org"

	mv $terminal_theme/qterminal.ini $terminal_theme/qterminal.ini.bak
	wget -q https://raw.githubusercontent.com/shafiqaimanx/dotfiles/main/Kali/qterminal.ini
	mv qterminal.ini $terminal_theme/qterminal.ini
	echo -e "${OKAY} ${GREEN}done${RESET} setting up terminal theme."
}

# Setting up gtk theme
setting_up_terminal() {
	echo -e "${INFO} ${YELLOW}Setting up gtk themes...${RESET}"
	gtk_theme="/etc/xdg/xfce4/xfconf/xfce-perchannel-xml"

	mv $gtk_theme/xsettings.xml $gtk_theme/xsettings.xml.bak
	wget -q https://raw.githubusercontent.com/shafiqaimanx/dotfiles/main/Kali/xsettings.xml
	mv xsettings.xml $gtk_theme/xsettings.xml
	echo -e "${OKAY} ${GREEN}done${RESET} setting up gtk theme."
}

#####################
#					#
#	M	A	I	N	#
#					#
#####################
#backup_config_files
#get_all_the_dotfiles
#installing_rust
#installing_golang
#installing_essential_tools
#installing_fonts
#installing_themes
#installing_wallpapers

#setting_up_terminal
#setting_up_gtk