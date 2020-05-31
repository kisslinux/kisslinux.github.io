#!/bin/sh -e
#
# Simple static site builder.

mkdir -p docs/package-system

# Workaround for broken repology link.
ln -sf ../package-system.html docs/package-system/index.html

# Iterate over each file in the source tree under /site/.
(cd site && find . -type f) | while read -r page; do
    mkdir -p "docs/${page%/*}"

    printf '%s\n' "CC $page"

    case $page in
        */.git/*) continue ;;

        *.txt)
            # Useless use of cat solely so that the first 'sed' doesn't exceed
            # the line limit. (/dev/null simply silences shellcheck) Fight me.
            cat "site/$page" /dev/null |

            # Convert all plain-text links to HTML links (<a href="X">X</a>).
            sed -E "s|([^=][^\'\"])(https[:]//[^ )]*)|\1<a href='\2'>\2</a>|g" |
            sed -E "s|^(https[:]//[^ )]{50})([^ )]*)|<a href='\0'>\1</a>|g" |

            # Insert the page into the template.
            sed -E '/%%CONTENT%%/r /dev/stdin' template.html |

            # Remove the placeholder.
            sed -E '/%%CONTENT%%/d' |

            # Insert the page path into the source URL.
            sed -E "s	%%SOURCE%%	${page##.}	" > "docs/${page%%.txt}.html"

            # Hardlink all .txt files to the docs/ directory.
            ln -f "site/$page" "docs/$page"
        ;;

        # Copy over any images or non-txt files.
        *)
            cp -f "site/$page" "docs/$page"
        ;;
    esac
done

# Ensure this never exists.
rm -rf docs/wiki/.git
