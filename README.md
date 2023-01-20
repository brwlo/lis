# LIS BLOCKS EDITOR

*Lis* is my attempt at a *Forth* blocks editor. It is programmed in *gforth*.

It is so called in dedication to the glorious Saint Joan whose banner was speckled with the Fleur de Lis, and to That which it represents.

The software is reasonably usable, but has its quirks and bugs. There is much to improve, I know.

It is, in fact, the first complex program that I created be it in gforth or any other language.

The style of the code may be weird, but I have hope that it is not entirely illegible. The file is divided into blocks that only occasionaly reference each other. Since I like short *words*, sometimes I create two definitions of the same name and use the first inside the second. I don't use stack comments because almost all words take zero to two items on the stack and the logic is deducible. For example: the most complex word is *.normal*, which contains the keybindings. If you look carefully, all it does is juggle the char passed to it and the address to body its body (it is a *does>* word) until it finds a match.

The source code of the editor is provided also as a *blocks.4th* file for demonstration, although calling itself with *gforth blocks.4th* will fail for some reason.

Anyway, just call it as *gforth lis.4th*. It will create a 32K file *blocks.4th* if it doesn't exist.

Features:
1) syntax highlighting ( working, but sometimes you have to go in and out of the buffer to update the colors ).
2) Vim keybindings:
   - *jkl,* (i prefer *,* to *h* to move left but it can be changed easily in the source code)
   - *0$gG* to move to start or end of line, top or bottom of block.
   - *fF* to go to the next or previous character (e.g. *f:* goes to next *:*).
   - *;:* to repeat the action of *f* or *F*
   - *bw* to skip one word to left or right
3) *xX* runs contents of current buffer up to cursor or all of it as well as the stack on top.
4) a count up to 4 digits for repeating actions (e.g. *3j* to go 3 lines down).
