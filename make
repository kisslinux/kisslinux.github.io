#!/bin/sh -e
#
# Simple static site builder.

txt2html() {
    # Transform plain-text input into HTML and insert it into the template.
    # Right now this only does some URL transformations.

    # Convert all plain-text links to HTML links (<a href="X">X</a>).
    sed -E "s|([^=][^\'\"])(https[:]//[^ )]*)|\1<a href='\2'>\2</a>|g" |
    sed -E "s|^(https[:]//[^ )]{50})([^ )]*)|<a href='\0'>\1</a>|g" |

    # Convert @/words to relative HTML links.
    # Convert $/words to GitHub URLs.
    sed -E "s|[^\\]@/([^ ]*)| <a href=\"${page_parent##.}/\1\">\1</a>  |g" |
    sed -E "s|[^\\]\\$/([^ ]*)| <a href=\"https://github.com/\1\">\1</a>  |g" |

    # Convert [0] into HTML links.
    sed -E "s|(.)(\[[0-9]*\])|\1<a href=\"#\2\">\2</a>|g" |
    sed -E "s|^\[[0-9]*\]|<span id=\"\0\">\0</span>|g" |

    # Insert the page into the template.
    sed -E '/%%CONTENT%%/r /dev/stdin' template.html |

    # Remove the placeholder.
    sed -E '/%%CONTENT%%/d' |

    # Insert the page path into the source URL.
    sed -E "s	%%SOURCE%%	${page##.}	"
}

wiki_nav() {
    # Split the path on '/'.
    # shellcheck disable=2086
    set -f; IFS=/
    set +f ${page##./}
    unset IFS

    # '$nar' contains the generated nav without HTML additions for use in
    # length calculations below.
    nav="<a href=\"/$1\">$1</a>" nar=$1

    [ "$2" ] &&             nav="$nav / <a href='/$1/$2'>$2</a>" nar="$nar / $2"
    [ "${3#index.txt}" ] && nav="$nav / ${3%%.txt}" nar="$nar / ${3%%.txt}"

    # Calculate the amount of padding to add. This will right align the
    # edit page link. Wiki page length is always 80 columns.
    nav="$nav$(printf '%*s' "$((80 - ${#nar} - 14))" "")"
    nav="$nav<a href='$wiki_url/edit/master/${page##*wiki/}'>Edit this page</a>"

    # Add the last edited information below.
    nav="$nav

$(git submodule foreach --quiet git log -1 \
    --format="Edited (<a href=\"$wiki_url/commit/%H\">%h</a>) at %as by %an" \
    "${page##*wiki/}")"
}

page() {
    page_parent=${page%/*}
    mkdir -p "docs/$page_parent"

    case $page in
        # Generate HTML from Wiki pages.
        */wiki/index.txt)
            txt2html < "site/$page" > "docs/${page%%.txt}.html"
        ;;

        */wiki/*.txt)
            wiki_nav

            cat - "site/$page" <<-EOF | txt2html > "docs/${page%%.txt}.html"
				$nav


			EOF
        ;;

        # Generate HTML from txt files.
        *.txt)
            txt2html < "site/$page" > "docs/${page%%.txt}.html"
        ;;

        # Copy over any non-txt files.
        *)
            cp -f "site/$page" "docs/$page"
        ;;
    esac

    case $page in
        # Hardlink all .txt files to the docs/ directory.
        *.txt) ln -f "site/$page" "docs/$page" ;;
    esac
}

main() {
    wiki_url=https://github.com/kisslinux/wiki

    # Generate index pages for the Wiki.
    (cd site && find wiki -type d) | while read -r page; do
        case $page in
            wiki/*)
                printf '%s\n________________________________________________________________________________\n\n' "${page##*/}" > "site/$page/index.txt"

                for p in "site/$page/"*.txt; do p=${p##site/wiki/*/}
                    [ "${p##*/}" = index.txt ] || printf '%s\n' "- @/${p%%.txt}"
                done >> "site/$page/index.txt"
            ;;
        esac
    done

    (cd site && find . -type f) | while read -r page; do
        printf '%s\n' "CC $page"
        page "$page"
    done

    # Let's not dirty the submodule.
    rm -f site/wiki/*/index.txt
}

main "$@"
