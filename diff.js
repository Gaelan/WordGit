#!/usr/bin/env osascript -l JavaScript

function run(argv) {
  var app = Application.currentApplication()
  app.includeStandardAdditions = true
  app.doShellScript('mkdir -p /tmp/word_git')
  app.doShellScript('cp "' + argv[0] + '" /tmp/word_git/doc1.docx')
  app.doShellScript('cp "' + argv[1] + '" /tmp/word_git/doc2.docx')
  var word = Application('Microsoft Word')
  word.open('/tmp/word_git/doc2.docx', {addToRecentFiles: false})
  word.documents['doc2.docx'].close()
  word.open('/tmp/word_git/doc1.docx', {addToRecentFiles: false})
  word.documents['doc1.docx'].compare({path: '/tmp/word_git/doc2.docx', authorName: "Git Changes"})
  word.documents['doc1.docx'].close()
}