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
	cmd = <PATH TO WORDGIT>/diff.js \"$LOCAL\" \"$REMOTE\"
  [mergetool "Word"]
	cmd = <PATH TO WORDGIT>/merge.js \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
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
3. On your first run, Word may prompt you to open some files so that Word can
   access them through its sandbox. Do as it says.
4. A new Word doc should open with the changes on both branches added as
   tracked changes. Merge any differences.
5. Click the Done button. (On your first run, you may get another sandbox
   prompt.)
6. Merge any other files and commit your merge as normal.

FAQ
---

### Will it run on Windows?

No, this is implemented using Apple's scripting support. However, you may be
able to use [TortoiseGit's Windows implementation][tgit] of the same feature.

[tgit]: https://github.com/TortoiseGit/TortoiseGit/tree/master/contrib/diff-scripts

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

### Merge

Similar to diff. There's some closing and reopening because for some reason
Word doesn't merge properly if we don't.
