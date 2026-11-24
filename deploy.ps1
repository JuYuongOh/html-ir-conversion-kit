# deploy.ps1
# Commits the latest 3 files (.md / .html / .zip), pushes them to GitHub,
# and publishes a new GitHub Release so the "latest" download links update.
# Usage:  powershell -ExecutionPolicy Bypass -File .\deploy.ps1 -Message "what changed"

param([string]$Message = "")

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')

function Assert-Ok($step) {
    if ($LASTEXITCODE -ne 0) { throw "Failed: $step (exit $LASTEXITCODE)" }
}

# 1. The three deliverables must be present
$files = @(Get-ChildItem -File | Where-Object { $_.Extension -in '.md', '.html', '.zip' -and $_.Name -ne 'README.md' })
if ($files.Count -ne 3) {
    throw "Expected 3 files (.md, .html, .zip) but found $($files.Count): $($files.Name -join ', ')"
}

# 2. Stop if nothing changed
git add -A; Assert-Ok 'git add'
$changes = git status --porcelain
if (-not $changes) {
    Write-Host 'No changes since the last deploy. Nothing to do.'
    exit 0
}

# 3. Pick a tag: vYYYY.MM.DD, or vYYYY.MM.DD-2, -3 ... for repeat deploys on the same day
git fetch --tags --quiet; Assert-Ok 'git fetch'
$date = Get-Date -Format 'yyyy.MM.dd'
$existing = @(git tag --list "v$date*")
$tag = "v$date"
$n = 1
while ($existing -contains $tag) { $n++; $tag = "v$date-$n" }

if (-not $Message) { $Message = "Update files ($tag)" }

# 4. Commit and push
git commit --quiet -m $Message; Assert-Ok 'git commit'
git push --quiet origin HEAD; Assert-Ok 'git push'

# 5. Bundle the three files into one zip. GitHub strips Korean characters from
#    release asset names, so the asset gets an ASCII name and the files inside
#    keep their original Korean names.
$stage = Join-Path ([IO.Path]::GetTempPath()) ("html-ir-" + [Guid]::NewGuid())
$bundleDir = Join-Path $stage 'files'
New-Item -ItemType Directory -Path $bundleDir | Out-Null
$files | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $bundleDir }
$bundle = Join-Path $stage 'HTML_IR_kit.zip'
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($bundleDir, $bundle, [IO.Compression.CompressionLevel]::Optimal, $false, [Text.Encoding]::UTF8)

# 6. Publish the release with the bundle attached
$firstLine = ($Message -split "`r?`n")[0]
try {
    gh release create $tag $bundle --title "$tag" --notes "$firstLine" --latest; Assert-Ok 'gh release create'
}
finally {
    Remove-Item -LiteralPath $stage -Recurse -Force
}

Write-Host ""
Write-Host "Deployed $tag"
gh release view $tag --json url --jq .url
