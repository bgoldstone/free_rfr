# Signs Windows PE files with the supplied PFX and verifies signer identity and signature status.
# Requires WINDOWS_PFX_BASE64, WINDOWS_PFX_PASSWORD, and RUNNER_TEMP; ALLOW_SELF_SIGNED_SIGNATURES defaults to true.
$ErrorActionPreference = 'Stop'
$allowSelfSigned = ($env:ALLOW_SELF_SIGNED_SIGNATURES -ne 'false')

foreach ($name in @('WINDOWS_PFX_BASE64', 'WINDOWS_PFX_PASSWORD')) {
  if (-not (Get-Item -LiteralPath "Env:$name" -ErrorAction SilentlyContinue)) {
    throw "Missing required secret: $name"
  }
}

$pfx = Join-Path $env:RUNNER_TEMP 'free_rfr-signing.pfx'
try {
  [IO.File]::WriteAllBytes($pfx, [Convert]::FromBase64String($env:WINDOWS_PFX_BASE64))
  $pfxCertificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($pfx, $env:WINDOWS_PFX_PASSWORD)
  $expectedThumbprint = $pfxCertificate.Thumbprint

  $signtool = Get-ChildItem 'C:\Program Files (x86)\Windows Kits\10\bin\*\x64\signtool.exe' -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending |
    Select-Object -First 1 -ExpandProperty FullName
  if (-not $signtool) {
    throw 'signtool.exe was not found'
  }

  $files = @(Get-ChildItem -LiteralPath 'build/windows/x64/runner/Release' -Recurse -File |
    Where-Object { $_.Extension -in @('.exe', '.dll') })
  if ($files.Count -eq 0) {
    throw 'No Windows executables were found'
  }

  & $signtool sign /fd SHA256 /f $pfx /p $env:WINDOWS_PFX_PASSWORD $files.FullName
  if ($LASTEXITCODE -ne 0) {
    throw 'Windows code signing failed'
  }

  foreach ($file in $files) {
    $signature = Get-AuthenticodeSignature -LiteralPath $file.FullName
    $status = $signature.Status.ToString()
    if ($status -in @('NotSigned', 'HashMismatch')) {
      throw "Windows signature is missing or invalid: $($file.FullName) ($status)"
    }
    if (-not $signature.SignerCertificate) {
      throw "Windows signer certificate is missing: $($file.FullName)"
    }
    if ($signature.SignerCertificate.Thumbprint -ine $expectedThumbprint) {
      throw "Windows artifact was signed with an unexpected certificate: $($file.FullName)"
    }
    if (-not $allowSelfSigned -and $status -ne 'Valid') {
      throw "Windows signature chain is not trusted: $($file.FullName) ($status)"
    }
  }
}
finally {
  if (Test-Path -LiteralPath $pfx) {
    Remove-Item -LiteralPath $pfx -Force
  }
}
