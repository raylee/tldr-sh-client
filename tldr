#!/usr/bin/env bash
set +vx -o pipefail
[[ $- = *i* ]] && echo "Don't source this script!" && return 1
version='0.39'
# tldr-bash-client version 0.39
# Bash client for tldr: community driven man-by-example
# - forked from Ray Lee, https://github.com/raylee/tldr
# - modified and expanded by pepa65: https://github.com/pepa65/tldr-bash-client
# - binary download: http://4e4.win/tldr
# Requiring: coreutils, grep, unzip, curl/wget, less (optional)

# The 5 elements in TLDR markup that can be styled with these colors and
# backgrounds (last one specified will be used) and modes (more can apply):
#  Colors: Black, Red, Green, Yellow, Blue, Magenta, Cyan, White
#  BG: BlackBG, RedBG, GreenBG, YellowBG, BlueBG, MagentaBG, CyanBG, WhiteBG
#  Modes: Bold, Underline, Italic, Inverse
# 'Newline' can be added to the style list to add a newline before the element
# and 'Space' to add a space at the start of the line
# (style items are separated by space, lower/uppercase mixed allowed)
: "${TLDR_TITLE_STYLE:= Newline Space Bold Yellow }"
: "${TLDR_DESCRIPTION_STYLE:= Space Yellow }"
: "${TLDR_EXAMPLE_STYLE:= Newline Space Bold Green }"
: "${TLDR_CODE_STYLE:= Space Bold Blue }"
: "${TLDR_VALUE_ISTYLE:= Space Bold Cyan }"
# The Value style (above) is an Inline style: doesn't take Newline or Space
# Inline styles for help text: default, URL, option, platform, command, header
: "${TLDR_DEFAULT_ISTYLE:= White }"
: "${TLDR_URL_ISTYLE:= Yellow }"
: "${TLDR_HEADER_ISTYLE:= Bold }"
: "${TLDR_OPTION_ISTYLE:= Bold Yellow }"
: "${TLDR_PLATFORM_ISTYLE:= Bold Blue }"
: "${TLDR_COMMAND_ISTYLE:= Bold Cyan }"
: "${TLDR_FILE_ISTYLE:= Bold Magenta }"
# Color/BG (Newline and Space also allowed) for error and info messages
: "${TLDR_ERROR_COLOR:= Newline Space Red }"
: "${TLDR_INFO_COLOR:= Newline Space Green }"

# How many days before freshly downloading a potentially stale page
: "${TLDR_EXPIRY:= 60 }"

# Alternative location of pages cache
: "${TLDR_CACHE:= }"

# Usage of 'less' or 'cat' for output (set to '0' for cat)
: "${TLDR_LESS:= }"

## Function definitions

# $1: [optional] exit code; Uses: version cachedir
Usage(){
	Out "$(cat <<-EOF
		 $E$version

		 ${HDE}USAGE: $HHE$(basename "$0")$XHHE [${HOP}option$XHOP] [${HPL}platform$XHPL/]${HCO}command$XHCO

		 $HDE[${HPL}platform$XHPL/]${HCO}command$XHCO:          Show page for ${HCO}command$XHCO (from ${HPL}platform$XHPL)

		 ${HPL}platform$XHPL (optional) one of: ${HPL}common$XHPL, ${HPL}linux$XHPL, ${HPL}osx$XHPL, ${HPL}sunos$XHPL, ${HPL}windows$XHPL,
		                             ${HPL}current$XHPL (includes ${HPL}common$XHPL)

		 ${HOP}option$XHOP is optionally one of:
		  $HOP-s$XHOP, $HOP--search$XHOP ${HFI}regex$XHFI:         Search for ${HFI}regex$XHFI in all tldr pages
		  $HOP-l$XHOP, $HOP--list$XHOP [${HPL}platform$XHPL]:      List all pages (from ${HPL}platform$XHPL)
		  $HOP-a$XHOP, $HOP--list-all$XHOP:             List all pages from current platform + common
		  $HOP-r$XHOP, $HOP--render$XHOP ${HFI}file$XHFI:          Render ${HFI}file$XHFI as tldr markdown
		  $HOP-m$XHOP, $HOP--markdown$XHOP ${HCO}command$XHCO:     Show the markdown source for ${HCO}command$XHCO
		  $HOP-u$XHOP, $HOP--update$XHOP:               Update the pages cache by downloading repo archive
		  $HOP-v$XHOP, $HOP--version$XHOP:              Version number and github repo location
		  $HDE[$HOP-h$XHOP, $HOP-?$XHOP, $HOP--help$XHOP]:           This help overview

		 ${HDE}Element styling:$XHDE ${T}Title$XT ${D}Description$XD ${E}Example$XE ${C}Code$XC ${V}Value$XV
		 ${HDE}All pages and the index are cached locally under $HUR$cachedir$XHUR.
		 ${HDE}By default, the cached copies will be freshly downloaded after $HUR${TLDR_EXPIRY// /}$XHUR days.
		EOF
	)"
	exit "${1:-0}"
}

