A fully-functional portable [Unix shell](https://en.wikipedia.org/wiki/Unix_shell) client for [tldr](https://github.com/tldr-pages/tldr). This version aims to be the easiest and smallest to set up on a new account, without sacrificing any features.

![tldr screenshot](screenshot.png?raw=true)

# Setup

`wget -qO- https://raw.githubusercontent.com/j8r/tldr/master/install.sh | sh`

or

`curl -o- https://raw.githubusercontent.com/j8r/tldr/master/install.sh | sh`

### If you want to install `tldr` manually

```
mkdir -p ~/.tldr/cach		# Or any directory you want

wget -qO ~/.tldr/tldr.sh https://raw.githubusercontent.com/j8r/tldr/master/tldr.sh

# or at your choice
curl -o ~/.tldr/tldr.sh https://raw.githubusercontent.com/j8r/tldr/master/tldr.sh

# make it executable
chmod +x tldr.sh
```

Finally add an alias with the path where the `tldr.sh` file is located, the default is `alias tldr=$HOME/.tldr/tldr.sh` to your favorite shell's init file (For example for Bash on macOS ~/.bash_profile and ~/.bashrc on Linux, ~/.zshrc for Zsh)

# Usage

```
	USAGE: tldr command [options]

	Options:

		-h, -?, --help        This help overview
		-d, --download        Download all tldr pages to the cache
		-l, --list:           Show all available pages
		-p, --platform        Show page from specific platform rather than autodetecting
		-u, --update          Update tldr to its newest version
		-r, --refresh         Refresh locally cached files by retrieving their latest copies
		-c, --clear           Clear the local cache

	Example:
		To show the tldr page of tar with use examples:

		$ tldr tar
		$ tldr -p linux tar
```

The client caches a copy of all pages and the index locally under `~/.tldr/cache` (or the `cache` folder in the directory you put `tldr.sh`) by default.

By default, the cached copies will expire in 14 days.

# Notes

You need at least ether `wget` or `curl`. The last appears to be faster.

Note that the script `tldr.sh` is a POSIX-compliant script. This means you can run it with any POSIX shell like `sh`, `dash`, `ksh`, `zsh`, `bash`...

`tldr.sh` is also portable. No matter where you drop the file/its folder or from where you execute it, tldr will works and create/use its cache folder from its directory.

# Contributing

This is the result of a Sunday afternoon project. It's been lightly tested under Mac OS X 10.9 and Ubuntu Linux 15.10. I've tried to make the project as portable as possible, but if there's something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!
