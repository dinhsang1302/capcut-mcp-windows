# Run from a downloaded/cloned repository after prerequisites are installed.
# Does not install system applications, edit PATH, or touch CapCut projects.
[CmdletBinding()]
param(
    [string]$PythonExe,
    [switch]$ConfigureCodex,
    [string]$ConfigPath = (Join-Path $env:USERPROFILE '.codex\config.toml')
)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
if (-not $IsWindows -and $PSVersionTable.PSEdition -eq 'Core') { throw 'Windows required.' }
foreach ($command in @('ffmpeg', 'ffprobe')) {
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        throw "$command missing. Follow README.md prerequisites; reopen PowerShell after PATH changes."
    }
}
if (-not $PythonExe) {
    if (-not (Get-Command py -ErrorAction SilentlyContinue)) { throw 'Install Python manager and Python 3.13 first; see README.md.' }
    $PythonExe = (& py -3.13 -c 'import sys; print(sys.executable)' | Select-Object -Last 1)
    if ($LASTEXITCODE -ne 0 -or -not $PythonExe) { throw 'Python 3.13 missing. Run py install 3.13.' }
}
& $PythonExe -c 'import sys; assert sys.version_info >= (3,11), "Python 3.11+ required"'
if ($LASTEXITCODE -ne 0) { throw 'Invalid Python runtime.' }
$venv = Join-Path $repo '.venv'
$python = Join-Path $venv 'Scripts\python.exe'
if (-not (Test-Path -LiteralPath $python)) {
    & $PythonExe -m venv $venv
    if ($LASTEXITCODE -ne 0) { throw 'Creating virtual environment failed.' }
}
& $python -m pip install -e $repo -c (Join-Path $repo 'constraints.txt')
if ($LASTEXITCODE -ne 0) { throw 'pip install failed. Config not changed.' }
& $python (Join-Path $PSScriptRoot 'verify_tools.py')
if ($LASTEXITCODE -ne 0) { throw 'MCP tools check failed. Config not changed.' }
if ($ConfigureCodex) {
    & $python (Join-Path $PSScriptRoot 'configure_codex.py') --config $ConfigPath --exe (Join-Path $venv 'Scripts\capcut-mcp.exe')
    if ($LASTEXITCODE -ne 0) { throw 'Config check/update failed; inspect the error.' }
}
Write-Output 'Installation complete. Restart Codex. Run capcut_probe only to check CapCut setup.'
Write-Output 'No CapCut project was edited or saved.'
