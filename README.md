# packer

[![Latest version released](https://img.shields.io/chocolatey/v/packer.svg)](https://chocolatey.org/packages/packer)
[![Package downloads count](https://img.shields.io/chocolatey/dt/packer.svg)](https://chocolatey.org/packages/packer)

Chocolatey package for packer.

## Useful tips for maintain this package

With chocolatey package 0.8.0 I have changed the install location of packer to integrate it better into the Chocolatey directory structure. This improves the chocolatey experience. Right after installing the package, `packer.exe` is in your PATH.

This is done by the `ShimGen` feature which is some kind of symlink into the package directory. But for packer only one redirect is needed, only for the main `packer.exe`.
Chocolatey creates these symlinks for all exefiles found in the ZIP file. To suppress these symlinks I have added for all but `packer.exe` ignore files `packer-xyz.exe.ignore` into the `tools` directory.

This list of ignore files should be checked for each new packer release. 

1. Download new packer ZIP
2. List all files in the ZIP
3. create *.exe.ignore files for all files in the new packer.zip
