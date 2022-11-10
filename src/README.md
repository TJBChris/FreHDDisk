# Assembly

To assmeble FreHDDisk, simply run MAS against the MODELx/ASM file of your choice.  For example:

MAS MODELI/ASM +L=FREHD/PRN +O=FREHD/CMD

This will generate a FREHD/CMD that you can use on the Model I.  Do not assemble the other files directly; they were designed to be called from the model-specific ASM files to ensure all files are included in the correct order.