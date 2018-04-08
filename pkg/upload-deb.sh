#!/bin/sh

USERNAME=rvernica
# APIKEY=
# PASSPHRASE=


version="0.9.0-1"

names="\
gir1.2-arrow-1.0
libarrow0
libarrow-dev
libarrow-glib0
libarrow-glib-dev
libarrow-glib-doc"


for name in $names
do
    echo Package $name

    echo "1. Create"
    env NAME=$name envsubst < create.json.tmpl | \
        curl --request POST --user $USERNAME:$APIKEY \
             --header "Content-Type: application/json" \
             --data @- \
             "https://api.bintray.com/packages/$USERNAME/deb"

    if [[ $name = *"-doc" ]]
    then
        arch="all"
    else
        arch="amd64"
    fi

    echo; echo "2. Upload (Override) & Publish"
    curl --request PUT --user $USERNAME:$APIKEY \
         --header "X-GPG-PASSPHRASE: $PASSPHRASE" \
         --header "X-Bintray-Debian-Distribution: trusty" \
         --header "X-Bintray-Debian-Component: universe" \
         --header "X-Bintray-Debian-Architecture: $arch" \
         --upload-file deb/${name}_${version}_${arch}.deb \
         "https://api.bintray.com/content/$USERNAME/deb/$name/$version/${name}_${version}_${arch}.deb?publish=1&override=1"
    echo; echo
done
