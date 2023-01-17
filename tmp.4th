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
v: def v: colr
: .col:  create , does> @ colr ! ; magenta .col: .mag
black  .col: .bla  white .col: .whi  red  .col: .red
yellow .col: .ylw  green .col: .gre  blue .col: .blu
: .colo  colr @ colo ; : wrt whereat c! ;
: bksp?  dup 127 = if x- refr bl emit refr drop rdrop then ;

v: atdef v: atentry
: around whe 1- + c@ bl = cx 0= or whe 1+ + c@ bl = and ;
: def?   dup ': = around and if -1 atdef ! .red rdrop then ;
: entry? dup bl <> atdef @ and if -1 atentry ! rdrop then ;
: compl? dup bl = atentry @ and if atdef 0! atentry 0! .gre rdrop then ;
: semico dup bl = whe 2 - + c@ bl = and whe 1- + c@ '; = and ;
: intrp? semico if .ylw rdrop then ;
: syn    def? entry? compl? intrp? ; \ var? comm? ;

: esc?   dup 27 = ; : akey? .colo emit x+ ; : put syn bksp? akey? ;
: file?  s" touch blocks.4th" system s" blocks.4th" slurp-file ;
: f>buf  file? ['] buffers >body swap move ;
: ldblk  buf @ len evaluate bar 0 1 at-xy ;
: reput  len 0 do refr buf @ i + @ put loop ind 0! refr ;
: .top   pos drop ind ! ; : .bot len w - pos drop + ind ! ;
: .beg   ind @ cx - ind ! ; : .end ind @ w cx - 1- + ind ! ;
: .right x+ ; : .left x- ; : .down y+ ; : .up y- ;
: .del   bl wrt bl put ; : .quit page 0 1 at-xy 2drop bar quit ;
: .nexsp begin x+ what bl = until ;
: .prvsp begin x- what bl = until ;
: .run   page bar buf @ ind @ evaluate ;

: ---    , ' , ; v: digs v: cnt
: reps   cnt @ 1 min 0 do dup execute loop ;
: dokey  22 2* 0 do 2dup i cells + 2@ rot =
if execute 2drop unloop -1 exit else drop then 2 +loop drop 0 ;
create normal ( n keys * 2 cells )
'i --- noop  ( 'i --- .insert not yet defined )
'j --- .down  'k --- .up   'l --- .right  ', --- .left
'g --- .top   'G --- .bot  '0 --- .beg    '$ --- .end
'W --- .whi   'E --- .ylw  'R --- .red    'T --- .gre
'B --- .blu   'N --- .bla  'M --- .mag
'q --- .quit  'd --- .del  'S --- save    'w --- .nexsp
'b --- .prvsp 'X --- .run
does> dokey not if drop noop then -1 ;

v: mode
: >normal ['] normal mode ! ; >normal
: insert  esc? if drop >normal else dup wrt put then -1 ;
: >insert ['] insert mode ! ; ' >insert ' normal >body 1 cells + !
: mode    mode @ execute ; : keys begin key mode refr not until ;

: lis page 0xy ind 0! grph 1 screen f>buf reput keys ; : l lis ;
