$url = 'https://releases.hashicorp.com/packer/0.9.0/packer_0.9.0_windows_386.zip'
$checksum = 'f3ea971cefc60e953d64b944fee71b4eb77606895f690a51f485c2562e36f2e9'
$checksumType = 'sha256'
$url64bit = 'https://releases.hashicorp.com/packer/0.9.0/packer_0.9.0_windows_amd64.zip'
$checksum64 = 'dbb98c5a3be92bfe5a4bca5f29d5a9159409af0f360d590953b0e806ebe2342a'
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
