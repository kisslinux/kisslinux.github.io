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
    sed -E "s|^( +)(\[[0-9\.]*\])|\1<span id=\"#\2\">\2</span>|g" |
    sed -E "s|^\[[0-9\.]*\]|<span id=\"\0\">\0</span>|g" |
    sed -E "s|([^\"\> ]*)(\[[0-9\.]*\])$|\1<a href=\"#\2\">\2</a>|g" |
    sed -E "s|([^\"\> ]*)(\[[0-9\.]*\])([^\"\>])|\1<a href=\"#\2\">\2</a>|g" |

    # Insert the page into the template.
    sed -E '/%%CONTENT%%/r /dev/stdin' template.html |
    sed -E '/%%CONTENT%%/d' |

    # Calculate font scaling.
    sed -E "s|%%FONT%%|$len|g" |
    sed -E "s|%%SIZE%%|$((max + 28))|g" |

    # Insert the page path into the source URL.
    sed -E "s	%%SOURCE%%	${page##.}	"
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
        "$(git submodule foreach --quiet git log -1 \
        --format="Edited (<a href='$wiki_url/commit/%H'>%h</a>) at %as by %an" \
        "${page##*wiki/}")"
}

page() {
    page_parent=${page%/*}
    mkdir -p "docs/$page_parent"

    # PRE-GENERATION STEP.
    case $page in
        *.txt)
            max=

            while read -r line; do case $line in *[\<\>]*) ;;
                *) max=$((${#line} > max ? ${#line} : max))
            esac; done < "site/$page"

            len=$(printf 'scale=2;160 / %s - 0.01' "$max" | bc -l)
        ;;
    esac

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
            cp -f "site/$page" "docs/$page"
        ;;
    esac

    # POST-GENERATION STEP.
    case $page in
        # Hardlink all .txt files to the docs/ directory.
        *.txt) ln -f "site/$page" "docs/$page" ;;
    esac
}

main() {
    wiki_url=https://github.com/kisslinux/wiki

    (cd site && find . -type f) | while read -r page; do
        printf '%s\n' "CC $page"
        page "$page"
    done
}

main "$@"
