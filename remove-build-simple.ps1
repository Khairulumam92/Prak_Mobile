# Script sederhana untuk menghapus file build dari git cache dan history
Write-Host "Menghapus file build dari git..." -ForegroundColor Yellow
Write-Host ""

# Langkah 1: Hapus dari git cache
Write-Host "[1/3] Menghapus file build dari git cache..." -ForegroundColor Cyan
git ls-files | Where-Object { $_ -match "\\build\\" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
    Write-Host "  Removed: $_" -ForegroundColor Gray
}

git ls-files | Where-Object { $_ -match "\.(apk|aab|so)$" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
    Write-Host "  Removed: $_" -ForegroundColor Gray
}

git ls-files | Where-Object { $_ -match "zip-cache" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
    Write-Host "  Removed: $_" -ForegroundColor Gray
}

Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 2: Hapus dari history menggunakan filter-branch
Write-Host ""
Write-Host "[2/3] Menghapus dari git history (ini akan memakan waktu)..." -ForegroundColor Cyan
Write-Host "  Menghapus folder build dari semua commit..." -ForegroundColor Gray

# Hapus semua folder build dari history
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch 'Modul 3/codelab/build'" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "  Selesai!" -ForegroundColor Green
} else {
    Write-Host "  Warning: Mungkin ada error, tapi lanjutkan..." -ForegroundColor Yellow
}

# Langkah 3: Cleanup
Write-Host ""
Write-Host "[3/3] Membersihkan backup refs..." -ForegroundColor Cyan
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object {
    git update-ref -d $_ 2>$null
}
git reflog expire --expire=now --all 2>$null
git gc --prune=now --aggressive 2>$null
Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Selesai! Sekarang:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Commit perubahan:" -ForegroundColor White
Write-Host "     git add .gitignore" -ForegroundColor Cyan
Write-Host "     git commit -m 'fix: remove build files from repository'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Force push (HATI-HATI!):" -ForegroundColor White
Write-Host "     git push origin main --force" -ForegroundColor Cyan
Write-Host ""
Write-Host "PERINGATAN: Force push akan menimpa history di remote!" -ForegroundColor Red
Write-Host "Pastikan tidak ada orang lain yang bekerja di branch ini." -ForegroundColor Yellow
Write-Host ""
