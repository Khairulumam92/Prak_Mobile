# Script untuk menghapus file besar dari git cache
Write-Host "Menghapus file build dan cache dari git cache..." -ForegroundColor Yellow
Write-Host ""

# Dapatkan semua file yang ter-track di git
Write-Host "Mendapatkan daftar file yang ter-track..." -ForegroundColor Cyan
$trackedFiles = git ls-files

# Pattern untuk file yang harus dihapus
$patternsToRemove = @(
    "\\build\\",           # Semua folder build
    "\.gradle",            # Gradle cache
    "node_modules",        # Node modules
    "\.iml$",              # IntelliJ files
    "\.dart_tool",         # Dart tool cache
    "\.pub-cache",         # Pub cache
    "\.pub\\",             # Pub directory
    "\.flutter-plugins$",  # Flutter plugins
    "\.flutter-plugins-dependencies$",
    "\.packages$",
    "\.DS_Store$",
    "Thumbs\.db$",
    "\.apk$",              # APK files
    "\.aab$",              # AAB files
    "\.zip$",
    "\.rar$",
    "\.tar\.gz$",
    "\.so$",               # Shared libraries (biasanya besar)
    "zip-cache"            # Zip cache files
)

$removedCount = 0
$totalSize = 0
$largeFiles = @()

Write-Host "Memproses file..." -ForegroundColor Cyan

foreach ($file in $trackedFiles) {
    $shouldRemove = $false
    
    foreach ($pattern in $patternsToRemove) {
        if ($file -match $pattern) {
            $shouldRemove = $true
            break
        }
    }
    
    if ($shouldRemove) {
        try {
            $filePath = Join-Path (Get-Location) $file
            if (Test-Path $filePath) {
                $item = Get-Item $filePath -ErrorAction SilentlyContinue
                if ($item) {
                    $fileSize = $item.Length
                    if ($fileSize) {
                        $totalSize += $fileSize
                        if ($fileSize -gt 1MB) {
                            $largeFiles += [PSCustomObject]@{
                                File = $file
                                Size = [math]::Round($fileSize/1MB, 2)
                            }
                        }
                    }
                }
            }
            
            git rm --cached "$file" 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  [REMOVED] $file" -ForegroundColor Red
                $removedCount++
            }
        } catch {
            # Ignore errors
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Total file dihapus: $removedCount" -ForegroundColor Green
Write-Host "Total ukuran: $([math]::Round($totalSize/1MB, 2)) MB" -ForegroundColor Green

if ($largeFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "File besar yang dihapus (>1MB):" -ForegroundColor Yellow
    foreach ($largeFile in $largeFiles) {
        Write-Host "  - $($largeFile.File): $($largeFile.Size) MB" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Sekarang jalankan perintah berikut:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  # Stage .gitignore" -ForegroundColor White
Write-Host "  git add .gitignore" -ForegroundColor Cyan
Write-Host ""
Write-Host "  # Commit perubahan" -ForegroundColor White
Write-Host "  git commit -m 'fix: remove build files and large files from repository'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  # Set buffer lebih besar" -ForegroundColor White
Write-Host "  git config http.postBuffer 524288000" -ForegroundColor Cyan
Write-Host ""
Write-Host "  # Push ke repository" -ForegroundColor White
Write-Host "  git push origin main" -ForegroundColor Cyan
Write-Host ""
