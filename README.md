# FreHDDisk

## About
FreHDDisk is a solution to allow your disk-based TRS-80 Model I/III/4/4D/4P system to boot to the FreHD boot menu without modifying your TRS-80 system. It also eliminates the need to key in a BASIC program to load frehd.rom or load one from cassette every time you restart your system. 

The difference between this solution and the AutoBoot disks found elsewhere is this solution does not require a separate boot disk for each OS you plan to boot; instead you only need one disk for each FreHD-connected TRS-80 system.  A single boot disk allows you to choose your OS from the FreHD's auto-boot ROM.  

If you have a floppy drive emulator, such as an HxC, simply leave the FreHDDisk image mounted and you'll automatically see FreHD's boot menu when you start your system.
  
## Support
This project is **unsupported**.  Like **dload_server**, this project was done to "see if I could do it".  I've put together some disk images for other systems in the hopes that this would be useful for you, but this is done as a courtesy.  All of this means that I will probably lose interest and move on as soon as the next shiny object attracts my attention.  That said, I'm happy to answer questions when I can.  I hope this is of use to anyone who does not want to physically modify their machines, but also would like to make use of the FreHD boot menu without typing in a program or loading one from cassette every time you reset your system.

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

1. By default, FREHD/ASM is configured for a Model 4 loading at 4300H.  If this doesn't work for your system, tailor FreHD for your system using the SAID editor:
  - Set the **ORG** address to 4300H for Models III/4, or 4200H for Model I.
  - For Model 4P, comment out the line to clear the screen, put the START label on the next instruction.
  - Find the **MODEL** EQUate and set it as follows:
    - 1 - Model I (see considerations below if you plan to create a boot disk)
    - 3 - Model III
    - 4 - Model 4 NGA, Model 4 GA, and Model 4D
    - 5 - Model 4P 
  - Save the file and quit SAID
2. Assemble FREHD/ASM (Saving the output into FREHD/PRN in case any errors occur).
  - MAS FREHD/ASM +L=FREHD/PRN
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

## Wishlist
My wishlist, if I were to persue it, might look like this:

- Auto-detect the TRS-80 Model FreHDDisk is running on and set MODEL accordingly.
- I'm not sure of the capabilities of the assembler, but the ability to "parameterize" the ORG address based on a passed-in parameter would be neat.
- Not crash when running FREHD/CMD from Model III LDOS and choosing Model III LDOS from the FreHD boot menu.

## Thanks
I hope this is useful for someone.  I did it because I wanted to see if I could.  It's actually the first useful anything I've written in assembly language, and my very first Z80 assembly project.  As a simple one, it made the perfect project. 

This is a hobby project.  Please keep that in mind if you reach out.  My response may be...delayed...depending on what has my attention.
