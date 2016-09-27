#!/bin/sh
# tldr client by Ray Lee, http://github.com/raylee/tldr
# Improvements added by Julien Reichardt https://github.com/j8r
# a Sunday afternoon's project, I'm sure there's room for improvement. PRs welcome!
# This script is implemented as POSIX-compliant.
# It should work on sh, dash, bash, ksh, zsh...

# initialize globals, sanity check the environment, etc.
config() {
    init_term_cmds

    if [ hash wget 2>/dev/null ] || [ hash curl 2>/dev/null ]; then
        echo "${red}tldr requires  \`wget\` or \`curl\` installed in your path$reset"
        exit 1
    fi

    configdir=~/.tldr/cache

    platform=$(get_platform)
    base_url="https://raw.githubusercontent.com/tldr-pages/tldr/master/pages"
    index_url="http://tldr-pages.github.io/assets/index.json"
    index="$configdir/index.json"
    cache_days=14
    force_update=

    #check if config folder exists, otherwise create it
    [ -d "$configdir" ] || mkdir -p "$configdir"

    [ ! -f $index ] && update_index || auto_update_index
}

download() {
  hash curl 2>/dev/null && curl -sf -o "$1" "$2" || { hash wget 2>/dev/null && wget -qO "$1" "$2"; }
}

update_index() {
  download "$index" "$index_url" || echo "Could not download index from $index_url" && exit 1
}

# if the file exists and is more recent than $cache_days old
recent() {
  exists=$(find "$1" -mtime -$cache_days 2>/dev/null)
  [ -n "$exists" -a -z "$force_update" ]
}

auto_update_index() {
  recent "$index" || update_index
}

# function contents via http://mywiki.wooledge.org/BashFAQ/037
init_term_cmds() {
    # only set if we're on an interactive session
    [ -t 2 ] && {
        reset=$(    tput sgr0   || tput me      ) # Reset cursor
        bold=$(     tput bold   || tput md      ) # Start bold
        under=$(    tput smul   || tput us      ) # Start underline
        italic=$(   tput sitm   || tput ZH      ) # Start italic
        eitalic=$(  tput ritm   || tput ZH      ) # End italic
        default=$(  tput op                     )
        back=$'\b'

        case $TERM in
          *-m) ;;
          *)
            black=$(    tput setaf 0 || tput AF 0    )
            red=$(      tput setaf 1 || tput AF 1    )
            green=$(    tput setaf 2 || tput AF 2    )
            yellow=$(   tput setaf 3 || tput AF 3    )
            blue=$(     tput setaf 4 || tput AF 4    )
            magenta=$(  tput setaf 5 || tput AF 5    )
            cyan=$(     tput setaf 6 || tput AF 6    )
            white=$(    tput setaf 7 || tput AF 7    )

            onblue=$(   tput setab 4 || tput AB 4    )
            ongrey=$(   tput setab 7 || tput AB 7    );;
        esac
    } 2>/dev/null ||:

    # osx's termcap doesn't have italics. The below adds support for iTerm2
    # and is harmless on Terminal.app
    [ "$(get_platform)" = "osx" ] && {
        italic=$(printf "\033[3m")
        eitalic=$(printf "\033[23m")
    }
}

heading() {
    local line="$*"
    printf "\n  $cyan${line#??}$reset"
}

quotation() {
    local line="$*"
    printf "  $yellow${line#??}$reset\n"
}

list_item() {
    local line="$*"
    printf "  $green$line$reset"
}

