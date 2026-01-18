# NUCLEAR OPTION: Hapus SEMUA file build dengan cara yang lebih agresif
# Gunakan ini jika remove-all-build-files.ps1 masih tidak bekerja

Write-Host "========================================" -ForegroundColor Red
Write-Host "NUCLEAR OPTION - Hapus semua file build" -ForegroundColor Red
Write-Host "Ini akan menghapus SEMUA file di folder build dari SEMUA commit" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$confirm = Read-Host "YAKIN ingin melanjutkan? (ketik 'YES' untuk konfirmasi)"
if ($confirm -ne "YES") {
    Write-Host "Dibatalkan." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Menghapus semua file build..." -ForegroundColor Cyan
Write-Host ""

# Hapus dari cache
Write-Host "[1] Menghapus dari cache..." -ForegroundColor Yellow
git ls-files | Where-Object { $_ -match "build" } | ForEach-Object {
    git rm --cached "$_" 2>$null | Out-Null
}

# Gunakan filter-branch dengan pattern yang lebih luas
Write-Host "[2] Menghapus dari history (ini akan lama)..." -ForegroundColor Yellow
Write-Host "    Mohon tunggu..." -ForegroundColor Gray

# Hapus semua file yang mengandung "build" di path-nya
git filter-branch --force --tree-filter 'rm -rf "Modul 3/codelab/build" 2>/dev/null || true' --prune-empty --tag-name-filter cat -- --all

# Juga hapus dengan index-filter untuk lebih efektif
git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch "Modul 3/codelab/build" 2>/dev/null || true' --prune-empty --tag-name-filter cat -- --all

# Hapus semua file .apk, .aab, .so
git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch "*.apk" "*.aab" "*.so" 2>/dev/null || true' --prune-empty --tag-name-filter cat -- --all

Write-Host "    Selesai!" -ForegroundColor Green

# Cleanup
Write-Host "[3] Membersihkan..." -ForegroundColor Yellow
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object { git update-ref -d $_ 2>$null }
git reflog expire --expire=now --all 2>$null
git gc --prune=now --aggressive 2>$null

Write-Host ""
Write-Host "Selesai! Sekarang commit dan force push:" -ForegroundColor Green
Write-Host "  git add .gitignore" -ForegroundColor White
Write-Host "  git commit -m 'fix: remove all build files'" -ForegroundColor White
Write-Host "  git push origin main --force" -ForegroundColor White
Write-Host ""
