A fully-functional [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) client for [tldr](https://github.com/rprieto/tldr/). This version aims to be the easiest and smallest to set up on a new account, without sacrificing any features.

![tldr screenshot](Screenshot.png?raw=true)

# Setup

	mkdir -p ~/bin
	curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
	chmod +x ~/bin/tldr

# Prerequisites

`curl` needs to be available somewhere in your `$PATH`. The script is otherwise self-contained.

# Usage
tldr [options] <command>

[options]
    -l, --list:     show all available pages
    -u, --update:   update, force retrieving latest copies of index and <command>
    -p, --platform: show page from specific platform rather than autodetecting
    -h, -?:         this help overview

<command>
    Show examples for this command

The client caches a copy of all pages and the index locally under
~/.config/tldr. By default, the cached copies will expire in 14 days.

# Contributing

This is the result of a Sunday afternoon project. It's been lightly tested under Mac OS X 10.9 and Ubuntu Linux 15.10. I've tried to make the project as portable as possible, but if there's something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!
