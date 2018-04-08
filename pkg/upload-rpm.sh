#!/bin/sh

USERNAME=rvernica
# APIKEY=
# PASSPHRASE=


version="0.9.0-1"

names="\
arrow-debuginfo
arrow-devel
arrow-libs
arrow-python-devel
arrow-python-libs"

dir="../cpp-linux/yum/repositories/centos/6/x86_64/Packages"


for name in $names
do
    echo Package $name

    echo "1. Create"
    env NAME=$name envsubst < create.json.tmpl | \
        curl --request POST --user $USERNAME:$APIKEY \
             --header "Content-Type: application/json" \
             --data @- \
             "https://api.bintray.com/packages/$USERNAME/rpm"

    echo; echo "2. Upload (Override) & Publish"
    curl --request PUT --user $USERNAME:$APIKEY \
         --header "X-GPG-PASSPHRASE: $PASSPHRASE" \
         --upload-file $dir/${name}-${version}.el6.x86_64.rpm \
         "https://api.bintray.com/content/$USERNAME/rpm/$name/$version/${name}-${version}.el6.x86_64.rpm?publish=1&override=1"
    echo; echo
done
