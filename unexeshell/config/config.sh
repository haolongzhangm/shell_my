#!/usr/bin/env bash
set -ex

dir_pre="/home"
if [ `uname` == "Darwin" ]
then
	dir_pre="/Users"
	echo "Darwin env"
else
	echo "other env"
fi

root_dir="$dir_pre/$USER/shell_my/unexeshell/config"
RED='\033[0;31m'
NC='\033[0m'

echo "try config all config...."

echo "1: config git config....."
echo "try remove exist file...."
rm ~/.gitconfig
rm ~/.gitignore_global

ln -s $root_dir/git_config/.gitconfig ~/.gitconfig
ln -s $root_dir/git_config/.gitignore_global ~/.gitignore_global

echo "2: config minicom..."
echo "sudo apt install minicom"
sudo apt install minicom

echo "cp minicom config file"
sudo cp minicom_config/minirc.* /etc/minicom/

echo "3: config chrome..."
echo -e "${RED}all to  longhaozhang@gmail.com${NC}"

echo "4: config tmux..."
echo "try remove exist file..."
rm ~/.tmux.conf
ln -s $root_dir/tmux_config/.tmux.conf ~/.tmux.conf

echo "5: config gdb..."
echo "try remove exist file..."
rm ~/.gdbinit
ln -s $root_dir/gdb_config/.gdbinit ~/.gdbinit

echo "6: config vim config..."
echo "try remove exist file..."
rm ~/.vimrc
rm ~/.vimspector.json
ln -s $root_dir/vim_config/.vimrc ~/.vimrc
ln -s $root_dir/vim_config/.vimspector.json ~/.vimspector.json
mkdir -p ~/.vim/spell
rm ~/.vim/spell/en.utf-8.add
rm ~/.vim/spell/en.utf-8.add.spl
ln -s $root_dir/vim_config/en.utf-8.add.spl ~/.vim/spell/en.utf-8.add.spl
ln -s $root_dir/vim_config/en.utf-8.add ~/.vim/spell/en.utf-8.add
echo "cp external_vim_file"
mkdir -p ~/.vim/
cp $root_dir/vim_config/external_vim_file/* -rf ~/.vim/ 
echo "config nvim"
rm -rf ~/.config/nvim
mkdir -p ~/.config/nvim/
# link vimrc to nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
cp $root_dir/vim_config/external_vim_file/* -rf ~/.config/nvim/
python3 -m pip install --upgrade pip
python3 -m pip install pynvim

echo "7: config usb udev"
sudo cp $root_dir/ubuntu_config/usb_udev_config/*.rules /etc/udev/rules.d/

echo "8: install more fonts..."
cd $root_dir/ubuntu_config/fonts/
./install_fonts.sh
cd -

echo -e "${RED}9: need config ubuntu config Manually${NC}"
