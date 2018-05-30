#!/usr/bin/env bash
set -e
mkdir -p /tmp/word_git
cp "$1" /tmp/word_git/base.docx
cp "$2" /tmp/word_git/local.docx
cp "$3" /tmp/word_git/remote.docx

open `dirname $0`/merge.docm

while [ ! -f /tmp/word_git/merged.docx ]; do sleep 1; done

mv /tmp/word_git/merged.docx "$4"