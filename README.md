# FreHDDisk

## About
FreHDDisk is a solution to allow your disk-based TRS-80 Model I/III/4/4D/4P system to boot to the FreHD boot menu without modifying your TRS-80 system. It also eliminates the need to key in a BASIC program to load frehd.rom or load one from cassette every time you restart your system.  **Model 4P Users:** See the **So You Have A Model 4P** section before you go any further.

The difference between this solution and the AutoBoot disks found elsewhere is this solution does not require a separate boot disk for each OS you plan to boot; instead you only need one disk for each FreHD-connected TRS-80 system.  A single boot disk allows you to choose your OS from the FreHD's auto-boot ROM.  

If you have a floppy drive emulator, such as an HxC, simply leave the FreHDDisk image mounted and you'll automatically see FreHD's boot menu when you start your system.

## So You Have A Model 4P
The Model 4P is a unique beast.  It does not have the Model III ROMs built in; instead, it determines if they're needed and reads them from disk when needed.  To determine if the Model III ROMs are needed, the 4P boot routine looks for one of two conditions:

* A disk with a sector size less than 256 bytes.
* The bytes x'CDxx00' in the first sector of track zero, were 'xx' is any value.  This indicates a read from the Model III ROM area and triggers the 4P ROM's routine to try and find the MODELA/III file on the disk before executing the boot sector code from disk.

There are two disks for the 4P in the disk_images directory:

* m3-4p-frehd-boot.dmk - Contains MODELA/III and uses the x'CDxx00' byte sequence to coax the 4P's boot ROM into loading the file.  This is slower, but is the most compatible.  It uses Tandy's method to get the Model III ROMs in place from MODELA/III.
* alt_m4p directory - Contains an earlier version of the boot disk along with a **required** patched copy of frehd.rom.  Place this updated copy of frehd.rom on your FreHD SD card/in the network directory w/ your FreHD files (TRS-IO) and the disk image in this directory will work.  It's faster, but as it's a patch, there may be unexpected compatibilty issues.  For most use cases, this should work well. 

Further making the 4P unique is the added ability to boot from a hard disk.  This feature went unused by Radio Shack, but is used now and it complicates things.  Beaause of this feature, rebooting a 4P after having selected a hard disk image from the FreHD menu will result in a blank screen.  This is because the 4P sees the mounted hard disk image and attempts to boot it.  Model 4 hard disk images seem most likely to trigger this behavior.  To avoid this and re-run the disk routine, **hold the 2 key while you reboot your 4P**.
  
## Support
This project is technically **unsupported**.  I do try and provide best-effort support when things break, like when I broke Multi-DOS because I didn't put the correct byte sequence in the booth track.  Oh, and the the updates to make the disks play nicer with the TRS-80 Model 4P.  That said, don't expect perfection.  Fixes are not guaranteed.  Like **dload_server**, this project was done to "see if I could do it".  I've put together some disk images for other systems as a courtesy in the hopes that this would be useful for you, but this is done as a courtesy.  All of this means that I will probably lose interest and move on as soon as the next shiny object attracts my attention.  

That said, I'm happy to answer questions when I can.  I hope this is of use to anyone who does not want to physically modify their machines, but also would like to make use of the FreHD boot menu without typing in a program or loading one from cassette every time you reset your system.  If you have lots of problems, consider putting a FreHD Auto Boot ROM into your 4P.  The experience is much better than my disks.

This project is subject to the GNU Public License V3.  You're free to contribute to it or use it (provided proper attribution remains in place and the license accompanies your work).  See the LICENSE file for full details.

## How It Works
This project is derived from the BASIC program used to load and jump to frehd.rom found here:
https://github.com/apuder/TRS-IO/issues/23

FREHD/ASM contains the equivalent of the BASIC program found in the discussion link above.  It initiates a ROM transfer from the FreHD device, copies it to the RAM in your system, and jumps to the downloaded code.  If it cannot verify the presence of a FreHD device, it displays an error and halts the system.  A reset is required to break out of this state.

Assembled as a standlone file, FREHD/CMD, you can run it via LDOS 5.3.1 (I have not tested other operating systems).  Please note that I did have issues booting LDOS 5 images from FreHD after having booted to LDOS on a floppy and running FREHD/CMD.  However, on my Model 4, LSDOS 6 and CP/M did boot correctly when run from LDOS 5.3.1.


The object code of FREHD/CMD (minus the 12-byte /CMD header) can be written directly to track 0 of a floppy disk (or disk image) using a utlity such as Super Utility.  In this case, the TRS-80's standard boot ROM will load the code into the buffer location (4300H for Models III/4, 4200H for Model I) and jump to it.  

When run from the boot track of a formatted floppy disk, all opeating systems I tested (Model III LDOS, Model 4 LS-DOS, CP/M) booted correctly when chosen from the FreHD menu.  I have created boot images here for the following systems (see the **disk_images** directory):

- TRS-80 Model I
- TRS-80 Model III
- TRS-80 Model 4 NGA/4 GA/4D (GA)
- TRS-80 Model 4P

The IMAGES.txt file in the disk_images directory outlines which images work with what machines and any caveats.  I don't have a real Model I, III or 4P to test on, but I have verified the images boot to the expected "FREHD.ROM not found error" message using **trs80gp**.  Given the various GA/NGA permutations floating around when it comes to Model 4s, you may find the image that works for you isn't the one you expect.

