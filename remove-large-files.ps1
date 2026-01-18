# Script untuk menghapus file besar spesifik dari git history
Write-Host "Menghapus file besar dari git history..." -ForegroundColor Yellow
Write-Host ""

# File-file besar yang perlu dihapus (dari error message)
$largeFiles = @(
    "Modul 3/codelab/build/app/outputs/apk/debug/app-debug.apk",
    "Modul 3/codelab/build/app/intermediates/incremental/debug-mergeJavaRes/zip-cache/3Z+am6rfNUFSNpZ35KD+RLsRuwI=",
    "Modul 3/codelab/build/app/intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib/arm64-v8a/libVkLayer_khronos_validation.so",
    "Modul 3/codelab/build/app/intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib/arm64-v8a/libflutter.so"
)

Write-Host "[1/3] Menghapus file besar dari cache..." -ForegroundColor Cyan
foreach ($file in $largeFiles) {
    Write-Host "  Removing: $file" -ForegroundColor Gray
    git rm --cached "$file" 2>$null | Out-Null
}
Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "[2/3] Menghapus dari history (INI AKAN LAMA)..." -ForegroundColor Cyan
Write-Host "  Mohon tunggu, ini memakan waktu beberapa menit..." -ForegroundColor Yellow

# Hapus setiap file besar dari history
foreach ($file in $largeFiles) {
    Write-Host "    Memproses: $file" -ForegroundColor Gray
    # Escape path untuk filter-branch
    $escapedFile = $file -replace "'", "''"
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch '$escapedFile' 2>/dev/null || true" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null
}

# Juga hapus seluruh folder build dari Modul 3
Write-Host "    Menghapus seluruh folder build Modul 3..." -ForegroundColor Gray
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch 'Modul 3/codelab/build' 2>/dev/null || true" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null

Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "[3/3] Membersihkan..." -ForegroundColor Cyan
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object { git update-ref -d $_ 2>$null }
git reflog expire --expire=now --all 2>$null
git gc --prune=now --aggressive 2>$null
Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Selesai! Sekarang:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  git add .gitignore" -ForegroundColor Cyan
Write-Host "  git commit -m 'fix: remove large build files'" -ForegroundColor Cyan
Write-Host "  git push origin main --force" -ForegroundColor Cyan
Write-Host ""
