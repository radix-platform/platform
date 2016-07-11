
All packages for target root file system are built using $(TARGET_DEST_DIR)
temporary file system which contains the mirror of whole target system
including all header files and libs for development purposes.

Before start building target libraries and applications we have to prepare
$(TARGET_DEST_DIR) for development.

The first libraries in the $(TARGET_DEST_DIR) mirror shoul be the GCC runtime
libraries from TOOLCHAIN. This libraries will not be installed into target
root file system. This libraries will be used only for building GNU Libc.

Target root file system will containt GCC runtime libraries which will be
built in GCC package later.
