__How to get DC compiler to work:__

- SSH into: linux.engr.ucsb.edu
- Create new folder "HW5_DC"
- put counter.v into folder
- put updated .synopsis_DC.setup into folder
- run "dc_shell"


__What i did after DC compiler worked:__
```
dc_shell> read_file [name of counter file]
//stuff
dc_shell> link
//stuff
dc_shell> compile
//stuff
dc_shell> write -hierarchy -format verilog -output [make a name up for output file]
//1
dc_shell> report_area

//Report stuff you should screenshot (AREA REPORT)
```



__Then:__
- Take gate level output file
- take all of class.v and put in gate level output file
- Create a miter w/ gate level and counter
- make a testbench to test miter

Note: Miter will never always be zero because there is a delay in one of the files.




__Turnin:__
- Counter code + testbench
- Counter waveform
- Gate level output file
- Area report
- Waveform of miter? (Waveform of gate-level simulation/verification)
