#!/bin/sh
mkdir -p /tmp/word_git
cp "$1" /tmp/word_git/doc1.docx
cp "$2" /tmp/word_git/doc2.docx
osascript /usr/local/WordGit/diff.scpt