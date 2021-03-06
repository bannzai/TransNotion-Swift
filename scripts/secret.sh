#! /bin/sh 
set -eu
set -o pipefail

SECRET_FILE_PATH=`dirname $0`/../TransNotion
cd $SECRET_FILE_PATH

echo $(pwd -P)

cp -i Secret.swift.sample Secret.swift

echo 'Start to replace from NOTION_OAUTH_CLIENT_ID, NOTION_OAUTH_REDIRECT_URI, NOTION_OAUTH_CALLBACK_CUSTOM_URL_SCHEME, NOTION_OAUTH_CLIENT_SECRET'

sed -i '' -e "s;NOTION_OAUTH_CLIENT_ID;$NOTION_OAUTH_CLIENT_ID;" Secret.swift
sed -i '' -e "s;NOTION_OAUTH_REDIRECT_URI;$NOTION_OAUTH_REDIRECT_URI;" Secret.swift
sed -i '' -e "s;NOTION_OAUTH_CALLBACK_CUSTOM_URL_SCHEME;$NOTION_OAUTH_CALLBACK_CUSTOM_URL_SCHEME;" Secret.swift
sed -i '' -e "s;NOTION_OAUTH_CLIENT_SECRET;$NOTION_OAUTH_CLIENT_SECRET;" Secret.swift

echo 'Done to replace from NOTION_OAUTH_CLIENT_ID, NOTION_OAUTH_REDIRECT_URI, NOTION_OAUTH_CALLBACK_CUSTOM_URL_SCHEME, NOTION_OAUTH_CLIENT_SECRET'