Note that for the boot sector version to work, FreHDDisk must be kept **under 256 bytes** for complete loading by the boot ROM.

This program uses a self-contained text display routine to allow portability (and account for the fact that the 4P does not have on-board BASIC ROMS, therefore Level II/Model III ROM calls wouldn't work without some gyrations).

## Building FreHDDisk
Step-by-step instructions for setting up your build environment or configuring your emulator are beyond the scope of this project.  Please see the eumlator and assembler documentation for assistance there.  

### Recommended Software
I built FreHDDisk using an emulator and tested on a real Model 4.  This is the software I used to complete this project.  I do not have a link to Super Utility (I'm not sure of the copyright status of it).  I built FreHDDisk on LDOS 5.3.1 in Model III Mode.  You can build this on real TRS-80 hardware as well.  A FreHD makes building on real hardware very easy!

**LDOS 5.3.1** can be found here:
https://www.tim-mann.org/misosys.html

You can download the **trs80gp** emulator here:
http://48k.ca/trs80gp.html

You can build FreHDDisk using the **EDAS** assembler:
https://www.tim-mann.org/misosys.html

You can find **TRSTools**, for working with TRS-80 Disk images, here:
http://www.trs-80emulators.com/trstools/

Please note I'm not the author for any of the above tools; these links are a courtesy.  Please contact the authors of the above if you have any issues setting them up.

### Assembling FreHDDisk
Once you've set your emulator up and have EDAS up and running, copy FREHD/ASM to one of your emulated disks, perform the following steps:

1. There are /ASM files for each supported TRS-80 Model (MODELx/ASM, where x is 1, 3, 4, or 4P).
  - Edits are no longer necessary. 
2. Assemble MODELx/ASM (Saving the output into FREHD/PRN in case any errors occur).
  - MAS MODEL4/ASM +L=FREHD/PRN +O=FREHD/CMD
3. You should find FREHD/CMD (most likely on drive 0 if you didn't override it).  I recommend putting it on a system disk so you can test it.

Once you've got a working FREHD/CMD, you have three choices:

1. **Manual method** - Run it manually from your LDOS boot disk.
2. **LDOS auto boot disk method** - Create an LDOS boot disk for your system with FREHD/CMD on it, disable the date and time prompts, SYSTEM SYSGEN it, and set the AUTO function to run FREHD/CMD on boot up.
3. **Boot track method** - Write the bytes from FreHD/CMD, less the /CMD header, to the first logical sector of track 0 on a blank, formatted disk using Super Utility or another utility.  The scope of this is beyond this document.  

## Considerations

### System/build-specific
 - Model I uses single-density boot tracks, even on double-density systems.  
 - When you run FREHD/CMD from LDOS, and then choose to boot to Model III LDOS from the FreHD boot menu, the machine will beign to boot LDOS from FreHD and crash (either freeze or reboot) on a Model 4.  I'm not sure why this is, or whether it will happen on other systems.
 - I used the blank LDOS 5.3.1 disk image in **trs80gp** as the basis of the Model III/4/4P disk images.
 - I used a TRSDOS 2.3 blank disk in **trs80gp** as the basis of the Model I image.

### FreHD
You must set your FreHD up as though you were going to be booting from a system with a modified ROM.  This means **frehd.rom** must be present in the root of the SD card (for physical FreHD) or network share (TRS-IO).  In addition, the bootable disk images for your various operating systems (LDOS, CP/M, LS-DOS, etc.) must be present and acceptable to frehd.rom.

If you're using TRS-IO, make sure the following requirements are met for the SMB share where your frehd.rom and disk images will be:
 - Don't use a hyphen in the name of the folder or share name.
 - The folder should be top-level (that is, it should be accessible via \\servername\sharename).

### Disk Format
One thing I learned in this project is that TRS-80 disk images have a standard for the first few sectors of a diskette, which indicate the location of the directory.  My original disks were just my assembled code dumped to the first six sectors of track zero, and as such violated this.  Some operating systems are more tolerant of this violation than others; the ones I tested seemed OK.  That said, some operating systems don't react well (as expected) when they encouter a disk where the directory info isn't there.  

So, if you run into this issue in your OS, the solution is simple:
 - Eject my FreHD boot disk, then retry your disk I/O.  The images have been updated to address this, but if you still have issues...ejecting the disk is your workaround.

You can re-insert it when you need it again.

## Wishlist
My wishlist, if I were to persue it, might look like this:

- Not crash when running FREHD/CMD from Model III LDOS and choosing Model III LDOS from the FreHD boot menu. (I've since learned this happens outside of my boot disks; this may be an issue with the state of the system when booting LDOS 5.3 from FreHD from a prevoius instance of an OS.)

## Thanks
I hope this is useful for someone.  I did it because I wanted to see if I could.  It's actually the first useful anything I've written in assembly language, and my very first Z80 assembly project.  As a simple one, it made the perfect project. 

This is a hobby project.  Please keep that in mind if you reach out.  My response may be...delayed...depending on what has my attention.

A special thanks to Matt Boytim and Pete Cervasio for patch ideas/sample code, and testing!
