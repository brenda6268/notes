# vim 中的拼写检查


wp_id: 735
Status: publish
Date: 2017-06-14 04:20:00
Modified: 2020-05-16 11:42:54


# basic usage

`:set spell` to open, `:set nospell` to disable, `:set spell!` to toggle.

`]s` and `[s` to go to next and previous spell error. `z=` to see suggestions, but it's not good. use `:nnoremap \s ea<C-X><C-S>`

Use `set spell` to check spellings in vim, if you find word marked wrongly, simple press `zg` to add it the dictionary and `zw` to remove it from the dictionary, they can be revoked with `zug` and `zuw`.
Use `]s` to go forward in the highlighted errors and `[s` to go backwards.
Use `z=` to bring up suggestions

[1] Vim cast on spell check
http://vimcasts.org/episodes/spell-checking/

```
zg       Add word under the cursor as a good word to the first
         name in "spellfile".  A count may precede the command
         to indicate the entry in "spellfile" to be used.  A
         count of two uses the second entry.

         In Visual mode the selected characters are added as a
         word (including white space!).
         When the cursor is on text that is marked as badly
         spelled then the marked text is used.
         Otherwise the word under the cursor, separated by
         non-word characters, is used.

         If the word is explicitly marked as bad word in
         another spell file the result is unpredictable.


zG       Like "zg" but add the word to the internal word list
         |internal-wordlist|.


zw       Like "zg" but mark the word as a wrong (bad) word.
         If the word already appears in "spellfile" it is
         turned into a comment line.  See |spellfile-cleanup|
         for getting rid of those.


zW       Like "zw" but add the word to the internal word list
         |internal-wordlist|.

zuw
zug      Undo |zw| and |zg|, remove the word from the entry in
         "spellfile".  Count used as with |zg|.

zuW
zuG      Undo |zW| and |zG|, remove the word from the internal
         word list.  Count used as with |zg|.
```