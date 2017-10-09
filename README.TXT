
Wildcat Community Edition revision(W6.5)

Based on DSO203 GCC v1.7 APP (Revisions and notes for previous versions below)

Developed and tested with: 
    - SYS 1.64       
    - FPGA W1.1      (Custom FPGA for HW 2.81 archived with app)
    - HW 2.81        

>>V6.2 AND UP WILL OVERWRITE THE FPGA IF LOADED ON EARLIER UNITS.  PLEASE MAKE SURE TO USE THE CORRECT VERSION FOR THE HARDWARE 

VERSIONs 6.0 and higher TO BE USED ONLY ON HARDWARE 2.81 OR HIGHER DEVICES   
ANY FUTURE UPDATES FOR PRIOR HARDWARE VERSIONS WILL BE POSTED AS 5.X
VERSIONS 6.0 AND LATER WILL BE ONLY COMPATIBLE WITH HW 2.81 DEVICES AND LATER DUE TO LARGER RAM SIZE AVAILABLE IN 
THESE.

CHANGELOG TO VERSION W6.5:

-Added high resolution FFT modes.

-Shifted ROM addressing so both slot 3 and 4 are open.


CHANGELOG TO VERSION W6.4:

-Added auto setting function.

-Added cursor display to show position values of various cursors.

-Added control to set fast auto key repeat buzzer volume.

-Increased speed of T and V cursors, and also of Y position controls.

-CSV update: added time field, limited export to size of buffer used. When used with digital channels turned off, analog 
 channels now display in actual voltage values referenced to the baseline, with oversampling data provided in an additional 
 field for each channel, rather than ADC step values. 

-Delta V/T and T1-T2 freq meter display while meters off are now part of cursor display routine and control, changed from direct 
 screen write to screen buffer write to eliminate flickering.

-Fixed duty cycle on 1Mhz PWM signal used for frequency adjustment in calibration routine, setting resulted in a very narrow width.
 Also prevents sweep/burst modes from interfering if enabled prior to calibration.

-Fixed a condition where if the buffer mode was shifted out of large mode with xpos moved past a certain point to the right in
 one of the fastest interpolated ranges and then the timebase was set to a lower speed, then shifted back again to large buffer mode, 
 xpos was not scaled correctly, causing the window to possibly "loop around" past the end of the buffer. Also fixes BUF files not
 scaling XPOS correctly when loading non IP data while in an IP mode. 

-Fixed an issue with internal file writes where if a file of a longer length overwrote a shorter file (eg: BMP's and CSV's which's length
 can vary), the internal file write function would return the end of file marker of the previous file as chaining info, potentially 
 sending writes back to overwrite the FAT. End of volume function in previous version prevented this, causing the new file to just be 
 truncated instead. Overwriting files with different lengths will now delete the previous file first, clearing all previous chaining info.


CHANGELOG TO VERSION W6.3:

-Added file delete to directory functions. Also CSV and BIN (ROM image) files will now show in list.

-Enabled digital channels to be displayed in chart mode when used in averaging mode. Digital channels are blanked out
 in chart oversampling mode as digital channel buffers are used to store OS data for the analog channels. Also fixes display
 noise in chart oversampling mode if channel D was enabled.

-Disabled Spectrograph. MAP and all serial decode modes while in chart mode, engaging these either interfered with or disabled chart.

-Enabled proper FFT function while in chart mode.

-Added internal SYS file write address monitoring for 8MB devices, a file write while the drive was full would result in the address
 "wrapping around" and overwriting the file allocation section, rendering the drive unreadable. Program will now stop file writes 
 before this happens.

-Chart mode is now saved with BUF files to engage proper type of buffer when reloading these.

-CSV file headers updated to display more information, also end of file now eliminates added nulls or data truncation, which can
 confuse some charting/spreadsheet/editing programs.

-Replaced HEX display lookup chart for decode modes with function generating these to save ROM space.


CHANGELOG TO VERSION W6.2:

-Added directory list display to load files, also ability to name files before saving.

-Fixed inability for FFT to update from buffer when in hold mode in the slower timebases. Also allows proper FFT 
 initiation and control while viewing a BUF file.

-Fixed T1 - T2 delta time/frequency display while in chart mode, did not work right with oversampling mode added
 in last update. Also, delta time shows in minutes if greater than 120 seconds. Frequency is blanked out if delta
 time is greater than 120 seconds (8.3 millihertz)  

-Eliminated the delay at the end of auto reset used in persistence mode. Delay was set to 20mS x number of frames 
 displayed before reset, with a max of 50 or 1 second. Allows faster display refresh.

-Changed positioning of byte indicator display in SPI decode so it will not be influenced by calibration factors.

-Changed "IMG" type file save (actually a .BIN file) to "ROM" to better clarify it's purpose.


CHANGELOG TO VERSION W6.1:

-Updated chart mode with oversampling to fix improper ADC operation at very slow timebases.

-Added selection of either averaging or oversampling to chart mode controls.

-Fixed long buffer mode not initiating when recalled from a config if device was in full speed buffer mode,
 instead would go to non OS single window buffer mode. A subsequent load of the config could then engage long
 buffer mode.

-Changed detector mode frequency display so that it is no longer dependent on freq meters. Display will be enabled
 if trigger source is on either chA or B if proper waveform is displayed within cursors on that channel while 
 in cursor restrict meter mode, regardless of whether freq meters are engaged or not. User manual has been updated
 on how to use DET frequency display.


CHANGELOG TO VERSION W6.0:

-Increased RAM allocation from 48K to 64K and call stack from 8K to 16K. Fixes a variety of potential problems 
 such as loss of meter functions or triggering issues after config file saves. 

-Fixed an issue where the program would crash if loading a saved configuration file with a full speed 
 sampling setting while in one of any of the OS modes if the saved configuration contained a long buffer 
 mode XPOS value greater than a certain value. XPOS was improperly initialized on loading config, leading 
 to array overflows. 

