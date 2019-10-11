#!/bin/sh -e
#
# Simple static site builder.

rm    -rf .www
mkdir -p  .www
cd        .www

(cd ../site; find . -type f | sed ss.ss) | while read -r page; do
    mkdir -p ".${page%/*}"

    case $page in
        *.md)
            pandoc -t html5 \
                   --strip-comments \
                   --no-highlight \
                   --template \
                   ../site/templates/* "../site/$page" |
                   sed ':a;N;$!ba;s/>\s*</></g' > ".${page%%.md}.html"

            printf '%s\n' "CC $page"
        ;;

        *)
            cp "../site$page" ".$page"

            printf '%s\n' "CP $page"
        ;;
    esac
done

cd ..
mv .www site

printf 'Build complete.\n'
