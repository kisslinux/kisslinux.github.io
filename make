#!/bin/sh -e
#
# Simple static site builder.

mk() {
    pandoc -t html5 \
           "$@" \
           --strip-comments \
           --no-highlight \
           --template \
           ../site/templates/* "../site/$page" |
           sed ':a;N;$!ba;s|>\s*<|><|g' > "${page%%.md}.html"


    printf '%s\n' "CC $page"
}

rm    -rf .www site/wiki
mkdir -p  .www
cd        .www

git clone --depth 1 https://github.com/kisslinux/wiki.wiki.git ../site/wiki

mv -f  ../site/wiki/Home.md ../site/wiki/index.md
rm -rf ../site/wiki/.git

(cd ../site; find . -type f -a -not -path '*/\.*') | while read -r page; do
    mkdir -p "${page%/*}"
    file=${page##*/}

    case $page in
        *wiki*.md)
            [ "${file%%.md}" = Home ] && title=Wiki
            [ "${file%%.md}" = Home ] || title=${file%%.md}

            mk --metadata title="$(echo "$title" | sed 's/-/ /g')"
        ;;

        *.md)
            mk
        ;;

        *)
            cp "../site/$page" "$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done

printf 'Build complete.\n'
