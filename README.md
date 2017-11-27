# tldr-bash-client

* version 0.37

### Bash client for tldr: community driven man-by-example
**A fully-functional [bash](https://tiswww.case.edu/php/chet/bash/bashtop.html)
client for the [tldr](https://tldr.sh) project, providing
poignant examples of terminal commands.**

<img alt="tldr page gif" src="tldr-page.gif" title="tldr page" />

This client can render both the old and the new tldr markup format.

## Installation
Download the tldr bash script to the install location:

```bash
loc=/usr/local/bin/tldr  # elevated privileges needed for some locations
sudo wget -qO $loc https://4e4.win/tldr
sudo chmod +x $loc
```

If the location is not in $PATH, you need to specify the path to run it.

<img alt="tldr page screenshot" src="tldr-page.jpg" title="tldr page" width="600" />
<img alt="tldr usage screenshot" src="tldr-usage.jpg" title="tldr usage" width="600" />

### Prerequisites
coreutils, grep, unzip, curl / wget, less (optional)

<img alt="tldr find screenshot" src="tldr-find.jpg" title="tldr find" width="600" />

## Customisation
<img alt="tldr customize screenshot" src="tldr-customize.jpg" title="tldr customize" width="600" />

The 5 elements in TLDR markup that can be styled with these colors and
backgrounds (last one specified will be used) and modes (more can apply):
* Colors: Black, Red, Green, Yellow, Blue, Magenta, Cyan, White
* BG: BlackBG, RedBG, GreenBG, YellowBG, BlueBG, MagentaBG, CyanBG, WhiteBG
* Modes: Bold, Underline, Italic, Inverse

`Newline` can be added to the style list to add a newline before the element
and `Space` to add a space at the start of the line
(style items are separated by space, lower/uppercase mixed allowed)
* TLDR_TITLE_STYLE (defaults to: Newline Space Bold Yellow)
* TLDR_DESCRIPTION_STYLE (defaults to: Space Yellow)
* TLDR_EXAMPLE_STYLE (defaults to: Newline Space Bold Green)
* TLDR_CODE_STYLE (defaults to: Space Bold Blue)
* TLDR_VALUE_ISTYLE (defaults to: Space Bold Cyan)

The Value style (above) is an Inline style: doesn't take Newline or Space

Inline styles for help text: default, URL, option, platform, command, header
* TLDR_DEFAULT_ISTYLE (defaults to: White)
* TLDR_URL_ISTYLE (defaults to: Yellow)
* TLDR_HEADER_ISTYLE (defaults to: Bold)
* TLDR_OPTION_ISTYLE (defaults to: Bold Yellow)
* TLDR_PLATFORM_ISTYLE (defaults to: Bold Blue)
* TLDR_COMMAND_ISTYLE (defaults to: Bold Cyan)
* TLDR_FILE_ISTYLE (defaults to: Bold Magenta)

Color/BG (Newline and Space also allowed) for error and info messages
* TLDR_ERROR_COLOR (defaults to: Newline Space Red)
* TLDR_INFO_COLOR (defaults to: Newline Space Green)

How many days before freshly downloading a potentially stale page
* TLDR_EXPIRY (defaults to: 60)

Alternative location of pages cache
* TLDR_CACHE (not set by default)

Instead of `less`, use `cat` for output (automatic if less not available)
* TLDR_LESS (not set by default; if set to *0* `cat` will be used)

<img alt="tldr list screenshot" src="tldr-list.jpg" title="tldr list" width="600" />

# tldr-lint

* version 0.11

### Linter for new syntax tldr source files

```
Usage: tldr-lint [-h|--help] [-V|--version] [-q|--quiet] [<dir>] [<file>]
          - All *.md files under <dir> and subdirectories are checked
          - <file> is checked regardless of extension
          -q, --quiet:    No output means check is OK
          -V, --version:  Display version
          -h, --help:     Display this help text
```

### Prerequisites
coreutils, sed, grep, find

## Contributing

Please file an issue for a question, a bug or a feature request.
Or even better, send a pull request!

[tldr-bash-client github page](http://github.com/pepa65/tldr-bash-client "github.com/pepa65/tldr-bash-client")

<img alt="tldr markdown screenshot" src="tldr-markdown.jpg" title="tldr markdown" width="600" />

### License

Original tldr client in bash by Ray Lee http://github.com/raylee/tldr (MIT license)

The tldr-bash-client is relicensed under GPLv3+ and tldr-lint is GPLv3+ as well.

<img alt="tldr new markdown screenshot" src="tldr-markdown-new.jpg" title="tldr new markdown" width="600" />
