JsOsaDAS1.001.00bplist00�Vscript_�var word = Application('/Applications/Microsoft Word.app')
word.open('/tmp/word_git/doc1.docx')
word.documents['doc1.docx'].compare({path: '/tmp/word_git/doc2.docx'})
word.documents['doc1.docx'].close()                            �jscr  ��ޭ