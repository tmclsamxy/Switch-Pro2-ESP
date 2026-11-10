param(
    [string]$IdfPath,
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
. (Join-Path $RepoRoot "tools\esp32s3\idf_environment.ps1")
$IdfPath = Resolve-Y700IdfPath -RequestedPath $IdfPath

$common = @{
    IdfPath = $IdfPath
}

Write-Host "[Y700_BUILD_ALL] profile=pro2_bridge_v5_5"
& (Join-Path $RepoRoot "tools\esp32s3\build.ps1") @common `
    -BuildDir "work\b\pro2" `
    -DeviceDefaultMode NINTENDO_EXPERIMENT_MODE
if ($LASTEXITCODE -ne 0) {
    throw "Firmware build failed: pro2_bridge_v5_5"
}

Write-Host "[Y700_BUILD_ALL] profile=xinput_bridge_v5_8"
& (Join-Path $RepoRoot "tools\esp32s3\build.ps1") @common `
    -BuildDir "work\b\xinput" `
    -DeviceDefaultMode XINPUT_EXPERIMENT_MODE
if ($LASTEXITCODE -ne 0) {
    throw "Firmware build failed: xinput_bridge_v5_8"
}

$dualSenseBuild = Join-Path $RepoRoot "tools\esp32s3\build_v5_5_dualsense_identity.ps1"
foreach ($profile in @("hid_audio_uac1_4ch_ds5like", "hid_only")) {
    Write-Host "[Y700_BUILD_ALL] profile=$profile"
    & $dualSenseBuild -IdfPath $IdfPath -Profile $profile -Clean:$Clean
    if ($LASTEXITCODE -ne 0) {
        throw "Firmware build failed: $profile"
    }
}

Write-Host "[Y700_BUILD_ALL] result=passed"
