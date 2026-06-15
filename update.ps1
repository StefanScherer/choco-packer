[CmdletBinding()]
param(
  [string]$Version
)

$ErrorActionPreference = 'Stop'

Import-Module au -Force

function global:au_GetLatest {
  $versionPattern = '^/packer/\d+\.\d+\.\d+/$'

  if ($Version) {
    $latestVersion = $Version
  } else {
    $indexUrl = 'https://releases.hashicorp.com/packer/'
    $links = (Invoke-WebRequest -Uri $indexUrl).Links.href

    $stableVersions = $links |
      Where-Object { $_ -match $versionPattern } |
      ForEach-Object { $_.Trim('/') -replace '^packer/', '' } |
      Sort-Object { [version]$_ } -Descending

    if (-not $stableVersions) {
      throw "Could not determine latest stable Packer version from $indexUrl"
    }

    $latestVersion = $stableVersions[0]
  }

  $shaUrl = "https://releases.hashicorp.com/packer/$latestVersion/packer_${latestVersion}_SHA256SUMS"
  $checksumEntries = (Invoke-WebRequest -Uri $shaUrl).Content -split "`n"

  $file32 = "packer_${latestVersion}_windows_386.zip"
  $file64 = "packer_${latestVersion}_windows_amd64.zip"

  $line32 = $checksumEntries | Where-Object { $_ -match [regex]::Escape($file32) } | Select-Object -First 1
  $line64 = $checksumEntries | Where-Object { $_ -match [regex]::Escape($file64) } | Select-Object -First 1

  $checksum32 = if ($line32) { ($line32 -split '\s+')[0] } else { $null }
  $checksum64 = if ($line64) { ($line64 -split '\s+')[0] } else { $null }

  if (-not $checksum32) {
    throw "Missing checksum for $file32 in $shaUrl"
  }

  if (-not $checksum64) {
    throw "Missing checksum for $file64 in $shaUrl"
  }

  return @{
    Version = $latestVersion
    URL32 = "https://releases.hashicorp.com/packer/$latestVersion/$file32"
    URL64 = "https://releases.hashicorp.com/packer/$latestVersion/$file64"
    Checksum32 = $checksum32
    Checksum64 = $checksum64
  }
}

function global:au_SearchReplace {
  return @{
    '.\packer.nuspec' = @{
      '(?s)(<version>)(.*?)(</version>)' = "`${1}$($Latest.Version)`${3}"
    }
    '.\tools\chocolateyInstall.ps1' = @{
      "(?m)^\$url\s*=\s*'.*'" = "`$url = '$($Latest.URL32)'"
      "(?m)^\$checksum\s*=\s*'.*'" = "`$checksum = '$($Latest.Checksum32)'"
      "(?m)^\$url64\s*=\s*'.*'" = "`$url64 = '$($Latest.URL64)'"
      "(?m)^\$checksum64\s*=\s*'.*'" = "`$checksum64 = '$($Latest.Checksum64)'"
    }
  }
}

Update-Package -NoReadme
