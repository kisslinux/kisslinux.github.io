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

repo() {
    # This function clones the desired repository and
    # generates an easily parseable file for use in the
    # /packages page.
    git clone "https://github.com/kisslinux/$1"

    (cd "$1"; for file in */*/version; do
        read -r version _ < "$file"
        read -r source  _ < "${file%/*}/sources"

        [ -z "${source##*://*}" ] || source=null

        if [ "$1" = repo ]; then
            author="Dylan Araps	dylan.araps@gmail.com"
        else
            author=$(git log -1 --format="tformat:%an	%ae" "$file")
        fi

        printf '%s\t%s\t%s\t%s\n' \
            "${file%/*}" "$version" "$source" "$author"
    done) >> packages/db.tsv

    rm -rf "$1"
}

# Delete the generated website.
rm    -rf .www site/wiki
mkdir -p  .www/packages
cd        .www

[ "$USER" = goldie ] || {
    # Pull down the latest Wiki. {
    git clone --depth 1 \
        https://github.com/kisslinux/wiki.wiki.git ../site/wiki

    mv -f  ../site/wiki/Home.md ../site/wiki/index.md
    rm -rf ../site/wiki/.git

    # Generate maintainer lists.
    repo repo
    repo community
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

        # Handle the packages list differently. It requires some generation
        # to turn the database file into HTML.
        *packages/index.md*)
            mk

            {
cat <<EOF
<br><table style="width:80ch">
<tr>
<th style='float:left'><b>Package</b></th>
<th style='text-align:left'><b>Version</b></th>
<th style='text-align:right'><b>Maintainer</b></th>
</tr>
EOF

                sort packages/db.tsv |

                while IFS='	' read -r pkg ver _ aut ema || [ "$pkg" ]; do
                    [ "${pkg%/*}" = community ] && repo=community || repo=repo

cat <<EOF
<tr>
<td><a href=https://github.com/kisslinux/$repo/tree/master/$pkg>$pkg</a></td>
<td>$(echo "$ver" | cut -c 1-10)</td>
<td style='text-align:right'><a href='mailto:$ema'>$aut</a></td>
</tr>
EOF
                done

                printf '</table>'
            } |

            sed -i '/%%PKG%%/r /dev/stdin'\
                packages/index.html

            sed -i "s/%%DATE%%/$(date)/;s/%%PKG%%//" \
                packages/index.html

            sort packages/db.tsv > packages.txt
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