# $1: keep output; Uses/Sets: stdout
Out(){ stdout+=$1$N;}

# $1: keep error messages
Err(){ Out "$ERRNL$ERRSP$ERR$B$1$XB$XERR";}

# $1: keep info messages
Inf(){ Out "$INFNL$INFSP$INF$B$1$XB$XINF";}

# $1: Style specification; Uses: color xcolor bg xbg mode xmode
Style(){
	local -l style
	STYLES='' XSTYLES='' COLOR='' XCOLOR='' NL='' SP=''
	for style in $1
	do
		[[ $style = newline ]] && NL=$N
		[[ $style = space ]] && SP=' '
		COLOR+=${color[$style]:-}${bg[$style]:-}
		XCOLOR=${xbg[$style]:-}${xcolor[$style]:-}$XCOLOR
		STYLES+=${color[$style]:-}${bg[$style]:-}${mode[$style]:-}
		XSTYLES=${xmode[$style]:-}${xbg[$style]:-}${xcolor[$style]:-}$XSTYLES
	done
}	

# Sets: color xcolor bg xbg mode xmode
Init_term(){
	[[ -t 2 ]] && {  # only if interactive session (stderr open)
			B=$'\e[1m' # $(tput bold || tput md)  # Start bold
			XB=$'\e[0m'  # End bold (no tput code...)
			U=$'\e[4m' # $(tput smul || tput us)  # Start underline
			XU=$'\e[24m' # $(tput rmul || tput ue)  # End underline
			I=$'\e[3m' # $(tput sitm || tput ZH)  # Start italic
			XI=$'\e[23m' # $(tput ritm || tput ZR)  # End italic
			R=$'\e[7m' # $(tput smso || tput so)  # Start reverse
			XR=$'\e[27m' # $(tput rmso || tput se)  # End reverse
			#X=$'\e[0m' # $(tput sgr0 || tput me)  # End all

		[[ $TERM != *-m ]] && {
				BLA=$'\e[30m' # $(tput setaf 0 || tput AF 0)
				RED=$'\e[31m' # $(tput setaf 1 || tput AF 1)
				GRE=$'\e[32m' # $(tput setaf 2 || tput AF 2)
				YEL=$'\e[33m' # $(tput setaf 3 || tput AF 3)
				BLU=$'\e[34m' # $(tput setaf 4 || tput AF 4)
				MAG=$'\e[35m' # $(tput setaf 5 || tput AF 5)
				CYA=$'\e[36m' # $(tput setaf 6 || tput AF 6)
				WHI=$'\e[37m' # $(tput setaf 7 || tput AF 7)
				DEF=$'\e[39m' # $(tput op)
				BLAB=$'\e[40m' # $(tput setab 0 || tput AB 0)
				REDB=$'\e[41m' # $(tput setab 1 || tput AB 1)
				GREB=$'\e[42m' # $(tput setab 2 || tput AB 2)
				YELB=$'\e[43m' # $(tput setab 3 || tput AB 3)
				BLUB=$'\e[44m' # $(tput setab 4 || tput AB 4)
				MAGB=$'\e[45m' # $(tput setab 5 || tput AB 5)
				CYAB=$'\e[46m' # $(tput setab 6 || tput AB 6)
				WHIB=$'\e[47m' # $(tput setab 7 || tput AB 7)
				DEFB=$'\e[49m' # $(tput op)
		}
	}

	declare -A color=(['black']=$BLA ['red']=$RED ['green']=$GRE ['yellow']=$YEL \
			['blue']=$BLU ['magenta']=$MAG ['cyan']=$CYA ['white']=$WHI)
	declare -A xcolor=(['black']=$DEF ['red']=$DEF ['green']=$DEF ['yellow']=$DEF \
			['blue']=$DEF ['magenta']=$DEF ['cyan']=$DEF ['white']=$DEF)
	declare -A bg=(['blackbg']=$BLAB ['redbg']=$REDB ['greenbg']=$GREB ['yellowbg']=$YELB \
			['bluebg']=$BLUB ['magentabg']=$MAGB ['cyanbg']=$CYAB ['whitebg']=$WHIB)
	declare -A xbg=(['blackbg']=$DEFB ['redbg']=$DEFB ['greenbg']=$DEFB ['yellowbg']=$DEFB \
			['bluebg']=$DEFB ['magentabg']=$DEFB ['cyanbg']=$DEFB ['whitebg']=$DEFB)
	declare -A mode=(['bold']=$B ['underline']=$U ['italic']=$I ['inverse']=$R)
	declare -A xmode=(['bold']=$XB ['underline']=$XU ['italic']=$XI ['inverse']=$XR)

	# the 5 main tldr page styles and error message colors
	Style "$TLDR_TITLE_STYLE"
	T=$STYLES XT=$XSTYLES TNL=$NL TSP=$SP
	Style "$TLDR_DESCRIPTION_STYLE"
	D=$STYLES XD=$XSTYLES DNL=$NL DSP=$SP
	Style "$TLDR_EXAMPLE_STYLE"
	E=$STYLES XE=$XSTYLES ENL=$NL ESP=$SP
	Style "$TLDR_CODE_STYLE"
	C=$STYLES XC=$XSTYLES CNL=$NL CSP=$SP
	Style "$TLDR_VALUE_ISTYLE"
	V=$STYLES XV=$XSTYLES
	Style "$TLDR_DEFAULT_ISTYLE"
	HDE=$STYLES XHDE=$XSTYLES
	Style "$TLDR_URL_ISTYLE"
	URL=$STYLES XURL=$XSTYLES
	HUR=$XHDE$STYLES XHUR=$XSTYLES$HDE
	Style "$TLDR_OPTION_ISTYLE"
	HOP=$XHDE$STYLES XHOP=$XSTYLES$HDE
	Style "$TLDR_PLATFORM_ISTYLE"
	HPL=$XHDE$STYLES XHPL=$XSTYLES$HDE
	Style "$TLDR_COMMAND_ISTYLE"
	HCO=$XHDE$STYLES XHCO=$XSTYLES$HDE
	Style "$TLDR_FILE_ISTYLE"
	HFI=$XHDE$STYLES XHFI=$XSTYLES$HDE
	Style "$TLDR_HEADER_ISTYLE"
	HHE=$XHDE$STYLES XHHE=$XSTYLES$HDE
	Style "$TLDR_ERROR_COLOR"
	ERR=$COLOR XERR=$XCOLOR ERRNL=$NL ERRSP=$SP
	Style "$TLDR_INFO_COLOR"
	INF=$COLOR XINF=$XCOLOR INFNL=$NL INFSP=$SP
}

