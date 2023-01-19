( aux )
warnings off
: cc page clearstacks ; : ]l ] postpone literal ;
: v: variable ; : 2v: 2variable ;
: c: constant ; : 2c: 2constant ;
: 0! 0 swap ! ; : 3drop 2drop drop ;
: winw form nip ; : winh form drop ;
: 00xy 0 0 at-xy ; : 01xy 0 1 at-xy ;
: bl? bl = ; : esc? dup 27 = ; : bksp? dup 127 = ;
: ++ rot + -rot + swap ; : i+ i + ;
: 1= 1 = ; : 2= 2 = ; : 2+ 2 + ; : 2- 2 - ;
: sort 2dup max -rot min ; : -sort 2dup min -rot max ;

( files -- rework )
2v: fname v: file
: fname" bl word count ; : fmake  r/w create-file ;
: fopen  r/w open-file ; : fmake drop fmake throw file ! ;
: fopen  2dup fopen 0= if file ! 2drop exit then fmake ;
: fwrite file @ write-file throw ; ( appends )
: fclose file @ close-file throw ;
: "write fopen fwrite fclose ;
: write" ( buf len "file ) fname" "write ;

( colors )
30 c: black 31 c: red     32 c: green 33 c: yellow
34 c: blue  35 c: magenta 36 c: cyan  37 c: white
: digs 10 /mod '0 + swap '0 + swap emit emit ;
: colo esc[ digs 'm emit ; : bg 10 + ;
2v: colr
: swp colr 2@ swap colr 2! ; : colr@ colr @ ;
: !remem colr@ swap colr 2! ; : colo> colr@ colo ;
: yellow! yellow colr ! ; : green! green colr ! ;
: white! white colr ! ; : red! red colr ! ;
: blubg blue bg colo ; : bnw black bg colo white colo ;
: blu blue colo ; : gre green colo ;

( boxes )
64 c: w 16 c: h w h * c: len 2v: offs
: off offs 2@ ; : iff offs 2@ 1 1 ++ offs 2! ;
: hor w 0 do ." ─" loop ;
: top off at-xy ." ┌" hor ." ┐" ;
: bot off h 1+ + at-xy ." └" hor ." ┘" ;
: ver 1+ 2dup at-xy ." │" w 0 at-deltaxy ." │" ;
: ver off h 0 do ver loop 2drop ; : box top ver bot ;
: bar 00xy blubg winw spaces 00xy .s bnw ;

( cursor )
v: buf v: ind
: lim 0 max len 1- min ; : ind! lim ind ! ;
: pos ind @ w /mod ; : cur pos off ++ ; : refr cur at-xy ;
: x+ ind @ 1+ ind! ; : x- ind @ 1- ind! ;
: y+ ind @ w + ind! ; : y- ind @ w - ind! ;
: cx pos drop ; : cy pos nip ; : buf@ buf @ len ;
: x0 ind @ cx - ; : x$ ind @ w cx - 1- + ;
: whe buf @ ind @ ; : where@ whe + ; : what where@ c@ ;
: bef whe 1- + c@ ; : aft whe 1+ + c@ ; : 2bef whe 2- + c@ ;
: beg? cx 0= ; : end? cx w 1- = ;

( syntax ) 2v: @syn
: !rem @syn @ swap @syn 2! ; : rem @syn 1 cells + @ @syn ! ;
: bef? bef bl? ; : aft? aft bl? ;
: @bl? what bl? ; : -bl? what bl <> ;
: wrd? beg? bef? or aft? and ; : what? what = wrd? and ;
: int @syn @ 0 = if yellow! rdrop then ;
: )com @bl? bef ') = and 2bef bl? and ;
: )com )com if swp rem rdrop then ;
: com @syn @ 1 = if white !remem )com rdrop then ;
: def @syn @ 2 = if red! rdrop then ;
: cmp @syn @ 4 = if green! rdrop then ;
: com? '( what? if 1 !rem rdrop then ;
: def? ': what? if 2 @syn ! rdrop then ;
: ent? @syn @ 2 = -bl? and if 3 @syn ! rdrop then ;
: cmp? @syn @ 3 = @bl? and if 4 @syn ! rdrop then ;
: int? '; what? if @syn 0! rdrop then ;
: syn? int? com? def? ent? cmp? ;
: syn syn? int com def cmp ; : syn syn colo> ;

( content -- needs improvement )
64 c: #blks len #blks * c: size v: #blk v: shad
create blocks here size bl fill size allot 
: fname s" blocks.4th" ; : >blocks ['] blocks >body ;
: blk #blk ! blocks #blk @ len * + buf ! ;
: blk% #blks mod blk ; : fsave >blocks size fname "write ;
: blk+ #blk @ 2 + blk% ; : blk- #blk @ 2 - blk% ;
: file? fname slurp-file ; : fread file? >blocks swap move ;
: run buf@ evaluate ; : run@ whe evaluate ; : nl y+ x0 ind! ;
: nl? dup 13 = over 10 = or if nl drop rdrop then ;
: put nl? syn emit x+ ; : wrt where@ c! ; : bksp? dup 127 = ;
: bksp? bksp? if x- refr bl wrt bl emit refr drop rdrop then ;
: prnt len 0 do refr buf @ i + @ put loop ;
: prnt ind 0! prnt ind 0! refr ; : bufcl buf @ len bl fill ;
: alt~ shad @ if - else + then ; : alt #blk @ 1 + alt~ blk ;
: .ld #blk @ >r 2* blk run r> blk ;
: .tru -sort 1+ swap do i .ld loop ;
s" touch blocks.4th" system    fread   0 blk

( commands )
v: 'draw : draw 'draw @ execute ; : prep 3drop page ;
: .quit 3drop page bar quit ; : @bl? what bl = ;
: .run prep run bar quit ; : .run@ prep run@ bar quit ;
: .top cx ind! ; : .bot len w - cx + ind! ;
: .beg x0 ind! ; : .end x$ ind! ; : .clr bufcl prnt ;
: .clrln where@ w cx - bl fill ind @ prnt ind! ;
: .delln .beg w 1- 0 do bl wrt bl put loop y- .beg ;
: .nex begin x+ @bl? until ; : .prv begin x- @bl? until ;
: .blk+ blk+ draw ; : .blk- blk- draw ;

( normal )
: 2next dup 2over rot cells + 2@ dup 0<> ;
: nokey 3drop 3drop rdrop ; : --- , ' , ;
: dokey rot = if execute 3drop rdrop else drop 2 + then ;
create normal 'i --- noop   'Q --- .quit
'j --- y+     'k --- y-     'l --- x+     ', --- x-
'G --- .bot   'g --- .top   '0 --- .beg   '$ --- .end
'w --- .nex   'b --- .prv   'x --- .run@  'X --- .run
'c --- .clrln 'C --- noop   'D --- .delln 'S --- fsave
'J --- .blk+  'K --- .blk-
0 , 0 , does> 0 begin 2next if dokey else nokey then again ;

( modes )
v: mode
: mode> mode @ execute ; : keys key mode> ;
: >normal ['] normal mode ! ; : esc? dup 27 = ;
: insert esc? if drop >normal else bksp? dup wrt put then ;
: >insert ['] insert mode ! ;
' >insert ' normal >body 1 cells + !

( tui )
: left 2 2 offs 2! ;
: blk. ." BLOCK " #blk @ 2/ 0 <# # #s #> type ;
: blk. blu off h + at-xy blk. bnw ;
: draw page bar left gre box iff blk. prnt ;
' draw 'draw !   >normal
: lis draw begin keys blk. bar refr again ;
lis
