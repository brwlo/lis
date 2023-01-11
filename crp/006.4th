: 2+    1+ swap 1+ swap ;


: digs  10 /mod [ hex ] 30 + swap 30 + swap [ decimal ] emit emit ;
: col:  create , does> esc[ @ digs 'm emit ;
31 col: red 32 col: gre 33 col: ylw 34 col: blu
35 col: mag 36 col: cya 37 col: whi

64 c: w 32 c: h  v: x v: y v: xoff v: yoff

: uplim x @ 0= y @ 0 = and if rdrop then ;
: lolim x @ w = y @ h = and if rdrop then ;
: x@ x @ xoff @ + ;    : y@ y @ yoff @ + ;
: x! x @ w mod ;       : y! y @ w mod  ;
: x- uplim x @ 1- x! ; : y- y @ 1- y!  ;
: x+ lolim x @ 1+ x! ; : y+ y @ 1+ y!  ;

: offs   xoff @ yoff @ ;
: loff   2 xoff ! 2 yoff ! offs ;
: roff   2 w + 2 + xoff ! 2 yoff ! offs ;
: upd    y ! x ! x @ y @ at-xy ;
: hor    w 0 do ." ━" loop ;
: top    2dup upd ." ┏" hor ." ┓" ;
: ver    x @ y @ 1+ upd ." ┃" w spaces ." ┃" ;
: ver    2dup upd h 0 do ver loop ;
: bot    h + upd ." ┗" hor ." ┛" ;

: 00xy   0 0 upd ;
: lbox   loff top ver bot 00xy ;
: rbox   roff top ver bot 00xy ;
: boxes  lbox rbox ;
: golbox loff 2+ upd ;
: gorbox roff 2+ upd ;

loff 2drop
: x@ x @ xoff @ + ;   : y@ y @ yoff @ + ; : atxy x@ y@ at-xy ;
: x! w mod x ! ;      : y! h mod y ! ;
: x+ x @ 1+ x! atxy ; : y+ y @ 1+ y! atxy ;
: x- x @ 1- x! atxy ; : y- y @ 1- y! atxy ;
