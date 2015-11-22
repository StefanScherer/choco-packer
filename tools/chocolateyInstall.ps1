#$url = 'https://releases.hashicorp.com/packer/0.9.0/packer_0.9.0_windows_386.zip'
$url = 'https://ci.appveyor.com/api/buildjobs/m1b10t5f4owlicn5/artifacts/pkg/windows_386/packer.exe'
$checksum = 'a16a29b7c08f23b761cb026204c8063bee8c8fe0'
$checksumType = 'sha1'
#$url64bit = 'https://releases.hashicorp.com/packer/0.9.0/packer_0.9.0_windows_amd64.zip'
$url64bit = 'https://ci.appveyor.com/api/buildjobs/on5cuiw8spjh2gx6/artifacts/pkg/windows_amd64/packer.exe'
$checksum64 = '2034EC8058175E47BE9B8E709E03B088A9A7F6A7'
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
