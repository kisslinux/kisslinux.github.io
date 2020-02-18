#!/bin/sh -e
#
# Simple static site builder.

# Convert the markdown page to HTML and insert it
# into the template.
mk() {
    sed "s|\([^=][^\'\"]\)\(https[:]//[^ \)]*\)|\1<a href=\"\2\">\2</a>|g" \
        "../site/$page" |

    sed "s|^\(https[:]//[^ \)]\{50\}\)\([^ \)]*\)|<a href=\"\0\">\1</a>|g" |

    sed '/%%CONTENT%%/r /dev/stdin' \
        ../site/templates/default.html |

    sed '/%%CONTENT%%/d' > "${page%%.txt}.html"

    cp -f "../site/$page" "$page"

    printf '%s\n' "CC $page"
}

# Delete the generated website.
rm    -rf .www
mkdir -p  .www
cd        .www

# Iterate over each file in the source tree under /site/.
(cd ../site; find . -type f \
        -a -not -path '*/\.*' \
        -a -not -path './templates/*') |

while read -r page; do
    mkdir -p "${page%/*}"

    case $page in
        *.txt) mk ;;

        # Copy over any images or non-markdown files.
        *)
            cp "../site/$page" "$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done

cd ..
git add .www
git commit -m "docs: update" ||:
git subtree push -P .www origin gh-pages
