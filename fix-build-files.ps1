# Script definitif untuk menghapus semua file build dari git
Write-Host "========================================" -ForegroundColor Red
Write-Host "Hapus SEMUA file build dari git history" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

# Langkah 1: Hapus dari working directory cache
Write-Host "[1/5] Menghapus dari git cache..." -ForegroundColor Cyan
$buildFiles = git ls-files | Where-Object { $_ -match "\\build\\" -or $_ -match "\.(apk|aab|so)$" -or $_ -match "zip-cache" }
$count = 0
foreach ($file in $buildFiles) {
    git rm --cached "$file" 2>$null | Out-Null
    $count++
    if ($count % 10 -eq 0) {
        Write-Host "  Processed $count files..." -ForegroundColor Gray
    }
}
Write-Host "  Menghapus $count file dari cache" -ForegroundColor Green

# Langkah 2: Hapus dari history menggunakan filter-branch
Write-Host ""
Write-Host "[2/5] Menghapus dari git history (INI AKAN LAMA - mohon tunggu)..." -ForegroundColor Cyan
Write-Host "  Menghapus folder build dari semua commit..." -ForegroundColor Yellow

# Hapus semua folder build dari semua modul
$modules = @(
    "Modul 1/codelab/build",
    "Modul 1/time_refresh/build",
    "Modul 2/catalog_apps/build",
    "Modul 2/example/build",
    "Modul 3/codelab/build",
    "Modul 4/codelab/build",
    "Modul 5/codelab/build",
    "Modul 6/codelab/build",
    "Teori/Tugas 1 Login/loginai/build",
    "Teori/Tugas 2 Database/login/build",
    "Teori/Tugas 3 Geolocator/movie_geolocation/build"
)

foreach ($module in $modules) {
    Write-Host "    Memproses: $module" -ForegroundColor Gray
    git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch '$module'" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null
}

Write-Host "  Selesai menghapus folder build!" -ForegroundColor Green

# Langkah 3: Hapus file .apk, .aab, .so dari semua commit
Write-Host ""
Write-Host "[3/5] Menghapus file besar (.apk, .aab, .so) dari history..." -ForegroundColor Cyan
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch '*.apk' '*.aab' '*.so' 2>/dev/null || true" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null
Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 4: Hapus file zip-cache
Write-Host ""
Write-Host "[4/5] Menghapus file zip-cache dari history..." -ForegroundColor Cyan
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch '*/zip-cache/*' 2>/dev/null || true" --prune-empty --tag-name-filter cat -- --all 2>&1 | Out-Null
Write-Host "  Selesai!" -ForegroundColor Green

# Langkah 5: Cleanup
Write-Host ""
Write-Host "[5/5] Membersihkan backup dan optimasi..." -ForegroundColor Cyan
Write-Host "  Menghapus backup refs..." -ForegroundColor Gray
git for-each-ref --format="%(refname)" refs/original/ | ForEach-Object {
    git update-ref -d $_ 2>$null
}
Write-Host "  Membersihkan reflog..." -ForegroundColor Gray
git reflog expire --expire=now --all 2>$null
Write-Host "  Garbage collection..." -ForegroundColor Gray
git gc --prune=now --aggressive 2>$null
Write-Host "  Selesai!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SELESAI! Sekarang:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Commit perubahan:" -ForegroundColor White
Write-Host "     git add .gitignore" -ForegroundColor Cyan
Write-Host "     git commit -m 'fix: remove all build files from repository'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Force push:" -ForegroundColor White
Write-Host "     git push origin main --force" -ForegroundColor Cyan
Write-Host ""
Write-Host "PERINGATAN: Force push akan menimpa history!" -ForegroundColor Red
Write-Host ""
