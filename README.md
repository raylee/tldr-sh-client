# tldr-bash

A fully-functional [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) client for [tldr](https://github.com/rprieto/tldr/). This version aims to be the easiest and smallest to set up on a new account, without sacrificing any features.

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
export PATH=~/bin:$PATH
```

If you'd like to enable shell completion (eg. `tldr w<tab><tab>` to get a
list of all commands which start with w) then add the following to the same
startup script:

```bash
complete -W "$(tldr 2>/dev/null --list)" tldr
```

## Prerequisites

`curl` needs to be available somewhere in your `$PATH`. The script is otherwise self-contained.

## Usage
```
tldr [options] command

[options]
	-l, --list:      show all available pages
	-p, --platform:  show page from specific platform rather than autodetecting
	-u, --update:    update, force retrieving latest copies of index and <command>
	-h, -?, --help:  this help overview

command
	Show examples for this command
```

The client caches a copy of all pages and the index locally under
~/.config/tldr. By default, the cached copies will expire in 14 days.

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
