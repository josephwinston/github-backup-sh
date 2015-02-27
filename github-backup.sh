#!/bin/sh

#
# Simple shell script to backup all GitHub repos
# Usage: github-backup.sh <username>
# @author Petr Trofimov <petrofimov@yandex.ru>
#

set -ex

USER="$1"
API_URL="https://api.github.com/users/${USER}/repos"
DATE=$(date +"%Y%m%d")
TEMP_DIR="github_${USER}_${DATE}"
BACKUP_FILE="${TEMP_DIR}.tgz"

#
# Find out how many pages we have
#

PAGES=`curl -s -I "${API_URL}"|grep "Link:"|cut -f4 -d' '|cut -f2 -d'&'|cut -f2 -d'='|cut -f1 -d'>'`
if [ -z "${PAGES}"]; then
    PAGES=1
fi

mkdir "${TEMP_DIR}" 
cd "${TEMP_DIR}"

count=1
while [ $count -le ${PAGES} ]
do
    curl -s "${API_URL}?page=${count}" | grep git_url |cut -d \" -f4 | awk '{print $1}' | xargs -n 1 git clone
    count=`expr ${count} + 1`
done

cd -
# tar zcf "$BACKUP_FILE" "$TEMP_DIR"
# rm -rf "$TEMP_DIR"


