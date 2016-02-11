"Running tests"
$ErrorActionPreference = "Stop"
$version = $env:APPVEYOR_BUILD_VERSION -replace('\.[^.\\/]+\.[^.\\/]+$')

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
if ($zip.Entries.Count -ne 43) {
  Write-Error "FAIL: Wrong count in nupkg!"
}
$zip.Dispose()

"TEST: Installation of package should work"
. choco install -y packer -source .

"TEST: Version of binary should match"
. packer version
if (-Not $(packer version).Contains("Packer v$version")) {
  Write-Error "FAIL: Wrong version of packer installed!"
}
. packer --version
if (-Not $(packer --version).Contains("$version")) {
  Write-Error "FAIL: Wrong version of packer installed!"
}

"TEST: All plugins are ignored"
$numExe = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".exe" }).Count
Write-Host "numExe $numExe"
$numIgnore = (get-childitem -path C:\programdata\chocolatey\lib\packer\tools\ | where { $_.extension -eq ".ignore" }).Count
Write-Host "numIgnore $numIgnore"
if ($numExe - 1 -ne $numIgnore) {
  Write-Error "FAIL: Wrong number of ignored plugins!"
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
