# tldr-bash-client

* version 0.1a
* https://github.com/pepa65/tldr-bash-client

### Bash client for tldr: community driven man-by-example
**A fully-functional [bash](https://tiswww.case.edu/php/chet/bash/bashtop.html)
client for the [tldr](https://github.com/rprieto/tldr/) project, providing
poignant examples of terminal commands.**

<img alt="tldr list screenshot" src="tldr-list.jpg" title="tldr list" width="600" />

This client can render both the old and the new tldr markup format.

## Installation
Download the tldr bash script to the install location:

```bash
location=/usr/local/bin/tldr  # elevated privileges needed for some locations
sudo wget -qO $location https://raw.githubusercontent.com/pepa65/tldr-bash-client/master/tldr
sudo chmod +x $location
```

If the location is not in $PATH, you need to specify the path to run it.

Alternately, you can do `sudo bpkg-install pepa65/tldr` if you have
[bpkg](https://github.com/bpkg/bpkg) installed.

<img alt="tldr page gif" src="tldr-page.gif" title="tldr page" />
[](<img alt="tldr page screenshot" src="tldr-page.jpg" title="tldr page" width="600" />)

### Prerequisites
coreutils, less, grep, unzip, curl / wget

<img alt="tldr usage screenshot" src="tldr-usage.jpg" title="tldr usage" width="600" />

## Customisation
The colors and other styling of the 5 elements of tldr pages can be modified
either by editing the first few lines of the scipt, or by setting the following
environment variables:
* TLDR_TITLE_STYLE (defaults to: Newline Space Bold Yellow)
* TLDR_DESCRIPTION_STYLE (defaults to: Space Yellow)
* TLDR_EXAMPLE_STYLE (defaults to: Newline Bold Green)
* TLDR_CODE_STYLE (defaults to: Space Bold Blue)
* TLDR_VALUE_STYLE (defaults to: Bold Cyan)

Also the error color and page expiry can easily be set:
* TLDR_ERROR_COLOR (defaults to: Red)
* TLDR_EXPIRY (defaults to: 60)

<img alt="tldr customize screenshot" src="tldr-customize.jpg" title="tldr customize" width="600" />

## Contributing

Please file an issue for a question, a bug or a feature request.
Or even better, send a pull request!

[tldr-bash-client github page](http://github.com/pepa65/tldr-bash-client "github.com/pepa65/tldr-bash-client")

<img alt="tldr markdown screenshot" src="tldr-markdown.jpg" title="tldr markdown" width="600" />

### License

Relicensed under GPL v3+

<img alt="tldr new markdown screenshot" src="tldr-markdown-new.jpg" title="tldr new markdown" width="600" />
