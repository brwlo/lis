( aux )                                                         : cc clearstacks page ;                                         : ]l postpone literal ; : ++ rot + -rot + swap ;                : v: variable ; : 2v 2variable ;                                : c: constant ; : 2c 2constant ;                                : 0! 0 swap ! ; : 3drop 2drop drop ;                            : winw form nip ; : winh form drop ;                            : 00xy 0 0 at-xy ; : 01xy 0 1 at-xy ;                           : bl? bl = ; : @bl? what bl? ; : -bl? what bl <> ;              : esc? dup 27 = ; : bksp? dup 127 = ;                           : 1= 1 = ; : 2= 2 = ; : 2+ 2 + ; : 2- 2 - ;                     : i+ i + ;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ( files -- rework )                                             2v: fname  v: file                                              : fname" bl word count ; : fmake r/w create-file ;              : fopen r/w open-file ; : fmake drop fmake throw file ! ;       : fopen 2dup fopen 0= if file ! 2drop exit then fmake ;         : fwrite file @ write-file throw ; ( appends )                  : fclose file @ close-file throw ;                              : "write fopen fwrite fclose ;                                  : write" fname" "write ; ( buf len "file )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ( colors )                                                      30 c: black  31 c: red      32 c: green   33 c: yellow          34 c: blue   35 c: magenta  36 c: cyan    37 c: white           : digs 10 /mod '0 + swap '0 + swap emit emit ;                  : colo esc[ digs 'm emit ; : bg 10 + ;                          