-Fixed shifting ChA/B DC offset levels after engaging FFT or other functions while in full speed buffer mode, 
 possibly leading to corrupted calibration data if saved. Increased OsFFTdata and RMSdata array sizes to take 
 account of increased size demand when engaging FFT with XPOS shifted towards left of screen, causing 
 overflowing into configuration data arrays.

-Fixed Vmin, Vmax, and P-P meters not properly resetting at end of frames and keeping their max/min values 
 while in 500uS timebase if FFT is engaged or GEN set to one of the 2 fastest sweep/burst modes, subsequently 
 resetting on re-triggering event or setting changes. 


LATER W5.x VERSIONS COMPILED FOR OLDER VERSIONS ONLY


CHANGELOG TO VERSION W5.1:

 -Added full speed buffer mode when used with Ver W1.1 FPGA on Hardware V2.81 devices

 -Added horizontal trace thickness control.

 -Added interlace mode reset: system sets this, now mode is reset to separate, was causing analog
  trace offset between channels at fastest timebases when used with some ADC versions 

 -Fixed UART generator function when attempting to send a non existing file, generator would send whatever
  happened to be in the buffer anyways, using the number of bytes from previous transmission.

 -Fixed BMP, BUF and CSV files prematurely incrementing number values while saving.

 -Trigger delay function is now disabled in oversampling modes.

 -Added frequency display as alternative to delta time for Time cursors. Highlight T cursor display as 
  sub menu item (T1 > T2 > Display), toggle between time or corresponding frequency with left toggle.

 -Increased RAM access from 48KB to 64KB and stack size from 8KB to 16KB as a test for compatibility of
  earlier processor with latest one but Reverted back to 48K/8K, earlier processors while having increased ROM
  from specs still only appear to have 48K RAM. This may eventually necessitate 2 different versions
  as program size increases with added functions only available with the later hardware.  


CHANGELOG TO VERSION W5.0:

 -Detection of revised FPGA: Program will not shift to alternate time based mode when triggering 
  in level or edge mode at fastest timebases with new FPGA, improves triggering resolution.

 -Added option to select freerun in AUTO trig mode (only available with revised FPGA).

 -Fixed pixels left behind in meter section after loading BMP'S with meters on.

 -Fixed jitter stabilization not working at fastest timebases if either channel A or B was in invert mode. 

 -Fixed BUF file loads not scaling time base right if loaded while in time bases > 5uS/div.

 -Added button 6 center press (right toggle) to view previous BMP/BUF files after loading file 
  with center press button 5 (left toggle, which also selects next BMP/BUF).

 -Fixed UAR file load not stopping transmission at end of file on 8MB devices when using generator 
  UART function.

 -Moved the "File already exists" notification off the screen so it does not get saved along with the
  display in BMP save mode.

 -Increased hysteresis of battery level compensation to minimize frequency of shifting DC offsets 
  from varying loads on battery.

 -Fixed screen update after "scope disabled" notification while in XY mode with wave generator on. 



CHANGELOG TO VERSION W4.5:

 -Added version detection to properly implement the "2 least significant swapped bit issue" of 
  earlier FPGA versions.

 -Fixed initial calibration failing if device is in oversampling mode.

 -Added overwrite file warnings when saving BMP, CSV and BUF file formats.

 -BMP and BUF load functions now auto increment file numbers.

 -BMP load can now display next file with just one push of center button 5.

 -Fixed 16 color BMP load not covering entire screen on 8MB drive devices.

 -Added function to save entire ROM to an image file to restore a disabled device to it's 
  original state via JTAG header if ever necessary.

 -Extended Chart mode time base up to 100mS/div.

 -Added option to auto save incrementing BUF or CSV files at end of each acquired buffer in 
  full buffer chart mode. Provides continuous recording of long periods of data.

 -Disabled TH, TL, %duty and period time meters while in chart mode.

 -Fixed T cursor delta time display while in chart mode, now works up to 1000 seconds. 


