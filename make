#!/bin/sh -e
#
# Simple static site builder.

txt2html() {
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

page() {
    page_parent=${page%/*}
    mkdir -p "docs/$page_parent"

    case $page in
        # Generate HTML from Wiki pages.
        */wiki/index.txt)
            txt2html < "site/$page" > "docs/${page%%.txt}.html"
        ;;

        # Messy, but what can you do?
        */wiki/*.txt)
            cat - "site/$page" <<EOF | txt2html > "docs/${page%%.txt}.html"
<a href=/wiki>&lt;- Back to the Wiki</a>                                               <a href="$wiki_url/edit/master/${page##*wiki/}">Edit this page</a>

$(git submodule foreach --quiet git log -1 \
    --format="Edited (<a href=\"$wiki_url/commit/%H\">%h</a>) at %as by %an" \
    "${page##*wiki/}")


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

    (cd site && find . -type f) | while read -r page; do
        printf '%s\n' "CC $page"
        page "$page"
    done
}

main "$@"
