# Script untuk menghapus SEMUA file build dari git history
Write-Host "========================================" -ForegroundColor Red
Write-Host "PERINGATAN: Script ini akan mengubah git history!" -ForegroundColor Red
Write-Host "Pastikan Anda sudah backup atau yakin dengan perubahan ini." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "Lanjutkan? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Dibatalkan." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Menghapus SEMUA file build dari git history..." -ForegroundColor Cyan
Write-Host "Ini akan memakan waktu beberapa menit..." -ForegroundColor Yellow
Write-Host ""

# Langkah 1: Hapus dari cache dulu
Write-Host "[1/4] Menghapus dari git cache..." -ForegroundColor Cyan
git ls-files | Where-Object { $_ -match "\\build\\" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
}
git ls-files | Where-Object { $_ -match "\.(apk|aab|so)$" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
}
Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 2: Hapus dari history - semua folder build
Write-Host ""
Write-Host "[2/4] Menghapus semua folder build dari history..." -ForegroundColor Cyan
Write-Host "  Memproses Modul 3/codelab/build..." -ForegroundColor Gray
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch 'Modul 3/codelab/build'" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null

# Hapus semua folder build lainnya juga
Write-Host "  Memproses semua folder build lainnya..." -ForegroundColor Gray
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch '*/build/*'" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null

Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 3: Hapus file .apk, .aab, dan .so dari semua commit
Write-Host ""
Write-Host "[3/4] Menghapus file besar (.apk, .aab, .so) dari history..." -ForegroundColor Cyan
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch '*.apk' '*.aab' '*.so'" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null
Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 4: Cleanup
Write-Host ""
Write-Host "[4/4] Membersihkan backup dan optimasi repository..." -ForegroundColor Cyan
Write-Host "  Menghapus backup refs..." -ForegroundColor Gray
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object {
    git update-ref -d $_ 2>$null
}
Write-Host "  Membersihkan reflog..." -ForegroundColor Gray
git reflog expire --expire=now --all 2>$null
Write-Host "  Menjalankan garbage collection..." -ForegroundColor Gray
git gc --prune=now --aggressive 2>$null
Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Selesai! Sekarang:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Commit perubahan:" -ForegroundColor White
Write-Host "     git add .gitignore" -ForegroundColor Cyan
Write-Host "     git commit -m 'fix: remove all build files from repository'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Force push:" -ForegroundColor White
Write-Host "     git push origin main --force" -ForegroundColor Cyan
Write-Host ""
Write-Host "PERINGATAN: Force push akan menimpa history di remote!" -ForegroundColor Red
Write-Host ""
