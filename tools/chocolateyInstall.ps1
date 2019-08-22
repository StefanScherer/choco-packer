$url = 'https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_windows_386.zip'
$checksum = '46d1fbb4a6e8afe65164fcbaaa08ac21bddc4a0b2f8f9ce25d6586172c0bbb41'
$checksumType = 'sha256'
$url64 = 'https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_windows_amd64.zip'
$checksum64 = '9df329285c46bb3e64462c7a6f2f0673b227466564ff1b6739d930d3aee719fe'
$checksumType64 = $checksumType
$legacyLocation = "$env:SystemDrive\HashiCorp\packer"
$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

if ([System.IO.Directory]::Exists("$env:ChocolateyInstall\lib\packer")) {
  if ([System.IO.Directory]::Exists("$env:ChocolateyInstall\lib\packer\tools")) {
    # clean old plugins and ignore files
    Write-Host "Removing old packer plugins"
    Remove-Item "$env:ChocolateyInstall\lib\packer\tools\packer-*.*"
  }
} else {
  if ([System.IO.Directory]::Exists("$env:ALLUSERSPROFILE\chocolatey\lib\packer")) {
    if ([System.IO.Directory]::Exists("$env:ALLUSERSPROFILE\chocolatey\lib\packer\tools")) {
      # clean old plugins and ignore files
      Write-Host "Removing old packer plugins"
      Remove-Item "$env:ALLUSERSPROFILE\chocolatey\lib\packer\tools" -Include "packer-*.*"
    }
  }
}

$unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyZipPackage "packer" "$url" "$unzipLocation" "$url64" `
 -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64

If (Test-Path $legacyLocation) {
  Write-Host "Removing old packer installation from $legacyLocation"
  Remove-Item $legacyLocation -Force -Recurse
}