# $1: page
Recent(){ find "$1" -mtime -"${TLDR_EXPIRY// /}" >/dev/null 2>&1;}

# Initialize globals, check the environment; Uses: config cachedir version
# Sets: stdout os version dl
Config(){
	type -p less >/dev/null || TLDR_LESS=0

	os=common stdout='' Q='"' N=$'\n'
	case "$(uname -s)" in
		Darwin) os='osx' ;;
		Linux) os='linux' ;;
		SunOS) os='sunos' ;;
		CYGWIN*) os='windows' ;;
		MINGW*) os='windows' ;;
	esac
	Init_term
	[[ $TLDR_LESS = 0 ]] && 
		trap 'cat <<<"$stdout"' EXIT ||
		trap 'less -~RXQFP"Browse up/down, press Q to exit " <<<"$stdout"' EXIT

	version="tldr-bash-client version $version$XB ${URL}http://github.com/pepa65/tldr-bash-client$XURL"

	# Select download method
	dl="$(type -p curl) -sLfo" || {
		dl="$(type -p wget) --max-redirect=20 -qNO" || {
			Err "tldr requires ${I}curl$XI or ${I}wget$XI installed in your path"
			exit 3
		}
	}

	pages_url='https://raw.githubusercontent.com/tldr-pages/tldr/master/pages'
	zip_url='http://tldr.sh/assets/tldr.zip'

	cachedir=$(echo $TLDR_CACHE)
	if [[ -z $cachedir ]]
	then
		[[ $XDG_DATA_HOME ]] && cachedir=$XDG_DATA_HOME/tldr ||
			cachedir=$HOME/.local/share/tldr
	fi
	[[ -d "$cachedir" ]] || mkdir -p "$cachedir" || {
		Err "Can't create the pages cache location $cachedir"
		exit 4
	}
	index=$cachedir/index.json
	# update if the file doesn't exists, or if it's older than $TLDR_EXPIRY
	[[ -f $index ]] && Recent "$index" || Cache_fill
}

