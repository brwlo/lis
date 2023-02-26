( aux ) warnings off
: cc page clearstacks ; : ]l ] postpone literal ;
: v: variable ; : 2v: 2variable ;
: c: constant ; : 2c: 2constant ;
: vl: value ; : ++ rot + -rot + swap ;
: 3drop 2drop drop ; : winw form nip ; : winh form drop ;
: 00xy 0 0 at-xy ; : 01xy 0 1 at-xy ;
: bl? bl = ; : esc? dup 27 = ; : bksp? dup 127 = ;
: i+ i + ; : 1= 1 = ; : 2= 2 = ; : 2+ 2 + ; : 2- 2 - ;
: sort 2dup max -rot min ; : -sort 2dup min -rot max ;
: not invert ; : even 2 mod 0= ; : odd 2 mod 0<> ;
: s>num s>number drop ; : +- dup even if 1+ else 1- then ;

( colors ) 2v: colr
30 c: black 31 c: red     32 c: green 33 c: yellow
34 c: blue  35 c: magenta 36 c: cyan  37 c: white
: digs 10 /mod '0 + swap '0 + swap emit emit ;
: colo esc[ digs 'm emit ; : bg 10 + ;
: colo> colr @ colo ; : swp colr 2@ swap colr 2! ;
: !remem colr @ swap colr 2! ;
: bnw black bg colo white colo ;
: yellow! yellow colr ! ; : green! green colr ! ;
: white! white colr ! ; : red! red colr ! ;
: blubg blue bg colo ; : blu blue colo ;

( boxes )
64 vl: w 16 vl: h 2v: offs
: len w h * ;
: ofs offs 2@ ; : iff offs 2@ 1 1 ++ offs 2! ;
: hor w 0 do ." ━" loop ;
: top ofs at-xy ." ┏" hor ." ┓" ;
: bot ofs h 1+ + at-xy ." ┗" hor ." ┛" ;
: ver 1+ 2dup at-xy ." ┃" w 0 at-deltaxy ." ┃" ;
: ver ofs h 0 do ver loop 2drop ;
: box top ver bot ;
: bar 00xy blubg winw spaces 00xy .s bnw ;

( cursor )
v: buf v: ind
: lim 0 max len 1- min ; : ind! lim ind ! ;
: pos ind @ w /mod ; : cur pos ofs ++ ; : refr cur at-xy ;
: x+ ind @ 1+ ind! ; : x- ind @ 1- ind! ; : cx pos drop ;
: y+ ind @ w + ind! ; : y- ind @ w - ind! ; : cy pos nip ;
: x0 ind @ cx - ; : x$ ind @ w cx - 1- + ; : buf@ buf @ len ;
: whe buf @ ind @ ; : where@ whe + ; : what where@ c@ ;
: bef whe 1- + c@ ; : aft whe 1+ + c@ ; : 2bef whe 2- + c@ ;
: bob ind @ 0= ; : eob ind @ len 1- = ; : beob bob eob or ;
: beg? cx 0= ; : end? cx w 1- = ;

( syntax ) 2v: @syn
\ TODO: provide for '[' and ']'
: !rem @syn @ swap @syn 2! ; : rem @syn 1 cells + @ @syn ! ;
: bef? bef bl? ; : aft? aft bl? ; : @bl? what bl? ;
: -bl? what bl <> ; : wrd? beg? bef? or aft? and ;
: what? what = wrd? and ;
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
: int? '; what? if @syn off rdrop then ;
: syn? int? com? def? ent? cmp? int? ;
: syn syn? int com def cmp ; : syn syn colo> ;

( files -- rework )
2v: fname v: file
: fname" bl word count ;
: fmake  r/w create-file ;
: fopen  r/w open-file ;
: fmake drop fmake throw file ! ;
: fopen  2dup fopen 0= if file ! 2drop exit then fmake ;
: fwrite file @ write-file throw ; ( appends )
: fclose file @ close-file throw ;
: "write fopen fwrite fclose ;
: write" ( buf len "file ) fname" "write ;

