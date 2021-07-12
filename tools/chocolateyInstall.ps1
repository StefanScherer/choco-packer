$url = 'https://releases.hashicorp.com/packer/1.7.3/packer_1.7.3_windows_386.zip'
$checksum = '41a6e37843d1e447d6c12c2f3182687c1bd8c3f417a4d86fc78cc45f1261f70e'
$checksumType = 'sha256'
$url64 = 'https://releases.hashicorp.com/packer/1.7.3/packer_1.7.3_windows_amd64.zip'
$checksum64 = 'fc49ccacd1e6b06397c04b5b788306711f62d24e4532911318db19eaa006cbb9'
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
