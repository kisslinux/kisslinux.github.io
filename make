#!/bin/sh -e
#
# Simple static site builder.

# Convert the markdown page to HTML and insert it
# into the template.
mk() {
    pandoc -f markdown-smart -t html5 \
           "$@" \
           --strip-comments \
           --no-highlight \
           --template=../site/templates/default.html \
           "../site/$page" |
           sed ':a;N;$!ba;s|>\s*<|><|g' > "${page%%.md}.html"

    printf '%s\n' "CC $page"
}

# Delete the generated website.
rm    -rf .www site/wiki
mkdir -p  .www
cd        .www

# Pull down the latest Wiki.
[ "$USER" = goldie ] || {
    git clone --depth 1 \
        https://github.com/kisslinux/wiki.wiki.git ../site/wiki

    mv -f  ../site/wiki/Home.md ../site/wiki/index.md
    rm -rf ../site/wiki/.git
} ||:

# Generate maintainer lists.
[ "$USER" = goldie ] || {
    git clone https://github.com/kisslinux/repo
    git clone https://github.com/kisslinux/community

    for file in repo/*/*/version; do
        printf '%s\tDylan Araps\tdylan.araps@gmail.com\n' "${file%/*}"
    done > authors

    for file in community/*/*/version; do
        author=$(git log -1 --format="tformat:%an	%ae" "$file")

        printf '%s\t%s\n' "${file%/*}" "$author"
    done >> authors
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
