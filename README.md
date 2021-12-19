# tldr

A fully-functional POSIX shell client for [tldr-pages](https://github.com/tldr-pages/tldr).
This version aims to be the easiest, smallest, and most universal client to set up
on a new account, without sacrificing any features. It uses only `/bin/sh` features
and `curl`, and tested on Linux, OSX, FreeBSD, with `bash`, `sh`, `dash`, `ksh`,
`zsh`, `csh`.

![tldr screenshot](Screenshot.png?raw=true)

## Installation
```bash
mkdir -p ~/bin
curl -o ~/bin/tldr https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x ~/bin/tldr
```

Then try using the command! If you get an error such as _-bash: tldr: command not found_,
you may need to add `~/bin` to your `$PATH`. On OSX edit `~/.bash_profile`
(`~/.bashrc` on Linux), and add the following line to the bottom of the file:
```bash
export PATH=$PATH:~/bin
```

If you'd like to enable shell completion (eg. `tldr w<tab><tab>` to get a
list of all commands which start with w) then add the following to the same
startup script:

```bash
complete -W "$(tldr 2>/dev/null --list)" tldr
```

Or for `~/.zshrc`, add:
```bash
[ -f ~/bin/tldr ] && compctl -k "($( tldr 2>/dev/null --list))" tldr
```

## Prerequisites

`curl` and `unzip` need to be available somewhere in your `$PATH`. The script is otherwise self-contained.

## Usage

```
tldr [options] <command>

[options]
  -l, --list             show all available pages
  -L, --language [code]  override language detection, set preferred language
  -p, --platform [name]  show page from specific platform
  -u, --update           update cached copies of tldr page files
  -h, --help             this help overview
  -v, --version          show version information
  -n, --no-cache         display pages directly from GitHub (watch ratelimits)

<command>
  Show the tldr page for command.

The client caches a copy of the tldr pages under $(cache_dir)
By default, cached copies will be refreshed after $(cache_days) days.

Examples:
	Show an overivew of unzip:
		tldr unzip
	Show commands for all platforms:
		tldr -l -p all
	If you have fzf installed, try:
		tldr -l -p all | fzf --preview 'tldr {}' 
	Show the Russian page for tar:
		tldr -L ru tar
	List pages in the Android section:
		tldr -p android -l
```


## Customization
You can change the styling of the output from `tldr` by defining some environment variables. For
example, try adding the following lines to your `~/.bash_profile` file (OSX) or `~/.bashrc` file
(Linux).

```bash
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='green'
export TLDR_CODE='red'
export TLDR_PARAM='blue'
```

Possible settings are: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`,
`white`, `onblue`, `ongrey`, `reset`, `bold`, `underline`, `italic`, `eitalic`, `default`
_(some variables may not work in some shells)_.

NB: You will need to log into a new session to see the effect. Just run the commands in the
terminal directly to see the change immediately and temporarily.

## Contributing

This is the result of a Sunday afternoon project. It's been lightly tested under Mac OS X 10.9
and Ubuntu Linux 15.10. I've tried to make the project as portable as possible, but if there's
something I missed I'd love your help.

* Want a new feature? Feel free to file an issue for a feature request.
* Find a bug? Open an issue please, or even better send me a pull request.

Contributions are always welcome at any time!
