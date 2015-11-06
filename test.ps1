"Running tests"
$ErrorActionPreference = "Stop"
$version = $env:APPVEYOR_BUILD_VERSION -replace('\.[^.\\/]+$')

"TEST: Version $version in packer.nuspec file should match"
[xml]$spec = Get-Content packer.nuspec
if ($spec.package.metadata.version.CompareTo($version)) {
  Write-Error "FAIL: rong version in nuspec file!"
}

"TEST: Package should contain only install script"
Add-Type -assembly "system.io.compression.filesystem"
$zip = [IO.Compression.ZipFile]::OpenRead("$pwd\packer.$version.nupkg")
if ($zip.Entries.Count -ne 5) {
  Write-Error "FAIL: Wrong count in nupkg!"
}
$zip.Dispose()

"TEST: Installation of package should work"
. choco install -y packer -source .

"TEST: Version of binary should match"
. packer --version
if (-Not $(packer --version).Contains("packer v$version")) {
  Write-Error "FAIL: Wrong version of packer installed!"
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
