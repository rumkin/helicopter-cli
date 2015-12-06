#!/bin/bash

set -e

error() {
  echo $1
  exit 1
}

copy() {
  if [ ! -d $1 ]
  then
    return 1
  fi

  FILES=$(ls -a $1 | egrep -v '^..?$' | awk -v prefix="$1" '{print prefix "/" $0}')
  if [ -n "$FILES" ]
  then
    cp -rp $FILES $2
  fi
}

create () {
  TPL=$1

  if [ -z "$TPL" ];
  then
    echo "Template not specified" >&2
    exit 1
  fi

  if [ $# -gt 1 ]
  then
    DIR=$2
    CUR=$(readlink -f "$DIR")
    [ ! -d $DIR ] && mkdir $DIR
  else
    CUR=$PWD
  fi

  TMP=$(mktemp -d)
  INSTALLED=false
  cd $TMP
  if [ $(echo $TPL | grep "/" | wc -l) -eq 1 ];
  then
    # Github repository
    git clone "https://github.com/$TPL" $TMP
    rm -rf .git
    copy $TMP/template $CUR
    INSTALLED=true
  else
    # Npm package
    mkdir node_modules
    npm install $TPL
    copy "$TMP/node_modules/$TPL/template" "$CUR"
    rm -rf node_modules
    INSTALLED=true
  fi
  cd $CUR
  rm -rf $TMP

  if $INSTALLED
  then
    return 0;
  else
    echo "Not installed" >&2
    return 1;
  fi
}

case $1 in
  "init")
    create helicopterjs/basic $2 || error "Not installed"
  ;;
  "create")
    create $2 $3 || error "Not installed"
  ;;
  *)
    CURRENT=($(echo $PWD | tr "/" "\n"))
    TAIL=node_modules/helicopter/bin/helicopter.js

    for (( i=${#CURRENT[@]}; i >= 0; i-- ))
    do
      DIR=""
      for (( n=0; n<=$i; n++ ))
      do
          DIR=$DIR"/${CURRENT[$n]}"
      done

      if [ -f "$DIR/$TAIL" ]
      then
        ${DIR}/${TAIL} $@ <&0
        exit
      fi
    done

    echo "Helicopter executable not found" >&2
    exit 1
  ;;
esac
