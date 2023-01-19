# LIS BLOCKS EDITOR

*Lis* is my attempt at a *forth* blocks editor. It is programmed in *gforth*.

The software is somewhat usable, but has its quirks and bugs.

Just call it as *gforth lis.4th*. It will create a 32K file *blocks.4th* if it doesn't exist.

The source code of the editor is provided also as a *blocks.4th* file for demonstration, although calling *gforth blocks.4th* will fail for some reason. 

Features:
1) syntax highlighting ( mostly working )
2) vim keybindings ( ,jkl gG0$ wb c$ ) 
3) runs contents of current buffer up to cursor with "x"
   or of the full buffer with X
4) show a top bar with contents of the stack after "x" or "X"
