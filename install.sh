#!/bin/sh


[ ! -d ~/.tldr ] && printf "tldr seems to have already been previously installed.\nDelete the \'$HOME/.tldr\' directory first before relaunching this script\n" && exit 1 || mkdir -p ~/.tldr/cache

download() {
  hash curl 2>/dev/null && curl -sf -o "$1" "$2" || { hash wget 2>/dev/null && wget -qO "$1" "$2"; } || echo "Fail to download $2" && exit 1
}

# Download tldr.sh and index.json
download ~/.tldr/tldr.sh https://raw.githubusercontent.com/raylee/tldr/master/tldr.sh
download ~/.tldr/cache/index.json http://tldr-pages.github.io/assets/index.json

# Add alias to rc files
add_alias() {
  printf "\nalias tldr=$HOME/.tldr/tldr.sh\n" >> ~/.$1 && printf "tldr alias added to $1\n"
}

[ -e ~/.bashrc ] && add_alias bashrc

[ -e ~/.bash_profile ] && add_alias bash_profile

[ -e ~/.zshrc ] && add_alias zshrc

[ ! -e ~/.bashrc ] && [ ! -e ~/.bash_profile ] && [ ! -e ~/.zshrc ] && [ -e ~/.profile ] && add_alias profile

printf "\ntldr installed!\nClose and reopen your terminal to start using tldr or run \`\`"
