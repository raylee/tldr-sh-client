A fully-functional [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) client for [tldr](https://github.com/rprieto/tldr/). This version aims to be the easiest and smallest to set up on a new account, without sacrificing any features.

![tldr screenshot](screenshot.png?raw=true)

# Setup

`wget -qO- https://raw.githubusercontent.com/DFabric/DPlatform-ShellCore/master/install.sh | sh`

or

`curl -o- https://raw.githubusercontent.com/DFabric/DPlatform-ShellCore/master/install.sh | sh`

### If you want to install `tldr` manually

```
mkdir -p ~/.tldr/cache

wget -qO ~/.tldr/tldr.sh https://raw.githubusercontent.com/raylee/tldr/master/tldr.sh

# or at your choice
curl -o ~/.tldr/tldr.sh https://raw.githubusercontent.com/raylee/tldr/master/tldr.sh
```

Finally add `alias tldr=$HOME/.tldr/tldr.sh` to favorite Shell init file (For example for Bash on macOS ~/.bash_profile and ~/.bashrc on Linux, ~/.zshrc for Zsh)

# Prerequisites

`wget` or `curl` needs to be available somewhere in your `$PATH`. The script is otherwise self-contained.

# Usage

```
	USAGE: tldr command [options]

	Options:

		-h, -?, --help:       This help overview
		-d, --download        Download all tldr pages to the cache
		-l, --list:           Show all available pages
		-p, --platform:       Show page from specific platform rather than autodetecting
		-u, --update:         Update, force retrieving latest copies of locally cached files
		-c, --clear-cache     Clear the local cache

	Example:
		To show the tldr page of tar with use examples:

		$ tldr tar
		$ tldr -p linux tar
```

The client caches a copy of all pages and the index locally under
~/.tldr. By default, the cached copies will expire in 14 days.

# Contributing

This is the result of a Sunday afternoon project. It's been lightly tested under Mac OS X 10.9 and Ubuntu Linux 15.10. I've tried to make the project as portable as possible, but if there's something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!
