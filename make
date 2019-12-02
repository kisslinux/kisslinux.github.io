#!/bin/sh -e
#
# Simple static site builder.

# Convert the markdown page to HTML and insert it
# into the template. Also bring in the CSS and minify
# the HTML.
mk() {
    pandoc -t html5 \
           "$@" \
           --strip-comments \
           --no-highlight \
           --template=../site/templates/default.html \
           -H ../site/templates/default.css.min \
           "../site/$page" |
           sed ':a;N;$!ba;s|>\s*<|><|g' > "${page%%.md}.html"

    printf '%s\n' "CC $page"
}

# Delete the generated website.
rm    -rf .www site/wiki
mkdir -p  .www
cd        .www

# Minify the CSS using sed.
sed ':a;N;$!ba;s/\n//g;s/: /:/g;s/ {  /{/g;s/;  /;/g;s/;}/}/g' \
    ../site/templates/default.css > ../site/templates/default.css.min

# Pull down the latest Wiki.
[ "$USER" = goldie ] || {
    git clone --depth 1 \
        https://github.com/kisslinux/wiki.wiki.git ../site/wiki

    mv -f  ../site/wiki/Home.md ../site/wiki/index.md
    rm -rf ../site/wiki/.git
} ||:

# Iterate over each file in the source tree under /site/.
(cd ../site; find . -type f \
        -a -not -path '*/\.*' \
        -a -not -path './templates/*') |

while read -r page; do
    mkdir -p "${page%/*}"
    file=${page##*/}

    case $page in
        # Handle Wiki pages differently. They are pulled from GitHub so
        # we need to modify them a little to fit into the KISS website.
        *wiki*.md)
            [ "${file%%.md}" = index ] && { title=Wiki; wiki=; }
            [ "${file%%.md}" = index ] || { title=${file%%.md}; wiki=1; }

            sed -i'' 's|https://github.com/kisslinux/wiki/|/|g' "../site/$page"

            mk --metadata title="$(echo "$title" | sed 's/-/ /g')" \
               --metadata wiki="$wiki" \
               --from markdown-markdown_in_html_blocks-raw_html
        ;;

        *.md) mk ;;

        # Copy over any images or non-markdown files.
        *)
            cp "../site/$page" "$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done

printf 'Build complete.\n'
