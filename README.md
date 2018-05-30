WordGit
=======

A tool that allows you to diff and merge Word (.docx) files with git. Currently
Mac only.

Setup
-----

1. Clone this repository somewhere.
2. Add the following to `~/.gitconfig`:
  ```
  [difftool "Word"]
	cmd = /usr/local/WordGit/diff.js \"$LOCAL\" \"$REMOTE\"
  [mergetool "Word"]
	cmd = bash <PATH TO WORDGIT>/merge.sh \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	trustexitcode = true
  ```

Usage
-----

### Diff
1. In your repository, run `git difftool -T Word` with any arguments that you
   would normally pass to `git diff`. 
2. On your first run, Word may prompt you to open some files so that Word can
   access them through its sandbox. Do as it says. (If you don't see the diff
   after doing this step, rerun the command in step 1 and it should work)
3. Your diff should open in a new document.

### Merge
1. In your repository run `git merge`, then, if there are conflicts,
   `git mergetool -T Word <path to docx file with conflicts>`.
2. Click "Enable Macros" in Word. ([Want to audit code?][audit])
3. On your first run, Word may prompt you to open some files so that Word can
   access them through its sandbox. Do as it says.
4. A new Word doc should open with the changes on both branches added as
   tracked changes. Merge any differences.
5. Close the window titled "MERGE IN PROGRESS." (On your first run, you'll
   get another sandbox prompt.)
6. Merge any other files and commit your merge as normal.

[audit]: #can-i-read-your-code-before-letting-word-run-it

FAQ
---

### Will it run on Windows?

Hypothetically, yes. The merge code should work pretty much as it is (changing
some paths), but the diff code currently uses JavaScript-as-AppleScript instead
of Visual Basic to work around some Word bugs. Maybe those bugs don't exist on
Windows?

### Can I read your code before letting Word run it?

Yes. Open `merge.docm` (wherever you cloned this repository) and tell Word to
disable macros. Then enable Word's Developer tab (in the ribbon settings) and
click the "Visual Basic" button.

How it works
------------

This whole thing is a careful dance around a bunch of Word bugs, but it seems
to work pretty well.

### Diff

`git difftool` runs `diff.js` as a shebang script, evaluated by `osascript`
(AppleScript). `diff.js` copies the diffed files to /tmp/word_git (we copy them
because Git gives us paths that Word's sandboxing workaround doesn't seem to
like). Then we open and close doc2 (Word's sandboxing workaround doesn't seem
to trigger when you open a document for diffing, but opening and closing it
first sloves that). Finally, we open doc1, run the diff, and close doc1.

Note: we can't use the same method as the merge code here, because in this case
we would want to close the helper docm file right after opening the diff, and
doing so seems to cause Word to crash when the diff is closed.

### Merge

`git difftool` runs `merge.sh`. `merge.sh` copies the files to `/tmp/word_git`
(see above), then opens the `merge.docm` file. A macro in this file starts the
merge betweeen the three files, then stays open (serving as the "MERGE IN
PROGRESS") window. Then, `merge.docm` closes, a macro saves the merge document
to `/tmp/word_git/merged.docx` and closes it. `merge.sh` detects that this file
is created, and copies it where git wants it.
