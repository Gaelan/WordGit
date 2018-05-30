#!/bin/sh
open -a "Microsoft Word"
mkdir -p /tmp/word_git
cp "$1" /tmp/word_git/doc1.docx
cp "$2" /tmp/word_git/doc2.docx
osascript `dirname $0`/diff.scpt