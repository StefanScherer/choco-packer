
"Running tests"
$ErrorActionPreference = "Stop"

if ($env:APPVEYOR_BUILD_VERSION) {
  # run in CI
  $version = $env:APPVEYOR_BUILD_VERSION -replace('\.[^.\\/]+$')
} else {
  # run manually
  [xml]$spec = Get-Content packer.nuspec
  $version = $spec.package.metadata.version
}

"TEST: Version $version in packer.nuspec file should match"
[xml]$spec = Get-Content packer.nuspec
if ($spec.package.metadata.version.CompareTo($version)) {
  Write-Error "FAIL: rong version in nuspec file!"
}

"TEST: Package should contain only install script"
Add-Type -assembly "system.io.compression.filesystem"
$zip = [IO.Compression.ZipFile]::OpenRead("$pwd\packer.$version.nupkg")
# Write-Host $zip.Entries.FullName
Write-Host $zip.Entries.Count
if ($zip.Entries.Count -ne 5) {
  Write-Error "FAIL: Wrong count in nupkg!"
}
$zip.Dispose()

"TEST: Installation of package should work"
. choco install -y packer $options -source . -version $version

"TEST: Version of binary should match"
$v = $(packer version)
$v
if (-Not $v.Contains("Packer v$version")) {
  Write-Error "FAIL: Wrong version of packer installed!"
}
$v = $(packer --version)
$v
if (-Not $v.Contains("$version")) {
  Write-Error "FAIL: Wrong version of packer installed!"
}

"TEST: All plugins are ignored"
. ls C:\programdata\chocolatey\lib\packer
. ls C:\programdata\chocolatey\lib\packer\tools
$numExe = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".exe" }).Count
Write-Host "numExe $numExe"
$numIgnore = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".ignore" }).Count
Write-Host "numIgnore $numIgnore"
if ($numExe - 1 -ne $numIgnore) {
  Write-Error "FAIL: Wrong number of ignored plugins!"
}
if ($numIgnore -ne 0) {
  Write-Error "FAIL: There mustn't be any ignored plugins!"
}

"TEST: Uninstall show remove the binary"
. choco uninstall packer
try {
  . packer
  Write-Error "FAIL: packer binary still found"
} catch {
  Write-Host "PASS: packer not found"
}

"TEST: Uninstall should not leave files on disk"
if (Test-Path C:\programdata\chocolatey\lib\packer) {
  Write-Error "FAIL: Package directory C:\programdata\chocolatey\lib\packer mustn't exist!"
}

"TEST: Update from older version to single binary version works"
. choco install -y packer $options -version 0.8.6.20160211
. choco install -y packer $options -source . -version $version
. ls C:\programdata\chocolatey\lib\packer
. ls C:\programdata\chocolatey\lib\packer\tools
$numExe = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".exe" }).Count
Write-Host "numExe $numExe"
$numIgnore = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".ignore" }).Count
Write-Host "numIgnore $numIgnore"
if ($numExe - 1 -ne $numIgnore) {
  Write-Error "FAIL: Wrong number of ignored plugins!"
}
if ($numExe -ne 1) {
  Write-Error "FAIL: There mustn't be more than one exe file!"
}
if ($numIgnore -ne 0) {
  Write-Error "FAIL: There mustn't be any ignored plugins!"
}

"TEST: Uninstall show remove the binary"
. choco uninstall packer
try {
  . packer
  Write-Error "FAIL: packer binary still found"
} catch {
  Write-Host "PASS: packer not found"
}

"TEST: Finished"
