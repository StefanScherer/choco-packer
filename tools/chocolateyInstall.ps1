$url = 'https://dl.bintray.com/mitchellh/packer/packer_0.8.6_windows_386.zip'
$checksum = '36d485f8368212906560174eacff193be1c76893'
$url64bit = 'https://dl.bintray.com/mitchellh/packer/packer_0.8.6_windows_amd64.zip'
$checksum64 = '05c19cc718dd84a9412d990dff309938130ec269'
$legacyLocation = "$env:SystemDrive\HashiCorp\packer"
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage "packer" "$url" "$unzipLocation" "$url64bit" `
 -checksum $checksum -checksumType 'sha1' -checksum64 $checksum64

If (Test-Path $legacyLocation) {
  Write-Host "Removing old packer installation from $legacyLocation"
  Remove-Item $legacyLocation -Force -Recurse
}
