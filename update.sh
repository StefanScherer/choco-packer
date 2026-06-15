#!/bin/bash
set -euo pipefail

if ! command -v pwsh >/dev/null 2>&1; then
  echo "pwsh is required. Install PowerShell to run AU-based updates."
  exit 2
fi

if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [version]"
  echo "Without version it updates to the latest stable release."
  exit 1
fi

if [ "$#" -eq 1 ]; then
  pwsh -NoLogo -NoProfile -File ./update.ps1 -Version "$1"
else
  pwsh -NoLogo -NoProfile -File ./update.ps1
fi
