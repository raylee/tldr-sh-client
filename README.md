A fully-functional portable [Unix shell](https://en.wikipedia.org/wiki/Unix_shell) client for [tldr](https://github.com/tldr-pages/tldr). This version aims to be the easiest and smallest to set up on a new account, without sacrificing any features.

![tldr screenshot](screenshot.png?raw=true)

# Setup

First download `tldr` where you like.
We recommend to download the `tldr` to `/usr/local/bin` and make it executable

Go to a directory

`cd /usr/local/bin` (recommended)

Download the script

```
wget https://raw.githubusercontent.com/j8r/tldr/master/tldr
chmod +x tldr
```

or at your choice

```
curl -O https://raw.githubusercontent.com/j8r/tldr/master/tldr
chmod +x tldr
```

Optional: If `tldr` isn't in a `bin` system directory, you can find useful to add an alias to `tldr` in your shell init file with `tldr -a`.

# Usage

```
	USAGE: tldr command [options]

	Options:

		-h, -?, --help             This help overview
		-d, --download             Download all tldr pages to the cache
	  -l, --list:                Show all available pages
	  -p, --portable             Portable mode with temporary cache
	  -u, --update               Update tldr to its newest version
		-r, --refresh              Refresh locally cached files by retrieving their latest copies
		-c, --clear                Clear the local cache
		-a, --add-alias            Add a tldr alias to your shell init file
		-o, --os [type]            Override the operating system [linux, osx, sunos]
		--linux, --osx, --sunos    Override the operating system with Linux, OSX or SunOS

	Example:
		To show the tldr page of tar with use examples:

		$ tldr tar
		$ tldr -p linux tar
```

The client caches a copy of the tldr page and the index locally under `~/.cache/tldr` (or `/tmp/tldr` in the portable mode) and the cached copies will expire in 14 days by defaut.

# Notes

You need at least either `wget` or `curl`. The last appears to be faster.

Note that `tldr` is a POSIX compliant script, portable across UNIX systems. This means you can run it on any machine with a POSIX shell like `bash`, `zsh`, `sh`, `dash`, `ksh`...

Tested on Mac OS X 10.9, Ubuntu Linux 15.10, Debian 9 and CentOS 7.

# Contributing

This is the result of a Sunday afternoon project. I've tried to make the project as portable as possible, but if there's something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!