( blocks )
128 c: #blks len #blks * c: size v: #blk
create blocks here size bl fill size allot 
: fname s" blocks.4th" ;
: file? fname slurp-file ;
: blk #blk ! blocks #blk @ len * + buf ! ;
: >blocks ['] blocks >body ; : blk% #blks mod blk ;
: fread file? >blocks swap move ;
: fsave >blocks size fname "write ;
: blk+ #blk @ 2+ blk% ; : blk- #blk @ 2- blk% ;
: run buf@ evaluate ; : run@ whe evaluate ;
: alt #blk @ +- blk ; : shadw? #blk @ odd ;
: .ld #blk @ >r 2* blk run r> blk ;
: .tru -sort 1+ swap do i .ld loop ;
s" touch blocks.4th" system    fread   0 blk

( buffers )
: buf: create len allot ;
buf: mov buf: del buf: ynk
: >mov buf @ mov len move ;
: mov> mov buf @ len move ;
: bfswp >mov buf @ swap blk buf @ swap len move mov> ;
: bfswp #blk @ >r bfswp r> blk ;

( content -- needs improvement )
: nl y+ x0 ind! ;
: nl? dup 13 = over 10 = or if nl drop rdrop then ;
: put nl? syn emit x+ ;
: wrt where@ c! ;
: bksp? dup 127 = ;
: putbl ind @ x$ ind! bl wrt ind! refr ;
: prnt len 0 do refr buf @ i + @ put loop ;
: prnt ind off prnt ind off @syn off refr ;
: bufcl buf @ len bl fill ;
: prsrv ind @ prnt ind! refr ;
: pull where@ whe 1- + w cx - cmove putbl prsrv ;
: ibksp? bksp? if pull x- drop rdrop then ;
: rbksp? bksp? if x- refr bl wrt bl emit refr drop rdrop then ;
: push where@ whe 1+ + w cx - 1- cmove> prsrv ;

( count )
: cntbf s"     " ; v: cmd v: cnt v: #cnt
: keep cmd ! ; : 0keep ['] noop keep ;
: 0cnt 0keep cnt off #cnt off s"     " drop cntbf move ;
: cnt+ #cnt @ 1+ dup #cnt ! 4 > if 0cnt then ;
: >cnt cntbf drop #cnt @ + c! ;
: >cnt >cnt cntbf s>num cnt ! cnt+ ;
: dig? cnt @ if '0 else '1 then '9 1+ within ;
: cnt? dup dig? if >cnt rdrop then ;
: cnt. cnt @ 0 <# # # # # #> type ;

( commands )
v: lastk v: 'draw
: draw 'draw @ execute ;
: prep page bar 01xy ;
: .quit page bar 00xy quit ;
: .run prep run quit ;
: .run@ prep run@ quit ;
: .top cx ind! ;
: .bot len w - cx + ind! ;
: .beg x0 ind! ;
: .end x$ ind! ;
: .del bl put bl wrt x- ;
: .clr key 'C = if bufcl prnt then ;
: .clrln where@ w cx - bl fill ind @ prnt ind! ;
: .delln .beg where@ w bl fill ind @ prnt ind! ;
: .nex begin x+ @bl? aft bl <> and eob or until ;
: .prv begin x- @bl? aft bl <> and bob or until ;
: .blk+ blk+ draw ;
: .blk- blk- draw ;
: .alt alt draw ;
: till begin lastk @ x+ what = beob or until ;
: -till begin lastk @ x- what = beob or until ;
: .till key lastk ! till ;
: -.till key lastk ! -till ;
: .ln- .beg where@ whe w + + len ind @ - w - cmove> ;
: .ln- .ln- where@ w bl fill prsrv ; : .ln+ y+ .ln- ;
: .bfswp cnt @ 2 * bfswp 0cnt draw ;
: .shswp #blk @ +- bfswp draw ;
: .bfgo cnt @ 2* blk 0cnt draw ;
: .>mov >mov draw ; : .mov> mov> draw ;
: cpln .beg where@ ynk w move ; : .cpln cpln draw ;
: ptln .beg ynk where@ w move ; : .ptln ind @ ptln draw ind! ;
: .delln .beg where@ w + where@ len ind @ w + - move ;
: .delln .delln .bot where@ w bl fill ;
: .delln key 'D = if ind @ cpln .delln prnt ind! then ;

( normal )
: reps cnt @ 1 max 0 do cmd @ execute loop 0cnt ;
: 2next dup 2over rot cells + 2@ dup 0<> ;
: nokey 0keep 3drop 3drop rdrop ; : --- , ' , ;
: dokey rot = if keep 3drop rdrop else drop 2 + then ;
create .normal 'i --- noop   'r --- noop   'Q --- .quit
'j --- y+      'k --- y-     'l --- x+     ', --- x-
'G --- .bot    'g --- .top   '0 --- .beg   '$ --- .end
'w --- .nex    'b --- .prv   'x --- .run@  'X --- .run
'c --- .clrln  'C --- .clr   'd --- .del   'D --- .delln
'J --- .blk+   'K --- .blk-  'f --- .till  'F --- -.till
'; --- till    ': --- -till  'a --- .alt   'S --- fsave
'o --- .ln+    'O --- .ln-   't --- .shswp 'T --- .bfswp
'Y --- .>mov   'P --- .mov>  'y --- .cpln  'p --- .ptln
'B --- .bfgo
0 , 0 , does> 0 begin 2next if dokey else nokey then again ;
: nrml cnt? .normal reps ;

( modes )
v: mode
: mode> mode @ execute ; : keys key mode> ;
: >nrml ['] nrml mode ! ;
: nrml? esc? if drop >nrml rdrop then ;
: ins nrml? ibksp? push dup wrt put ;
: rep nrml? rbksp? dup wrt put ;
: >ins ['] ins mode ! ; : >rep ['] rep mode ! ;
' >ins ' .normal >body 1 cells + !
' >rep ' .normal >body 3 cells + !

( tui )
: bxcol shadw? if yellow else green then colo ;
: alt. shadw? if blu ofs 1- at-xy ." SHADOW" then ;
: left 2 2 offs 2! ;
: prt# 0 <# # # #> type ;
: cur. blu ofs w 6 - -1 ++ at-xy cx prt# bl emit cy prt# ;
: cnt. blu ofs w 5 - h ++ at-xy cnt. bnw ;
: blk. ." BLOCK " #blk @ 2/ 0 <# # #s #> type ;
: blk. blu ofs h + at-xy blk. bnw ;
: draw page bar left bxcol box iff blk. cnt. alt. prnt ;
' draw 'draw !   >nrml
: empty s" ---marker--- marker ---marker---" evaluate ;
: lis draw begin keys blk. cur. cnt. bar refr again ;
marker ---marker---   lis
