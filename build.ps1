#!/usr/bin/env pwsh

[CmdletBinding()]
param (
  [Parameter()]
  [ValidateSet('build', 'package')]
  [string]
  $Target = 'build'
)
$Env:WORKINGDIR = $PSScriptRoot

switch ($Target) {
  'build' {
    $arch = go env GOHOSTARCH
    $platform = go env GOHOSTOS
    $binPath = Join-Path $PSScriptRoot "dist" "pct_${platform}_${arch}"
    # Set goreleaser to build for current platform only
    goreleaser build --snapshot --rm-dist --single-target
    git clone -b main --depth 1 --single-branch https://github.com/puppetlabs/baker-round (Join-Path $binPath "templates")
  }
  'package' {
    git clone -b main --depth 1 --single-branch https://github.com/puppetlabs/baker-round "templates"
    goreleaser --skip-publish --snapshot --rm-dist
  }
}