code() {
    local line="$*"
    # I'm sure there's a better way to strip the first and last characters.
    line="${line#?}"
    line="${line%\`}"
    # convert {{variable}} to italics
    # Check if the shell support buil-in substitutions
    (${a//}) 2>/dev/null && line=${line//\{\{/$reset$white} || { hash sed 2>/dev/null && line="$(printf "$line" | sed "s/{{/$reset$white/g" )"; }
    (${a//}) 2>/dev/null && line=${line//\}\}/$reset$$boldred} || { hash sed 2>/dev/null && line="$(printf "$line" | sed "s/}}/$reset$bold$red/g" )"; }

    printf "    $bold$red$line$reset\n"
}

text() {
    local line="$*"
    printf "  $line$reset\n"
}

# an idiot-level recognition of tldr's markdown. Needs improvement, or
# subcontracting out to a markdown -> ANSI formatting command
display_tldr() {
    # read one line at a time, don't strip whitespace ('IFS='), and process
    # last line even if it doesn't have a newline at the end
    while read line || [ -n "$line" ]; do
        # get the first character
        start=${line#?}
        start=${line%$start*}
        case "$start" in
            '#') heading "$line"
                ;;
            '>') quotation "$line"
                ;;
            '-') list_item "$line"
                ;;
            '`') code "$line"
                ;;
            *) text "$line"
                ;;
        esac
    done
}

# convert the local platorm name to tldr's version
get_platform() {
    case $(uname -s) in
        Darwin) echo "osx"    ;;
        Linux)  echo "linux"  ;;
        SunOS)  echo "sunos"  ;;
        *)      echo "common" ;;
    esac
}

# extract the platform key from index.json, return preferred subpath to tldrpage
path_for_cmd() {
    local desc=$(tr '{' '\n' < $index | grep "\"name\":\"$1\"")
    # results in, eg, "name":"netstat","platform":["linux","osx"]},

    [ -z "$desc" ] && return

    # use the platform specific version of the tldr first
    case "$desc" in
      *$platform*) echo "$platform/$1.md";;
      *common*) echo "common/$1.md";;
      *)
        # take the first one so we can show something, but warn the user
        local p=$(echo "$desc" | cut -d '"' -f 8)
        >&2 printf "${red}tldr page $1 not found in $platform or common, using page from platform $p instead$reset\n"
        echo "$p/$1.md";;
    esac
}

# return the local cached copy of the tldrpage, or retrieve and cache from github
get_tldr() {
    local p="$(path_for_cmd $1)"
    cached="$configdir/$p"
    recent "$cached" || { mkdir -p $(dirname $cached); download "$cached" "$base_url/$p"; }
    # if the download failed for some reason, keep cat from whinging
    [ ! "$2" ] && cat "$cached" 2>/dev/null
}

config

# Parse index.json to retrieve each programm
parse() {
  pindex=${pindex#*\"name\":\"}
  name=${pindex%%\"*}
  get_tldr $name parse
  echo "$cyan$name$reset tldr page downloaded"
  [ ${#pindex} = 31 ] && printf "\n${red}All pages downloaded to the cache$reset\n" && exit 0 || parse
}

usage() {
    cmd=$(basename $0)
    cat <<EOF

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


  The client caches a copy of all pages and the index locally under
  $configdir. By default, the cached copies will expire in $cache_days days.

EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
        -h|-\?|--help)
            usage
            ;;
        -d|--download)
            pindex=$(cat $configdir/index.json)
            parse
            ;;
        -l|--list)
            >&2 printf "Known tldr pages: \n"
            tr '{' '\n' < "$configdir/index.json" | cut -d '"' -f4
            exit 0
            ;;
        -p|--platform)
            shift
            platform=$1
            ;;
        -u|--update)
            download ~/.tldr/tldr.sh https://raw.githubusercontent.com/raylee/tldr/master/tldr.sh
            printf "${red}tldr updated to its newest version$reset\n"
            exit 0
            ;;
        -r|--refresh)
            force_update=yes
            update_index
            ;;
        -c|--clear)
            rm -rf $configdir/* && printf "Cache cleared!\n"
            update_index
            ;;
        -*)
            usage
            ;;
        *)
            page=${1:-''}
            ;;
    esac
    shift
done

[ -z "${page:-}" ] && usage

tldr="$(get_tldr $page)"

if [ -z "$tldr" ]; then
    printf "tldr page for command $page not found
Try updating with \"tldr --update\", or submit a pull request to:
https://github.com/tldr-pages/tldr\n"
    exit 1
fi

display_tldr <<E
$(printf "$tldr")
E
printf "\n\n"
