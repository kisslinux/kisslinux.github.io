#!/bin/sh -e
#
# Simple static site builder.

txt2html() {
    # Transform plain-text input into HTML and insert it into the template.
    # Right now this only does some URL transformations.

    # Convert all plain-text links to HTML links (<a href="X">X</a>).
    sed -E "s|([^\"\'\>=])(http[s]?://[^[:space:]\)]*)|\1<a href=\2>\2</a>|g" |
    sed -E "s|^(http[s]?://[^[:space:]\)]*)|<a href=\1>\1</a>|g" |

    # Convert @/words to relative HTML links.
    # Convert %/words to absolute wiki links (packages).
    # Convert #/words to absolute HTML links.
    # Convert $/words to GitHub URLs.
    sed -E "s|(@/)([^ \)]*)|\1<a href=$1/\2>\2</a>|g" |
    sed -E "s|(%/)([^ \)]*)|\1<a href=/wiki/pkg/\2>\2</a>|g" |
    sed -E "s|(\\#/)([^ \)]*)|\1<a href=/\2>\2</a>|g" |
    sed -E "s|(\\$/)([^ \)]*)|\1<a href=https://github.com/\2>\2</a>|g" |

    # Convert [0-9] into HTML links.
    sed -E "s|^([ -]*)\[([0-9\.]*)\]|\1<span id=\2>[\2]</span>|g" |
    sed -E "s|([^\"#])\[([0-9\.]*)\]|\1[<a class=t href=#\2>\2</a>]|g" |

    # Insert the page into the template.
    sed -E '/%%CONTENT%%/r /dev/stdin' template.html |
    sed -E '/%%CONTENT%%/d' |

    # Insert the page path into the source URL.
    sed -E "s	%%TITLE%%	${2:-home}	"
}

page() {
    pp=${1%/*}
    title=${1##*/}
    title=${title%%.txt}
    title=${title##index}

    mkdir -p "docs/$pp"

    # Generate HTML from txt files.
    case $1 in *.txt)
        txt2html "${pp#.}" "$title" < "site/$1" > "docs/${1%%.txt}.html"
    esac

    cp -Lf "site/$1" "docs/$1"
}

pkg() {
    mkdir -p site/wiki/pkg

    # Get git log of all packages.
    git -C "$KISS_REPO" log \
        --date=short \
        --pretty="format:%cd <a href=\"$url/commit/%H\">%h</a> %s" \
        > .log

    for pkg in "$KISS_REPO"/*/*/; do
        pkg=${pkg%%/}
        rep=${pkg%/*}
        rep=${rep##*/}

        while IFS= read -r line || [ "$line" ]; do case $line in
            # Insert package version.
            "${pkg##*/}")
                read -r ver _ < "$pkg/version"
                printf "%s%$((80 - ${#line}))s\\n" "$line" "version $ver" |
                    sed "s	$ver	<a href=$url/tree/master/$rep/$line>$ver</a>	"
            ;;

            # Insert new entries into index.
            "* References"*)
                _i=${line##*\[0}
                _i=${_i#0}
                _i=${_i%%']'}
                printf '* History ................................................................ [%03d]\n' "$_i"
                printf '%s[%03d]\n' "${line%'['*}" "$((_i + 1))"
            ;;

            # Insert new entries into page.
            "["???"] References"*)
                printf '[%03d] History\n' "$_i"
                printf '________________________________________________________________________________\n\n'
                printf '<div style="max-height:177px;overflow:hidden scroll">'
                grep -F "${pkg##*/}: " .log
                printf '</div>\n\n[%03d] References\n' "$((_i + 1))"
            ;;

            *)
                printf '%s\n' "$line"
            ;;
        esac done < "$pkg/README" > "site/wiki/pkg/${pkg##*/}.txt" || :

    done

    rm -f .log
}

main() {
    rm -rf docs && mkdir -p docs
    url=https://github.com/kisslinux/repo

    [ -z "$KISS_REPO" ] || pkg

    (cd site && find . ! -type d) |

    while read -r page; do
        printf '%s\n' "CC $page"
        page "$page"
    done

    [ -z "$KISS_REPO" ] || rm -rf site/wiki/pkg
}

main "$@"