CHANGELOG TO VERSION W4.4:

 -Added averaging and  oversampling buffer modes and related code to integrate with other functions

 -Changed the RAW/NORMAL control for persistence mode (center press left toggle) to work only when
  menu is ON PERS rather than all the time with any menu (preventing trig source selection to work)

 -Changed the SPEC > SPEC-ENVELOPE > ENVELOPE control (center press right toggle) to work only when
  menu is on SPEC rather than all the time with any menu (preventing buffer selection to work) 

 -Updated BUF file save/load to function properly with chart mode.

 -Fixed incorrect Y position of .DAT files displayed with chD file rec function

 -Disabled XPOS in TrOFF mode UNLESS in large buffer chart mode.(XPOS was not doing anything useful)

 -Eliminated buffer reset in TrOFF and CHART and TrOFF modes when changing timebases, prevents previous 
  buffer contents from displaying, enabling disturbance free TB changes.

 -Provided proper initiation of chart mode when booting up, recalling config, coming out of standby
  and loading saved BUF file.

 -Added bright adj for fast vert lines, select backlight menu, press left toggle center. Brightness
  of >5 pix vert row is adjustable from dim (default) or 0, to 3 or bright. Fixes brightness 
  "flickering specks" effect on some screens (others need to be looked at from an angle to notice).
  Visible with certain waveforms, EG: 6 sine waves filling screen at ~3/4 full scale amplitude. 
  Save setting by saving boot config (cfg file #0).

 -Added reset for auto trigger when trig update is called.

 -Various minor menu bug fixes.


CHANGELOG TO VERSION W4.3:

 -Added UART serial code to generator functions, along with .UAR file load function.

 -Updated UART DECODE so it can be used with the fastest timbases (2uS and faster)

 -Fixed an issue when shifting XPOS with UART decode while paused in the slower timebases
and the program auto-synchronizing on a continuous data stream where the decoded data would
blank out if the XPOS control toggle was held, and not reapear until it was released.
 

CHANGELOG TO VERSION W4.2:

 -Added chart mode.

 -In file write routine for .DAT format: changed read loop from <399 to <397 to prevent
out of bounds array access for TrackBuff[].

 -Compiled seperate version with speed optimizations, resides in first 3 slots with rest of code 
at 0x4C000.
 

CHANGELOG TO VERSION W4.1:

 -Added i2C and SPI decode functions.

 -Fixed an issue where a saved menu item was advanced when saving config files with button 3
and using button 5 to confirm. Restored menu item was incorrectly advanced, rather than the
file number menu item.

 -Fixed a problem with serial decoding under some conditions intermittently triggering in the 
500uS time base while in large buffer mode.

 -In serial decoding, fixed DataBuf array being accessed out of bounds if T1 cursor and Xpos 
are all the way left to 0 in manual start mode. Does not seem to cause any issues but has the
potential to.

 -This version only available in 3 slot version, not enough room in ROM to compile with speed 
optimisations to fit within 4 slots.  


CHANGELOG TO VERSION W4.0:

 -NOTE: this version now utilizes 3 memory "slots".

 -Added sweep, burst, white noise, arbitrary and pulse generator functions.

 -Extended analog generator frequencies to 200Khz. 

 -Added "detector" mode.

 -Added "GEN" trigger mode.
 
 -Added RS232/TTL decoding function.

 -Numerous internal changes so program works properly with added functions. 

 -FFT "window" now shifts along with XPOS in large buffer mode rather than just reading beginning of buffer.

 -Added visual indicator (display brightness flashes) to beep indicating the start of long button press:
helps in noisy environments when rather faint beeper can't be heard.

 -Included an otherwise identical in function higher performance 4 "slot" version.
  


CHANGELOG TO VERSION W3.4:

 -Fixed triggering issue in SINGLE mode in 2mS, 1mS and 500uS timebases (& possibly others) where the device
would trigger twice if data captured would exceed length of the buffer, making it impossible to see the start of the
captured waveform.

  -Fixed triggering issue after changing from AUTO to NORMAL modes at 500uS timebases and slower, where the
device would have to trigger one or more times before displaying a waveform.

  -Fixed a bug where meter readings were inaccurate or could change while in NORMAL mode with display frozen with
the latest waveform while not triggered, also causing subsequently triggered readings to be incorrect until
a sufficient number of samples were collected.

  -Modifications to level and edge triggering in the two fastest sweep ranges, improves signal acquisition for random/slow/
intermittent signals. Some devices that have shown varying abilities in this respect should improve with this.

  -Fixed save 16 color BMP function to improve display screenshot quality. Parts of the display overlapping 
the background grid were improperly copied.

  -Fixed a (likely rare) issue where push button contact "bounce" could cause a saved configuration to apparently
loose the ability to select menus upon loading it, caused by the menu focus being on meter select while meters 
are off. This could happen if a saved config had the menu focus on meters and button 3, which is also used to
toggle meters on/off bounced while being used to save the config, simultaneously shutting meters off.      


CHANGELOG TO VERSION W3.3:

-Added LOG amplitude scaling option to FFT display. Use left toggle in Ch D menu in notification
area: LOG>AUTO>0db>+6db>....>+42db

-Changed FFT buffers to 32 bit. Allows proper dynamic range so LOG display works properly, gain is
increased to +42db (+48 with log scale). Changed windowing from Hamming to Hann for better
compatibility with the increased dynamic range.

-Updated internal generator output to produce high quality waveforms using up to 720 sample points
 (gradually reducing at the highest frequencies to remain within DAC capabilities: 5khz range 
 samples @ 360, 10khz @ 180 and 20khz @ 72)

-Added continuously variable frequency control for generator output: While in OUTPUT menu and freq
 range item blinking, press  left toggle center button to access frequency display in notification 
 area. Output frequency can be finely adjusted up or down with left toggle. Eg: if set to 100hz range, 
 frequency can be shifted from 50Hz to 200hz in steps of approx +/- 0.7% (0.7Hz). Note that at the 
 higher frequency ranges, highest frequency available will be limited and range step size increased 
 due to internal DAC sampling rate and clock divider limitations. 

-Added beeps to the beginning of long press and hold functions for push buttons.

-Added frequency scaling and seconds ticks to spectrograph display.

-Program will now only save BMP screenshots in 64K colors if spectrograph or map mode is 
 displayed, otherwise will save in 16 color mode so files are not unnecessarily large. Either
 type will load for viewing.

-Changed voltmeters from reading 0.XXX KV to XXX V when reading over 100 volts on X10 ranges

-Added ability to shift the ADC operating "window" to compensate for hardware issues. While the ADC
 provides 256 "steps" (8 bits), only 200 are used for the display. The original programs used steps
 0 to 200, discarding the top 56 at the top of the screen. Unfortunately, there is quite a bit of
 non-linearity (compression) in the bottom 50 or so steps, causing distortion of the waveform. In 
 order to compensate for this, the operating point was shifted up by 54 steps, moving the entire
 range into a more linear area. In addition to minimizing the distortion at the bottom, this also
 helped the calibration procedure achieve better results, as it assumes linear ADC operation.
 However there have been instances where the preamp failed to fully swing the signal to the top
 of the ADC range, resulting in visible clipping below the top to the screen. This control can be 
 used if desired to bring the operation point down below the point where clipping occurs, albeit
 at the expense of engaging down more into the non-linear area at the bottom of the range.
 Change ADCoffset within a range of 0 to 54 by holding button 2 (as if to enter the calibration
 routine) WHILE NOT in either chA or chB menu or one of their sub-menus. Then save settings in 
 config#0 in the normal way.

-Fixed %Duty meter item (was not working at all in V3.2)

-Fixed a bug where, if not triggered in normal modes, certain items on the display would not
be updated or would show incorrectly when changing settings until the device triggered again.

-More code compacting to keep program within 2 program slots + misc minor bug fixes.



CHANGELOG TO VERSION W3.2:

-Added support for 8Mb devices, integrated bobtidey's code. (Untested at this time)

-Added persistence mode: With oscilloscope trace, provides display more like an analog scope on
continuously changing waveforms by storing trace history over time. With FFT works as peak hold.
In XY mode, improves graphics of stationary patterns. Reset with any button, or freeze,then reset
with HOLD. OR While in Tbase/Mode menu, change menu item (button 4), selection will show number
of frames to "persist" in notification area before automatically resetting. Change with left
toggle. Select "cont" towards the left to disable auto resetting. Provides very fast frame rates 
(up to >100 FPS in scope mode depending on signal and timebase). While in PERST mode, press left 
toggle center button (normally trigger source shortcut) to toggle RAW or NORMAL trace. Raw mode 
only displays data points, with no interpolation. Provides clearer display when many traces are 
close together. Note: Display will not scroll with XPOS and verniers will not update positions 
while in HOLD in persistence mode, must be in RUN mode.

-Changed spectrograph mode to properly display at slow time bases > 500uS/div. D ch input
selection now shows only SPEC: Change input channel by switching ChA/ChB ON/OFF (ChA overrides ChB
if both are on). Also modified code so timing integrity (speed of update with triggered signal
vs not triggered) is maintained when using single frame buffer. Allows meaningful displays of
intermittent signals such as speech.

-Added switchable amplitude envelope display with spectrograph. Use center press button 6 (normally
buffer size control) to select spec, spec + envelope or envelope.                    

-Added 30db additional selectable input gain in 6db steps to all FFT based functions. Allows 
readings on low level signals. With any FFT based mode engaged and ch D menu selected, press
menu item select (button 4). Menu will show input gain control in notification area rather than
Y position, change with left toggle. Move all the way left to select AUTO or to the right to select
a fixed value. Note that in persistence mode, if FFT gain is set to AUTO, db scale will not show, 
since trace levels will be displayed from various scales.

-Added "MAP" function. Displays changing waveform amplitude rather than frequency spectrum over
time (similar to Chip's "video" mode) Use ChA/ChB ON/OFF to change input channel. Note that Y
position will affect color of background, as this is part of the signal.

-Updated XY mode. Now uses buffer variable from 256 to 4096 samples. While in XY mode, Mode/Tbase
menu will change item to samples display in notification area, instead of Xpos. Change size with
left toggle. Use smaller buffer size to speed up frame rate for moving patterns, larger to improve
graphics. Larger buffer allows a faster time base to be used, further improving graphics. Graphics
quality can also be set with timebase, then buffer can be increased to complete waveform. Best results
are typically obtained when buffer is just large enough to hold one complete waveform. With
stationary patterns, while in XY mode, press center left toggle (normally trigger source shortcut)
to toggle persistence mode: can greatly improves stationary graphics, depending on buffer and
timebase settings.

-Changed BMP export function to save in 64K color format. Necessary for proper definition of fine
detail in spectrograph and map modes (requires Alterbios for older SYS versions or BMP files may get
corrupted). 

-Added the ability to load saved 64K color BMP screenshot files for viewing.

-Eliminated vernier marks at left side of screen from overwriting spectrograph display when
auto trigger changed their position.

-Shifted FFT summing mode engagement 2 more bins to the left, now provides proper displays at extreme
left of screen. Also FFT "peak" frequency display and indicator are turned off when meters are off.

-Changed FPS meter code to show 3 digits.

-Changed BUF file save/load to saving/restoring time base settings rather than generator output menu.     

-Various routine optimizations, refinements, minor bug fixes and code compacting to allow program to
still fit within 2 slots without giving up any functionality.




CHANGELOG TO VERSION W3.1:

-Fixed color background for FFT values being used from out of bounds array index, producing faint
blue background (or possibly something else if recompiled) instead of black. Also changed FFT
frequencies display to green to match channel D color (provides better visibility than red).

-Fixed inadequate buffer size being used under some conditions when using spectrograph function.

-Fixed a bug where meter readings of one channel would show up on another channel if it was turned
off and FFT turned on.

-Changed triggering selection logic to better integrate with FFT when not displaying trace. 
When all channels are off, triggering will be set to FFT displayed channel. Also, trigger selection
shortcut will acknowledge FFT channels, if on, when switching trigger source, rather than channel D.

-Changed V/div shortcut: now if selection is already on V/div, will toggle channel on/off, rather than
going to other analog channel's V/div and turning that one on, if off. Also if FFT is on with all
channels off, shortcut will go to the FFT's channel V/div but will not turn it on (long press again 
to toggle channel trace on/off if desired). 

-Added V2 cursor = db in FFT mode, V2 cursor position added at top of screen. Helps calculate db 
readings, particularly near bottom of screen.

-Changed graphics of FFT freq displays so peak trace can be clearly seen through them, providing 
better visibility at top of screen.

-Changed most often called for background graphics refresh source from ROM constants to run time 
loaded RAM arrays. Provides significant increase in frame refresh rate (specially in single frame 
buffer mode) and reduction of ROM size allows program to still fit within 2 "slots" in spite of 
increased size/complexity.

-Start/Stop will now pause spectrograph.

-Eliminated needless simultaneous drawing of hidden trace graphics while in spectrograph mode 
(speeds up refresh).

-FFT summing mode now engages a bin earlier at the extreme left in the spectrum.



CHANGELOG TO VERSION W3:

-Added Pmos69's FFT and spectrograph functions:

-Added selectable Hamming window or adjacent bin summing, some amplitude compression and screen
calibration in decibels. Adjacent bin summing provides flat frequency response at the expense of
resolution restricted to every other bin. Provides flat response similar to a flat top window but
only expands bandwidth to 2 bins.

-Corrected FFT frequency values displays. Also allowed meters to show with FFT on but channel turned
off.

-Optimized code so still fits within 2 ROM "slots" (barely, beware if recompiling) - without
spilling into the 3rd.




CHANGELOG TO VERSION W2:

-Added on-screen chart showing functions of all buttons. Hold button 1 (> 1- 1/2 sec).
 Press any other button to execute it's normal function and exit chart or press button 1
 again to exit without doing anything.

                PRESS      >      []      O       ^       <o>      <o>    
                                                         <ADJ>    <MENU>  
                                                                          
                SHORT>   HOLD    AUTO   METERS  SELECT  SET TRG   BUFFER  
                         reset   TRIG   sav/ld   ITEM   CHANNEL (spec/env)         
                                       (config)                           
                                                                          
                LONG>    V/DIV   MAN    STAND   T-BASE  MTR PGE  MENU/MTR 
                         short   TRIG    BY     short     (w/mtrs on)     
                         cut                    cut     WAV CAL  STDBY TIM
                                                          (w/mtrs off)    
                                                METERS                    
                HOLD>    CHART    CAL    SAVE   CURSOR  TRIGGER    HOLD   
                                       (config) RSTRCT  HOLDOFF   MIN/MAX 

-Added "cursor defined meter" function. Hold button 4 to toggle mode. "X" symbol appears 
 in menu when mode active. When  active, all meter readings are confined between the 2 (T1-T2)
 time cursors. Move either cursor all the way right/left to disable that cursor: With T1 all 
 the way left, includes all samples from start of buffer, with T2 all the way right, includes
 all samples all the way to the end of the buffer (Move Xpos to effectively change positions
 of these cursors). Time based meters can have their trigger point moved by lowering V1 or
 raising V2. Once these cursors reach the normal half way (between top and bottom waveform
 peaks) reference point for the time meters,  V1 will drag it down or V2 will drag it up,
 allowing time measurements on selected parts of the waveform. Works in all modes whether
 in run or hold and at all  "X" positions.  Useful for example to get correct frequency
 readings on tone bursts and other parts of complex waveforms, specially in long buffer mode.
 Also moving V1 below trigger level allows V2 to take precedence and set trigger point.

-Jitter stabilization: gets rid of excessive internally generated jitter on the fastest
 time bases.

-Added alternate meters with bigger display. Change type with button 3:  >Meters off > regular
 meters > large meters. Default large meter page shows  2 meters with small globals (vol,
 backlight, battery, etc) Other pages show 3 meters with small Delta V and Delta T. Change
 page/source/item the same way you do with the regular meters. Large meters have a faster
 display refresh of 3 times/sec for all readouts except for TH, TL and %duty which have 1/sec
 timing to reduce "bobbling" and increase the number of values calculated in averaging.

-Added A&B trigger mode: ability to trigger on 2 different waveforms simultaneously on
 channels A and B. With both A and B channels on, change Trigg Source to A&B. Trig mode is
 locked in Normal Hold in this function, and C & D channels are locked out in this mode. Also
 can use trig source shortcut to enable mode if both A and B channels are turned on. Auto
 trigger and trig level will move both A and B trig levels simultaneously. To change 
 individually, change trig source with left toggle push button to select A or B and change
 trigger levels on each channel independently, then go back to A&B mode.  Note that since 
 AUTO is not available in this mode, display will be frozen (as in regular  NORM mode)
 unless a triggered signal is connected to at least one of the inputs.

-Modified meter item/source selection to show only relevant items depending on the source/
 item: When switching meter item source to digital channels for example, selection does not
 show voltage meters.

-Changed time based trigger type menu titles. For example, it seems clearer to show  "trigger
 on low pulse if longer than Delta T1- T2 cursors" as "L>Delta" rather than ">TL"... How many
 users realize that the time based trigger function pulse widths are based on the difference
 between the 2 time (T1 & T2) cursors (regardless of their position within the screen).

-Added ability to save multiple configuration settings, up to 10. Hold button 3 down. When
 saving config, file menu appears with "save config #0" as bootup default. Press button 3
 again to save as default (on boot-up) config file or change number with left toggle to
 choose a different file number. To load a config file, go to file menu: Default after boot
 up when choosing file menu will be "load config", with last saved file number flashing. Use
 left toggle to select file number if desired (0 will always be the boot-up config)and press
 center left toggle to load and stay in file menu (useful for browsing configs) or press
 button 3 to load, and go to current "flashing" menu at time of save. File menu has been
 moved to the extreme right at all times, making it easy to reach (just hold menu toggle
 right). Program will only write to existing files to prevent file corruption when using
 original system versions. Calibration data is only loaded from config #0, so calibration
 can be updated without interference from additional configs. The number of the presently
 loaded config file is shown as a digit 0-9 on the menu. See below for more info before
 using this.

-Added Trigger Holdoff function. Works in single screen buffer and Normal modes only (not
 in Auto),  up to 1Ms/div. (Inability of screen updates to keep up with data flow destroys
 timing integrity at faster timebases, making added delay meaningless)  Hold left toggle
 center button,  "T" indicator appears in buffer view area at bottom of screen in color of
 triggering channel when activated. Indicator will be greyed out in unsupported modes and
 time bases. Position of indicator shows amount of delay. Use TRIGG menu: source>type>level>
 delay to change delay time. Move left toggle left or right in steps of one major screen
 division to change delay.

-Added HOLD mode for V max and V min. Max/Min meters in this mode hold maximum/minimum
 values until reset. Function reads samples from all buffer transfers. Max and Min meter
 items will be white in this mode as an indicator. Value will show source color. "H" also
 shows on menu. Alarm function is also activated in this mode, when voltage exceeds V1
 vernier or drops below V2 vernier device sounds alert. Change source channel for alarms
 with DeltaV and left toggle. (Move verniers to extreme top/bottom to shut off alarms).
 Hold center right toggle menu selector to toggle hold mode. Reset with RUN/HOLD or by
 changing Ypos, volt range or buffer size. When using with cursor defined meters mode,
 readings and alarms are confined to between T1 and T1 cursors.

-Trigger cursor can now be moved towards the left edge of screen in single window buffer
 mode. Use "Xpos" in time base menu to move. 

-Improved accuracy, range and resolution of period/frequency meters. Frequency and Period
 meter code completely re-written using more accurate computations with more digits of
 resolution under all conditions and proper rounding off. 

-Added quantization error compensation for period and frequency meters using the analog
 channels. Provides increased resolution for most waveforms, specially at low sample counts
 such as in single frame buffer mode or using cursor defined meters. Depends on calculating
 slope while crossing trigger points so waveforms with very sharp risetimes (=1 time sample
 period for example) and waveforms very slowly crossing the trigger point will benefit less.

-Incorporated all samples captured in calculations for all meters. Meters now read average
 from all previous frames since last readout, rather than just the last frame before readout.
 Helps out particularly at the faster timebases. The slower timebases (<5mS/div) will benefit
 less from this as meter refresh rates start catching up with frame rates as the timebase is
 set to slower values and fewer or no samples are lost to begin with. 

-Added ability to automatically compensate for battery voltage/ac power supply affecting
 voltage calibration and DC offsets. Requires calibration to be done twice, once with a
 somewhat low battery charge and then again with AC adapter connected. Program with save
 the 2 sets of parameters for all ranges and will interpolate/extrapolate as necessary while
 battery voltage/power supply changes. 

-Improved resolution of voltage calibration. Calibration now provides 4 digits of display
 resolution as well as an indicator to set input reference voltage to the exact middle of
 an ADC step, providing some effort to make the best of the limited 8 bits of resolution.
 Voltage calibration now starts off from previous entries, rather than 0. This also allows
 calibrating offsets (with auto calibration) without having to also calibrate voltage ranges
 manually (move right toggle through range fields leaving whatever residual readings are
 there and previous V cal settings will remain). 

-Changed Trigger Select shortcut (Center short press left toggle). Now if only 1 or 2
 channels are turned on, simply toggles trigger source between them. If A and B channels
 are on, will also cycle through A&B trigger mode. If 3 or more channels are on, serves as
 a shortcut to TRIGG>SOURCE and doesn't change anything. Previously a channel had to have
 it's menu active (flashing) to set triggering to it by pressing this button.

-Selective updating: Eliminates waveform disturbances, particularly at the lower timebases
 (<500uS/div) while changing X pos, Y pos, trigger level, cursors and menu/item changes.
 Program will now only change functions relevant to items being adjusted, rather than
 updating everything each time a button is pushed.

-Added ability to shut off standby timer while using battery, also ability to force device
 into standby.

-Fixed incorrect values in CSV file export, did not compensate for shifted ADC values.

-Changed interpolation routine to more accurately represent the values in the buffer for
 rising and falling edges, IP routine for the fastest timebases was modifying display at
 all timebases.

-Various other minor interface changes (Colors, alignment and movement of trigger cursor,
 notifications, meter item selection) and fixes (dropped pixels, bug fixes, etc.) 

USING MULTIPLE CONFIGURATION FILES:
 To prevent file corruption when using one of the original system versions, which are known
 to corrupt saved files, the program will not write additional config files (other than the
 regular #0 boot file) unless one already exists. In order to create these, the files already
 on the drive should be first saved to a Windows machine, the drive should then be formatted,
 and then the XXXXX.WPT file copied back first to the formatted drive, then the .BAK file. 9
 copies of the WPT file should then be made and renamed CONF001.CFG through CONF009.CFG and
 copied to the device's drive before any other files are copied or created. This will ensure
 that these small files stay at the beginning of the file allocation table, where they will
 not get corrupted. Their small size requires no chaining info to be written to the FAT, so
 their entries remain small, avoiding corruption which seems to occur only further down the
 FAT.
 Additional values are stored in the config files in a way that should be compatible with
 older versions. A new config file though must be saved to hold settings for the added or
 modified functions and the calibration values.
 
CALIBRATION:
 Recalibration will be necessary. This version works a bit differently than previous versions
 so old settings probably will not be very accurate. When calibrating, try to center the
 "step center" indicator by adjusting the voltage source. This is very sensitive so a way to
 finely adjust the voltage will be necessary. If the indicator jumps around too much, there
 likely is too much noise superimposed on the calibration voltage. Look at the signal with
 the scope display, there should be a minimum of background noise. Nearby switched mode power
 supplies and the like may need to be switched off. Changing the source a bit to find another
 "step" can get rid of excessive noise, otherwise center the indicator as best as possible.
 At the beginning of the calibration routine, a compensation value (in PPM) can be entered to
 improve accuracy of the frequency and period meters. Generator output is set to 1Mhz at this
 point and if connected to a frequency counter the error can be entered and will be used to
 calibrate these meters.

 As the battery or AC adapter voltage changes, the DC offsets and voltage calibration are
 affected somewhat. This version will now allow setting 2 different sets of calibration
 tables. One can be done with a relatively low battery (say around 1/4 charge) and a second
 set with a charger connected, which brings the supply voltage to around 4.3- 4.5V. Once
 this is done the program will interpolate from the 2 and be able to correct the calibration
 as the battery voltage changes, or if an AC adapter is used.

>>> For a quick set up voltage calibration can be skipped and the calibration routine left
 to auto calibrate (twice if bat level comp is desired). Skip through voltage calibration
 fields without applying any input, leaving whatever residual values are there. Note that
 any previously calibrated voltage values picked while booting up or loading CFG file #0
 will remain. This will at least remove undesirable DC offsets on each range and prevent
 shifts of offsets as Y positions are changed.





CHANGELOG FOR REVISION W:

- Variable repeat rate for toggles, slow for menus, fast for verniers, etc.
- Main Menu will stop at left (CH-A), and at right on Time Vernier or Volume adj, will not
  "go around".
- Program will attempt to set triggering to relevant channel, if shutting off a channel with
  trigg set, will move trigger source to last selected ch. 
- Will not time out into standby if USB power plugged in.
- "SCAN" mode renamed "TrOFF". Trigger levels/vernier do not show in this mode. 
- "NorCL" (Normal-Clear) mode added (simulates regular CRT type scope, clears display if no
  trigger)
- Single shot trigg mode automatically goes into full size buffer mode.
- Digital channels meter default displays changed to show only relevant meters (no volt meters)
- 20Khz Generator output shifted to 25Khz so 72 point sampling can work without special Sys
  version.
- Trigg verniers disabled for digital channels (preset at 1/2)
- X_Y-A and X_Y-S removed, now only X_Y. Mode is triggered in AUTO mode to allow meters to
  work correctly. (Move trigg source to unused ch to disable triggering if desired).


FIXES, MODIFICATIONS AND ADDITIONS: (List of most important issues, many others not listed)

TRIGGERING:
- Re-sequencing of triggering functions to allow proper time for reset to bring up start flag
  before attempting to read FIFO, allows analog channels to trigger properly on slow/random
  signals at fastest timebases.
- Fixed a problem in the mid-range time bases where display would freeze or trigger very
  sporadically. 
- Implementation of proper triggering in single screen buffer mode.
- Integration of JackTheVendicator's single shot trigger mode.
- Various functions optimizing triggering for different timebases, triggering modes, etc.
- "SCAN" mode (now renamed "TrOFF") optimized with different routines for fast and slow time
  bases.
- Single screen buffer mode now resets immediately after right edge of screen, also is
  available at all time bases.
- Auto trigger fix to eliminate condition in some cases where device could not trigger
  because trigg level was too far away from wave and auto function could not find wave
  because device was not triggering.

CALIBRATION:
- Gain calibration now modifies signal in relation to signal zero point, rather than screen
  bottom. Prevents interfering with offset calibration and Y positioning.
- Signed variables now used to allow values at bottom of screen, which can be pushed up by
  offset calibration, and then be below zero, to be read properly.
- ADC operating point shifted away from non-linearity at the bottom of screen. Allows
  calibration routine to work more accurately.
- Fix for an error in FPGA where the 2 least significant bits of CH-B are swapped.  
- Fix for an error in saving parameters to disk where CH-B offset compensation could be
  corrupted if CH-A's value was negative. 
- Signal gain calibration now switchable ON/OFF (Screen only, does not affect meters.
  Improves wave quality by removing correction "steps", if present).

FILES:
- Fixed BMP header. Header was missing a row of digits causing improper file and image size
  to be listed.
- Added several additional parameters to be saved in "save config". (Config file still
  compatible with previous versions)

METERS:
- Values now corrected by calibration in reference to signal zero point, rather than screen
  bottom. Prevents offsets and Y positioning from affecting accuracy.
- Time measurements in process completely re-written, eliminating the inclusion of partial
  waves before triggering. While this only affected accuracy slightly in full frame buffer
  mode, it introduced major inaccuracies in single screen buffer mode where at times only
  a few waveforms are considered in the measurements.
- Frequency meter fixed so it works past ~2Mhz. This worked OK in original program, but
  had wrong suffix. Subsequent fix for improper readout caused meter to malfunction past
  around 2Mhz.
- Fixed Time and Voltage Vernier meter readouts so they display properly at very large and
  very small time/voltage settings.

GENERATOR:
- Shifting of amplitude variation from signal's zero point rather than screen bottom,
  eliminates distortion at lower levels where bottom of wave is clipped. Note that this
  results in an unchanging DC offset as level is varied... (use AC coupling to display
  properly)
- Changed division ratios so proper frequency is produced/displayed without needing a
  special SYS version (should work OK with it as well) Only issue with this is the
  innability to produce 20Khz (produces 25Khz instead) Readout shows correct value.

DISPLAY
- Improved linearity from ADC operating point shift. (Eliminates compression of wave at
  bottom of screen).
- Bit swap correction on CH-B improves trace quality.
- Elimination of noise at beginning and end of trace on some ranges.
- Alignment of Digital channels with Analogs. Note that digital channels trailing at very
  fast timebases is caused by delay introduced in Digital channel input stage. There is
  no way to fix this at the software level, needs to be fixed in hardware. This same
  input stage configuration also introduces instabilities when triggering from the
  digital CHs at fast time bases.
- Brighter screen grid (was very faint...)
- Re-aligned trigger point with trigger vernier
- Fixed "time shift" at fastest timebases when changing time/div while on hold.


PREVIOUS REVISIONS:


DSO203 GCC v1.7 APP
-------------------

Just some fixes over marcosin 1.8 version of the DSO203 APP and GCC compilation support.

(Win32 GCC support by gabonator1)


Contribute or simply enjoy.

Pedro Simões

-------------------------------------------

Access source in github:
  https://github.com/pmos69/dso203_gcc 

or get a zip with the complete tree here:
  https://github.com/pmos69/dso203_gcc/zipball/master

-------------------------------------------

Uses CodeSourcery Arm toolchain:
  https://sourcery.mentor.com/sgpp/lite/arm/portal/release1802
Just download the Windows TAR archive and unpack it somewhere, no installation is required.
Watch out for symlinks in the TAR you'll have to re-create them or copy/rename files to "fill the gaps"

-------------------------------------------

All thanks to:
- Seeed-Studio
- Marco Sinatti (marcosin)
- Gabriel Valky (gabonator1)

-------------------------------------------

v1.7
- Fixed x10 probe modes - Division scales and meter values
- Calibration accuracy fix

v1.6
- Fixed X_Y modes - now operational again
- Fixed Min, Max and Vpp readings (initialization values)

v1.5
- Re-did a complete code merge of marcosin 1.8 & fixes into 2.51 by hand. - Now compiles with -Os
- X_Y modes don't work, and mess the buffer - Reset needed to proceed after using X_Y.

v1.4
- changed compile options: "-O3" replaced by "-O0 -fno-common -fzero-initialized-in-bss"
- removed explicit initialization of the FrameMode variable

v1.3
- initialized FrameMode variable at creation
	Can now start correctly everytime. (at least on my DSO)
	If you have problems with bogus display in full-buffer mode, try saving settings and restarting.

v1.2:
- automatic chinese->english translation of all chinese comments in the source.

v1.1:
- Updated with marcosin 1.8 release

v1:
- Removed -fno-common and changes -Os to -O3 in compile options
     APP still only starts correctly 1/3 of the times
- Fixed Vdc and RMS values display when in 1-page buffer mode (menu.c)
     Calculation didn't take into account the buffer size when calculating the averages
- Fixed wrong calculations for Vdc and RMS (process.c)
     the counters (a_Avg, b_Avg, a_Ssq, b_Ssq) were initialized with a value different than 0)
	 

-------------------------------------------

Marco Sinatti (marcosin) Revisions:
	 
Versione APP251_V1.0 Richiede FPGA V2.22 - SYS1.50
-Tasto quadrato = Abilita il buffer ridotto a una schermata, disabilita lo scorrimento
-Tasto triangolo = cambio visualizzatori misure
-Corretto visualizzazione unità di misura della frequenza

Versione APP251_1.1 Richiede FPGA V2.22 - SYS1.50
-Aggiunto opzione portata x10 in modo da leggere la tensione corretta sui meter quando si utilizza la sonda x10
-Aggiunto accesso veloce ai cursoti V1 V2 T1 T2 in modo da poter andare direttamente a fare misure senza scorrere tutti i menù. Premendo il tasto si accede a V1, ripremendolo a V2, etc... dopo T2 si torna alla posizione da cui si era partiti
-Aggiunto livello trigger automatico, si setta da solo al centro della forma d'onda, il tasto è comodo anche per accedere al volo al menù trigger
-Aggiunto indicatore della batteria in carica, mentre stà caricando il riempimento della batteria scorre
-Tolto la modalità NONE sulla base dei tempi, perchè era identica a SCAN
-Modificato l'indicazione dell'impostazione a frame singolo, adesso viene evidenziata con un rettandolo sull'indicatore del buffer in basso
-Migliorata l'acquisizione a frame singolo che lavorava male in alcune portate

Versione APP251_1.3 Richiede FPGA V2.22 - SYS1.50
-Visualizzazione a schermo intero nascondendo i meter
-Durante l'uso dei cursori, se i meter sono nascosti appare comunque il DeltaT e il DeltaV
-Risolto bug sulla visualizzazione della linea che appare sui primi pixel dello schermo
-Risolto bug aggiornamento livello trigger automatico
-Nella modalità trigger automatica si può decidere di impostare in automatico il livello a 1/2 1/4 3/4 della Vpp
-Modificato visualizzazione carica batteria con scorrimento quando effettivamente è in carica
-Aumentato velocità di scorrimento dei cursori di misurazione
-Modificato modalità di riduzione del buffer, adesso quando siamo in "frame singolo" in realtà lavora così:
SCAN = cattura e visualizza un solo frame, purtroppo non è un roll vero
NON SCAN = cattura 1,6 frame, in questo modo il trigger funziona bene, si ha la possibilità di scorrere la visualizzazione
-In modalità SCAN non si hanno più deformazioni della forma d'onda al centro dello schermo
-In modalità SCAN tolgo il riferimento della XPOS perchè non serve
-Aggiunto modalità PWM e regolazione ampiezza segnale in uscita, modificando il generatore di funzioni in questo modo:
SQUARE = Onda quadra da 0Hz-20Khz con ampiezza regolabile da 0 a 2,6V
TRIANG = Onda triangolare da 0Hz-20Khz con ampiezza regolabile da 0 a 2,6V
SEW = Onda a dente di sega da 0Hz-20Khz con ampiezza regolabile da 0 a 2,6V
SINUS = Onda sinusoidale da 0Hz-20Khz con ampiezza regolabile da 0 a 2,6V
PWM = Segnale PWM con duty regolabile da 0 a 100 %, frequenza da 10Hz a 8Mhz.

Versione APP251_1.4 Richiede FPGA V2.22 - SYS1.50_1.6 
-Funzione X_Y (da terminare)
-Cambio rapido menù meter modificato, adesso con i canali C e D ad OFF quando si cambia i meter non li imposta sui canali disabilitati
-Sistemato SYS per il problema del range tensione
-Sistemato SYS sul menù calibrazione
-Rimodificato singolo frame, quando impostato non fa scorrere XPOS

Versione APP251_1.5 Richiede FPGA V2.22 - SYS1.50_1.6 
-Corretto visulizzazione DeltaV quando X10 sul canale B (prendeva sempre il canale A)

Versione APP251_1.6  Richiede FPGA V2.22 - SYS150_1.6 
-Modalità SCAN a singolo frame in vero ROLL
-Aggiunto 1-2-5Hz su generatore
-Portato frequenza massima generatore a 50Khz 
-Aumentato da 36 a 72 campionamenti la generazione delle forme d'onda

Versione APP251_1.7  Richiede FPGA V2.22 - SYS150_1.6 
-Invertito titolo generatore e tempo base
-Spostato meter duty e tensione generatore
-Implementato XY_S (scan) XY_A  (auto) da terminare
-NORMAL migliorato, non cancella lo schermo quando attende un nuovo trigger
--------------
Versione APP251_1.8  Richiede FPGA V2.22 - SYS150_1.6 
-Migliorato griglia e sistemato scala su modalità XY










