Windows Vista/7 Installation Notes (64-bit)

Although our lab does not yet have much experience with Windows Vista/7, we were able to successfully install the software described above using the procedure described below (using MATLAB 7.7-R2008b):

1. Log in as a user with Administrator privileges.
2. Disable UAC (User Account Control).  An easy way to do this in Windows Vista is to: Start-Run-MSCONFIG. Select the Tools tab, scroll down to the option for "Disable UAC" and select it. Next, press the "Launch" button. You must then RESTART the system for this change to take effect.
3. Download and copy the inpoutx64.dll file to the C:\WINDOWS\SYSTEM32 directory.
4. Download the io64.mexw64, config_io.m, inp.m and outp,m files to a working directory of your choice. This directory will be added to your MATLAB path in step-6 below.
5. Start MATLAB in "Run as Administrator" mode (Right-click icon and select "Run as Administrator").
6. Add the directory containing the downloaded m-files to your MATLAB path via the File|Set Path|Add with Subfiles... menu command.
7. Run "config_io" from the MATLAB command window.  If there's no error message at this point, you've successfully installed the software.
8. Optional: If you need to re-enable UAC (User Account Control), follow the instructions in step-2 but select "Enable UAC" instead of "Disable UAC".


The following MATLAB code snippet demonstrates how to use the new I/O scripts:

% initialize access to the inpoutx64 low-level I/O driver
config_io;
% optional step: verify that the inpoutx64 driver was successfully initialized
global cogent;
if( cogent.io.status ~= 0 )
   error('inp/outp installation failed');
end
% write a value to the default LPT1 printer output port (at 0x378)
address = hex2dec('378');
byte = 99;
outp(address,byte);
% read back the value written to the printer port above
datum=inp(address);

A simple benchmark test reveals that I/O using these scripts is significantly slower than calling the io64() object directly (as demonstrated above).  Instead of being able to read a port with a latency of approximately 10 microseconds, using the inp() script yields a latency of approximately 40 microseconds. This is fast enough for most experimental psychology applications (such as scanning a button box, etc.).  Use direct calls to io64() if your application requires the shortest possible I/O latencies (e.g., updating an analog output stream).


The following MATLAB command snippet demonstrates how to use the io64() extension:

%create an instance of the io64 object
ioObj = io64;
%
% initialize the interface to the inpoutx64 system driver
status = io64(ioObj);
%
% if status = 0, you are now ready to write and read to a hardware port
% let's try sending the value=1 to the parallel printer's output port (LPT1)
address = hex2dec('378');          %standard LPT1 output port address
data_out=1;                                 %sample data value
io64(ioObj,address,data_out);   %output command
%
% now, let's read that value back into MATLAB
data_in=io64(ioObj,address);
%
% when finished with the io64 object it can be discarded via
% 'clear all', 'clear mex', 'clear io64' or 'clear functions' command.