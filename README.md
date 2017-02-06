# tldr (bash)

**A fully-functional [bash](https://tiswww.case.edu/php/chet/bash/bashtop.html)
client for the [tldr](https://github.com/rprieto/tldr/) project, providing
poignant examples of terminal commands.**

![tldr screenshot list](tldr-list.jpg?raw=true "tldr list" {width=800px})

![tldr screenshot page](tldr-page.jpg?raw=true "tldr page" {width=800px})

## Installation
Download the tldr bash script to the install location:

```bash
location=/usr/local/bin/tldr  # elevated privileges needed for some locations
sudo wget -qO $location https://raw.githubusercontent.com/pepa65/tldr/master/tldr
sudo chmod +x $location
```

If the location is not in $PATH, you need to specify the path to run it.

### Prerequisites
coreutils, less, grep, unzip, curl / wget

![tldr screenshot usage](tldr-usage.jpg?raw=true "tldr usage" {width=800px})

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

![tldr screenshot customize](tldr-customize.jpg?raw=true "tldr customize" {width=800px})

## Contributing

Please file an issue for a question, a bug or a feature request.
Or even better, send a pull request!

![tldr screenshot markdown](tldr-markdown.jpg?raw=true "tldr markdown" {width=800px})

### License

Relicensed under GPL v3+
