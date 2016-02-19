$url = 'https://releases.hashicorp.com/packer/0.9.0-rc2/packer_0.9.0-rc2_windows_386.zip'
$checksum = 'ecba6463876d55cbc9c1331b92e39ad557eae7d98a2c506ba081db393a0bddc1'
$checksumType = 'sha256'
$url64bit = 'https://releases.hashicorp.com/packer/0.9.0-rc2/packer_0.9.0-rc2_windows_amd64.zip'
$checksum64 = '59c73881097f95b13b258592fd69fccb9fb90f0aaac0d442a4cf86dba125353d'
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

# just to prepare the 0.9.0 package we use the AppVeyor artifcacts which are exe and not zip
$file = "$($unzipLocation)\packer.exe"
if ([System.IO.Directory]::Exists($unzipLocation)) {
  [System.IO.Directory]::CreateDirectory($unzipLocation)
}
Get-ChocolateyWebFile $packageName $file $url $url64bit -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64

#Install-ChocolateyZipPackage "packer" "$url" "$unzipLocation" "$url64bit" `
# -checksum $checksum -checksumType 'sha1' -checksum64 $checksum64

If (Test-Path $legacyLocation) {
  Write-Host "Removing old packer installation from $legacyLocation"
  Remove-Item $legacyLocation -Force -Recurse
}
