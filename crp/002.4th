\ rightest box
: ]l   ] postpone literal ;

v: mode ( 0 normal 1 insert )

: digs  10 /mod [ hex ] 30 + swap 30 + swap [ decimal ] emit emit ;
: col:  create , does> esc[ @ digs 'm emit ;
31 col: red 32 col: gre 33 col: ylw 34 col: blu
35 col: mag 36 col: cya 37 col: whi

\ boundaries and cursor
v: x v: y
32 c: h 64 c: w 0 value xmin 0 value ymin
: x@   x @ xmin + 1+ ;
: y@   y @ ymin + 1+ ;
: x!   w mod x ! ;
: y!   h mod y ! ;
: eob  x @ w = y @ h = and if rdrop then ;
: x+   eob x @ 1+ x! ;
: y+   y @ 1+ y! ;
: x-   x @ 1- x! ;
: y-   y @ 1- y! ;
: upd  x@ y@ at-xy ;
: uncu whi upd 'a emit ;
: curs red ." █" whi ;

\ box
: hor  w 0 do ." ━" loop ;
: top  ." ┏" hor ." ┓" ;
: top  xmin ymin at-xy top ;
: bot  ." ┗" hor ." ┛" ;
: bot  xmin h ymin + 1+ at-xy bot ;
: jmp  w spaces ;
: jmp  ." ┃" x@ w + y@ at-xy ." ┃" y+ ;
: ver  xmin swap at-xy jmp upd ;
: ver  h ymin + 1+ ymin 1+ do i ver loop ;
: box  top bot ver ;
: lbox 2 to xmin box whi ;
: rbox w 6 + to xmin box whi ;

\ normal
: .,   uncu x- upd curs ; : .l uncu x+ upd curs ;
: .j   uncu y+ upd curs ; : .k uncu y- upd curs ;
: ==   'j over = swap 'k over = swap 'l over = swap ', over = swap drop or or or ;
: ui begin key == while .l repeat ;
