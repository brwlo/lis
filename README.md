# LIS BLOCKS EDITOR

*Lis* is my attempt at a *Forth* blocks editor. It is programmed in *gforth*.

It is so called in dedication to the glorious Saint Joan whose banner was speckled with the Fleur de Lis, and to That which it represents. 

The program is reasonably usable, but has its quirks and bugs. In particular, it doesn't attempt to use *gforth*'s blocks utilities and it has no notion of *assigned-dirty* or *assigned-clean* buffers for now.

It is, in fact, the first complex program that I created be it in *gforth* or any other language.

The style of the code may be weird, but I have hope that it is not entirely illegible. The file is divided into blocks that only occasionaly reference each other. Since I like short *words*, sometimes I create two definitions of the same name and use the first inside the second. I don't use stack comments because almost all words take zero to two items on the stack and the logic is deducible. For example: the most complex word is *.normal*, which contains the keybindings for the normal mode. If you look carefully, all it does is juggle the char passed to it and the address to body its body (it is a *does>* word) until it finds a match.

The original text file edited in Vim is now out-of-date and renamed to *lis.old*. The proper usage is to include the blocks file *lis.4th*. If a *blocks.4th* file doesn't exist in the current directory, an empty one will be created with 64KB.

Features:
1) syntax highlighting ( working, but sometimes you have to go in and out of the buffer to update the colors ).
2) Vim modes (normal, replace, insert) and keybindings.
3) A count up to 4 digits for repeating actions (e.g. *3j* to go 3 lines down).

Normal mode keys:

key | command
--- | ---
j  | up                    
k  | down                  
,  | left                  
l  | right                 
g  | top                
G  | bottom             
0  | start of line      
$  | end of line        
w  | next word
b  | previous word
o  | new line below
O  | new line above
y  | yank line             
Y  | yank block
p  | put yanked line       
P  | put yanked block
c  | delete to end of line
CC | reset block        
d  | delete               
DD | delete line
f  | find <char>           
;  | repeat find <char> 
F  | find <char> backwards 
:  | repeat find <char> backwards
/  | search for a string
n  | search for next string
N  | search for previous string
a  | toggle shadow block
A  | toggle alternate block
B  | goto <count>th block
J  | next block            
K  | previous block
t  | swap with shadow block 
T  | swap contents of alternate blocks
Q  | quit to forth         
S  | save all buffers   
