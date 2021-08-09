#!/bin/sh -e
#
# Simple static site builder.

txt2html() {
    # Transform plain-text input into HTML and insert it into the template.
    # Right now this only does some URL transformations.

    # Convert all plain-text links to HTML links (<a href="X">X</a>).
    sed -E "s|([^\"\'\>=])(http[s]?://[^[:space:]\)]*)|\1<a href=\2>\2</a>|g" |
    sed -E "s|^(http[s]?://[^[:space:]\)]*)|<a href=\1>\1</a>|g" |

    # Convert #/words to absolute HTML links.
    # Convert @/words to relative HTML links.
    # Convert $/words to GitHub URLs.
    sed -E "s|(#/)([^ \)]*)|\1<a href=/\2>\2</a>|g" |
    sed -E "s|(@/)([^ \)]*)|\1<a href=${pp##.}/\2>\2</a>|g" |
    sed -E "s|(\\$/)([^ \)]*)|\1<a href=$repo_url/\2>\2</a>|g" |

    # Convert [0] into HTML links.
    sed -E "s|^( *)\[([0-9\.]*)\]|\1<span id=\2>[\2]</span>|g" |
    sed -E "s|([^\"#])\[([0-9\.]*)\]|\1<a href=#\2>[\2]</a>|g" |

    # Insert the page into the template.
    sed -E '/%%CONTENT%%/r /dev/stdin' template.html |
    sed -E '/%%CONTENT%%/d' |

    # Insert the page path into the source URL.
    sed -E "s	%%TITLE%%	$title	"
}

wiki_nav() {
    # Generate the navigation bar and edit information for each Wiki page.

    # Split the path on '/'.
    # shellcheck disable=2086
    {
        set -f; IFS=/
        set +f ${page##./}
        unset IFS
    }

    # '$nar' contains the generated nav without HTML additions for use in
    # length calculations below.
    nav="<a href=\"/$1\">$1</a>" nar=$1

    [ "$2" ] &&             nav="$nav / <a href='/$1/$2'>$2</a>" nar="$nar / $2"
    [ "${3#index.txt}" ] && nav="$nav / ${3%%.txt}" nar="$nar / ${3%%.txt}"

    # Calculate the amount of padding to add. This will right align the
    # edit page link. Wiki page length is always 80 columns.
    nav="$nav$(printf '%*s' "$((80 - ${#nar} - 14))" "")"
    nav="$nav<a href='$wiki_url/edit/master/${page##*wiki/}'>Edit this page</a>"

    printf '%s\n\n%s\n\n\n' "$nav" \
        "$(git -C site/wiki log -1 \
        --format="Edited (<a href='$wiki_url/commit/%H'>%h</a>) at %as by %an" \
        "${page##*wiki/}")"
}

page() {
    pp=${page%/*}; title=${page##*/}; title=${title%%.txt}

    mkdir -p "docs/$pp"

    # If the title is index.txt, set it to the parent directory name.
    # Example: /wiki/index.txt (index) -> (wiki).
    case $title in index) title=${pp##*/} ;; esac
    case $title in .)     title=home ;; esac

    # GENERATION STEP.
    case $page in
        # Generate HTML from Wiki pages.
        */wiki/index.txt)
            txt2html < "site/$page" > "docs/${page%%.txt}.html"
        ;;

        */wiki/*.txt)
            wiki_nav | cat - "site/$page" | txt2html > "docs/${page%%.txt}.html"
        ;;

        # Generate HTML from txt files.
        *.txt)
            txt2html < "site/$page" > "docs/${page%%.txt}.html"
        ;;

        # Copy over any non-txt files.
        *)
            cp -Lf "site/$page" "docs/$page"
        ;;
    esac

    # POST-GENERATION STEP.
    case $page in
        *.txt) cp -Lf "site/$page" "docs/$page" ;;
    esac
}

main() {
    wiki_url=https://github.com/kisslinux/wiki
    repo_url=https://github.com

    rm -rf docs
    mkdir -p docs

    (cd site && find . ! -type d) | while read -r page; do
        case $page in
            ./kiss/*)
                # Skip.
            ;;

            *)
                printf '%s\n' "CC $page"
                page "$page"
            ;;
        esac
    done
}

main "$@"
