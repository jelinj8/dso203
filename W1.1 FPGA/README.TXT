FPGA version W1.1:
Revised FPGA for HARDWARE VERSION 2.81 and later devices ONLY.
>NOT compatible with previous HW versions

Compatible with all SYS and program versions.
Instal by first copying the FPGA_281.ADR file to DFU virtual disk.
When volume reappears, copy 281_FPGA.BIN to DFU virtual disk.

Based on an earlier published version (V2.50)


CHANGELOG TO VERSION FPGA  W1.1:

 -Added oversampling mode support, access by sending a >0 OS_Size to
  Set_ 0x0F and 0x10 addresses as lo/hi word bytes. Compatible with
  previous programs with OS_Size=0.

 -Moved triggering buffer to the RAM module and included data transfer
  to go through buffer as well.

 -Increased time trigger variable from 16 to 32 bits to work properly with
  oversampling mode. 2 most significant added bytes transfered with Set_ 0x11 
  and 0x12. Value sent needs to be multiplied by OS_Size+1. 

 -Removed unused set_ sampling depth and delay to improve timing performance.
  Any calls made to these will simply be disregarded. To my knowledge no
  program uses these.   


CHANGELOG TO VERSION FPGA  W1:
 -Added triggering data buffer so that calculations can be made from a 
  stable source rather than on the fly which requires critical timing,
  possibly resulting in read/write collisions and corruption of triggering 
  data at the fastest timebases.

 -Extended time triggering accumulators from 12 bits to 32 bits, allows 
  detection of much longer time intervals for proper triggering functions
  under these conditions. 

 -Added freerun mode for more coherent waveform displays while untriggered
  in AUTO mode at the faster timebases.
 
 -Eliminated unused meter data accumulators. To my knowledge no program 
  uses these, but rather performs the calculations externally. 

 -Added ID string access so programs can indentify new version. 