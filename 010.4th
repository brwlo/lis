\ boxes
ulib" write.4th ulib" slurp.4th

30 c: black 31 c: red 32 c: green 33 c: yellow
34 c: blue 35 c: magenta 36 c: cyan 37 c: white
: digs 10 /mod 48 + swap 48 + swap emit emit ; : bg 10 + ;
: colo esc[ digs 'm emit ; : 0col black bg colo white colo ;
: 0xy  0 0 at-xy ; : ln2 0 1 at-xy ;
: winw form nip ; : winh form drop ;
: blu  blue bg colo ; : whi  white bg colo black colo ;
: bar  0xy blu winw spaces 0xy .s 0col ;
: cmd  ln2 whi winw spaces ln2 ." :" 2 1 at-xy ;

64 c: w 16 c: h w h * c: len 2v: offs
: off  offs 2@ ; : >bot off 2 + h + offs 2! ;
: iff  offs 2@ 1+ swap 1+ swap offs 2! ;
: left 6 2 offs 2! ; : right 78 2 offs 2! ;
: blef left >bot ; : brig right >bot ;
: hor  w 0 do ." ━" loop ; : top off at-xy ." ┏" hor ." ┓" ;
: bot  off h 1+ + at-xy ." ┗" hor ." ┛" ;
: ver  2dup swap w + 1+ swap at-xy ." ┃" ; ( use at-deltaxy? )
: ver  1+ 2dup at-xy ." ┃" ver ;
: ver  off h 0 do ver loop 2drop ; : box top ver bot ;
: lbox left box ; : rbox right box ;
: blbx blef box ; : brbx brig box ;
: boxs white colo lbox rbox blbx brbx 0col ;
: boxs 0xy lbox rbox blbx brbx 0col ;

v: buf len 32 * c: size
: buf: create len allot ; buf: del buf: save
create buffers here size bl fill size allot
 does> swap 1- len * + buf ! ;
create screen ' left , ' right , ' blef , ' brig ,
 does> swap dup buffers 1- 0 max 3 min cells + @ execute iff ;
create scrns len 4 * allot does> swap len * + ;
: save ['] buffers >body size s" blocks.4th" "write ;

v: ind
: off+ off rot + -rot + swap ; : lims 0 max len 1- min ;
: pos  ind @ lims w /mod ; : cur pos off+ ; : refr cur at-xy ;
: x+   ind @ 1+ lims ind ! ; : y+ ind @ w + lims ind ! ;
: x-   ind @ 1- lims ind ! ; : y- ind @ w - lims ind ! ;
: cx   pos drop ; : cy pos nip ;
: whe  buf @ ind @ ; : whereat whe + ; : what whereat c@ ;

: grph bar boxs 0xy ;