# $1: error message; Uses: md REPLY ln
Unlinted(){
	Err "Page $I$md$XI not properly linted!$N${ERRSP}${ERR}Line $I$ln$XI [$XERR$U$REPLY$XU$ERR]$N$ERRSP$ERR$1"
	exit 5
}

# $1: page; Uses: index cachedir pages_url platform os dl cached md
# Sets: cached md
Get_tldr(){
	local desc err=0 notfound
	# convert the local platform name to tldr's version
	# extract the platform key from index.json, return preferred subpath to page
	desc=$(tr '{' '\n' <"$index" |grep "\"name\":\"$1\"")
	# results in, eg, "name":"netstat","platform":["linux","osx"]},

	[[ $desc ]] || return  # nothing found

	if [[ $platform ]]
	then  # platform given on commandline
		[[ ! $desc =~ \"$platform\" ]] && notfound=$I$platform$XI && err=1 || md=$platform/$1.md
	else  # check common
		[[ $desc =~ \"common\" ]] && md=common/$1.md || {  # not in common either
			[[ $notfound ]] && notfound+=" or "
			notfound+=${I}common$XI
		}
	fi
	# if no page found yet, try the system platform
	[[ $md ]] || [[ $platform = $os ]] || {
			[[ $desc =~ \"$os\" ]] && md=$os/$1.md
	} || {
		notfound+=" or $I$os$XI"
		err=1
	}
	# if still no page found, get the first entry in index
	[[ $md ]] || md=$(cut -d "$Q" -f 8 <<<"$desc")/"$1.md"
	((err)) && Err "tldr page $I$1$XI not found in $notfound, from platform $U${md%/*}$XU instead"

	# return the local cached copy of the tldrpage, or retrieve and cache from github
	cached=$cachedir/$md
	Recent "$cached" || {
		mkdir -p "${cached%/*}"
		$dl "$cached" "$pages_url/$md" || Err "Could not download page $I$cached$XI with $dl"
	}
}

# $1: file (optional); Uses: page stdout; Sets: ln REPLY
Display_tldr(){
	local newfmt len val
	ln=0 REPLY=''
	[[ $md ]] || md=$1
	# Read full lines, and process even when no newline at the end
	while read -r || [[ $REPLY ]]
	do
		((++ln))
		((ln==1)) && {
			[[ ${REPLY:0:1} = '#' ]] && newfmt=0 || newfmt=1
			((newfmt)) && {
				[[ $REPLY ]] || Unlinted "Empty title"
				Out "$TNL$TSP$T$REPLY$XT"
				len=${#REPLY}  # title length
				read -r
				((++ln))
				[[ $REPLY =~ [^=] ]] && Unlinted "Title underline must be equal signs"
				((len!=${#REPLY})) && Unlinted "Underline length not equal to title's"
				read -r
				((++ln))
			}
		}
		case "${REPLY:0:1}" in  # first character
			'#') ((newfmt)) && Unlinted "Bad first character"
				((${#REPLY} <= 2)) && Unlinted "No title"
				[[ ! ${REPLY:1:1} = ' ' ]] && Unlinted "2nd character no space"
				Out "$TNL$TSP$T${REPLY:2}$XT" ;;
			'>') ((${#REPLY} <= 3)) && Unlinted "No valid desciption"
				[[ ! ${REPLY:1:1} = ' ' ]] && Unlinted "2nd character no space"
				[[ ! ${REPLY: -1} = '.' ]] && Unlinted "Description doesn't end in full stop"
				Out "$DNL$DSP$D${REPLY:2}$XD"
				DNL='' ;;
			'-') ((newfmt)) && Unlinted "Bad first character"
				((${#REPLY} <= 2)) && Unlinted "No example content"
				[[ ! ${REPLY:1:1} = ' ' ]] && Unlinted "2nd character no space"
				Out "$ENL$ESP$E${REPLY:2}$XE" ;;
			' ') ((newfmt)) || Unlinted "Bad first character"
				((${#REPLY} <= 4)) && Unlinted "No valid code content"
				[[ ${REPLY:0:4} = '    ' ]] || Unlinted "No four spaces before code"
				val=${REPLY:4}
				# Value: convert {{value}}
				val=${val//\{\{/$CX$V}
				val=${val//\}\}/$XV$C}
				Out "$CNL$CSP$C$val$XC" ;;
			'`') ((newfmt)) && Unlinted "Bad first character"
				((${#REPLY} <= 2)) && Unlinted "No valid code content"
				[[ ! ${REPLY: -1} = '`' ]] && Unlinted "Code doesn't end in backtick"
				val=${REPLY:1:${#REPLY}-2}
				# Value: convert {{value}}
				val=${val//\{\{/$CX$V}
				val=${val//\}\}/$XV$C}
				Out "$CNL$CSP$C$val$XC" ;;
			'') continue ;;
			*) ((newfmt)) || Unlinted "Bad first character"
				[[ -z $REPLY ]] && Unlinted "No example content"
				Out "$ENL$ESP$E$REPLY$XE" ;;
		esac
	done <"$1"
	[[ $TLDR_LESS = 0 ]] && 
		trap 'cat <<<"$stdout"' EXIT ||
		trap 'less +Gg -~RXQFP"%pB\% tldr $I$page$XI - browse up/down, press Q to exit" <<<"$stdout"' EXIT
}

# $1: exit code; Uses: platform index
List_pages(){
	local platformtext c1 c2 c3
	[[ $platform ]] && platformtext="platform $I$platform$XI" ||
		platform=^ platformtext="${I}all$XI platforms"
	[[ $platform = current ]] && platform="-e $os -e common" &&
		platformtext="$I$os$XI platform and ${I}common$XI"
	Inf "Known tldr pages from $platformtext:"
	Out "$(while read -r c1 c2 c3; do printf "%-19s %-19s %-19s %-19s$N" $c1 $c2 $c3; done \
			<<<$(tr '{' '\n' <"$index" |grep $platform |cut -d "$Q" -f4))"
	exit "$1"
}

# $1: regex, $2: exit code; Uses: cachedir
Find_regex(){
	local list=$(grep "$1" "$cachedir"/*/*.md |cut -d: -f1) regex="$U$1$XU"
	local n=$(wc -l <<<"$list")
	list=$(sort -u <<<"$list")
	[[ -z $list ]] && Err "Regex $regex not found" && exit 6
	local t=$(wc -l <<<"$list")
	if ((t==1))
	then
		Display_tldr "$list"
	else
		Inf "Regex $regex $I$n$XI times found in these $I$t$XI tldr pages:"
		Out "$(while read -r c1 c2 c3; do printf "%-19s %-19s %-19s %-19s$N" $c1 $c2 $c3; done \
			<<<$(sed -e 's@.*/@@' -e 's@...$@@' <<<"$list"))"
	fi
	exit "$2"
}

# $1: exit code; Uses: dl cachedir zip_url
Cache_fill(){
	local tmp unzip
	unzip="$(type -p unzip) -q" || {
		Err "tldr requires ${I}unzip$XI to fill the cache"
		exit 7
	}
	tmp=$(mktemp -d)
	$dl "$tmp/pages.zip" "$zip_url" || {
		rm -- "$tmp"
		Err "Could not download pages archive from $U$zip_url$XU with $dl"
		exit 8
	}
	$unzip "$tmp/pages.zip" -d "$tmp" 'pages/*' || {
		rm -- "$tmp"
		Err "Couldn't unzip the cache archive on $tmp/pages.zip"
		exit 9
	}
	rm -rf -- "${cachedir:?}/"*
	mv -- "$tmp/pages/"* "${cachedir:?}/"
	rm -rf -- "$tmp"
	Inf "Pages cached in $U$cachedir$XU"
}

# $@: commandline parameters; Uses: version cached; Sets: platform page
Main(){
	local markdown=0 err=0 nomore='No more command line arguments allowed'
	Config
	case "$1" in
	-s|--search) [[ -z $2 ]] && Err "Search term (regex) needed" && Usage 10
		[[ $3 ]] && Err "$nomore" && err=11
		Find_regex "$2" "$err" ;;
	-l|--list) [[ $2 ]] && {
			platform=$2
			[[ ,common,linux,osx,sunos,windows,current, != *,$platform,* ]] &&
				Err "Unknown platform $I$platform$XI" && Usage 12
			[[ $3 ]] && Err "$nomore" && err=13
		}
		List_pages "$err" ;;
	-a|--list-all) [[ $2 ]] && Err "$nomore" && err=14
		platform=current
		List_pages $err ;;
	-u|--update) [[ $2 ]] && Err "$nomore" && err=15
		Cache_fill
		exit "$err" ;;
	-v|--version) [[ $2 ]] && Err "$nomore" && err=16
		Inf "$version"
		exit "$err" ;;
	-r|--render) [[ -z $2 ]] && Err "Specify a file to render" && Usage 17
		[[ $3 ]] && Err "$nomore" && err=18
		[[ -f "$2" ]] && {
			Display_tldr "$2" && exit "$err"
			Err "A file error occured"
			exit 19
		} || Err "No file: ${I}$2$XI" && exit 20 ;;
	-m|--markdown) shift
		page=$*
		[[ -z $page ]] && Err "Specify a page to display" && Usage 21
		[[ -f "$page" && ${page: -3:3} = .md ]] && Out "$(cat "$page")" && exit 0
		markdown=1 ;;
	''|-h|-\?|--help) [[ $2 ]] && Err "$nomore" && err=22
		Usage "$err" ;;
	-*) Err "Unrecognized option $I$1$XI"; Usage 23 ;;
	*) page=$* ;;
	esac

	[[ -z $page ]] && Err "No command specified" && Usage 24
	[[ ${page:0:1} = '-' || $page = *' '-* ]] && Err "Only one option allowed" && Usage 25
	[[ $page = */* ]] && platform=${page%/*} && page=${page##*/}
	[[ $platform && ,common,linux,osx,sunos,windows, != *,$platform,* ]] && {
		Err "Unknown platform $I$platform$XI"
		Usage 26
	}

	Get_tldr "${page// /-}"
	[[ ! -s $cached ]] && Err "tldr page for command $I$page$XI not found" \
			&& Inf "Contribute new pages at:$XB ${URL}https://github.com/tldr-pages/tldr$XURL" && exit 27
	((markdown)) && Out "$(cat "$cached")" || Display_tldr "$cached"
}

Main "$@"
# The error trap will output the accumulated stdout
exit 0
