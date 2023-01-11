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
'b --- .prvsp
'X --- .run
does> dokey not if drop noop then -1 ;

v: mode
: >normal ['] normal mode ! ; >normal
: insert  esc? if drop >normal else dup wrt put then -1 ;
: >insert ['] insert mode ! ; ' >insert ' normal >body 1 cells + !
: mode    mode @ execute ; : keys begin key mode refr not until ;

: lis page 0xy ind 0! grph 1 screen f>buf reput keys ; : l lis ;
