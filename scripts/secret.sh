#! /bin/sh 
set -eu
set -o pipefail

PWD=`dirname $0`
SECRET_PATH=$PWD/../TransNotion

set +e
cp -i $SECRET_PATH/Secret.swift.sample $SECRET_PATH/Secret.swift
set -e

printf 'Start to replace from NOTION_OAUTH_CLIENT_ID, NOTION_OAUTH_REDIRECT_URI\n'

sed -i '' -e "s;NOTION_OAUTH_CLIENT_ID;$NOTION_OAUTH_CLIENT_ID;" $SECRET_PATH/Secret.swift
sed -i '' -e "s;NOTION_OAUTH_REDIRECT_URI;$NOTION_OAUTH_REDIRECT_URI;" $SECRET_PATH/Secret.swift

printf 'Done to replace from NOTION_OAUTH_CLIENT_ID, NOTION_OAUTH_REDIRECT_URI\n'
