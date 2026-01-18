# Script untuk menghapus SEMUA file build dari git
Write-Host "Menghapus SEMUA file build dari git cache..." -ForegroundColor Red
Write-Host ""

# Hapus semua file di folder build
Write-Host "Menghapus semua file di folder build..." -ForegroundColor Yellow
git ls-files | Where-Object { $_ -match "\\build\\" } | ForEach-Object {
    Write-Host "  Removing: $_" -ForegroundColor Red
    git rm --cached "$_" 2>$null
}

# Hapus file .apk dan .aab
Write-Host "`nMenghapus file APK dan AAB..." -ForegroundColor Yellow
git ls-files | Where-Object { $_ -match "\.(apk|aab)$" } | ForEach-Object {
    Write-Host "  Removing: $_" -ForegroundColor Red
    git rm --cached "$_" 2>$null
}

# Hapus file .so (shared libraries yang besar)
Write-Host "`nMenghapus file .so (shared libraries)..." -ForegroundColor Yellow
git ls-files | Where-Object { $_ -match "\.so$" } | ForEach-Object {
    Write-Host "  Removing: $_" -ForegroundColor Red
    git rm --cached "$_" 2>$null
}

# Hapus file zip-cache
Write-Host "`nMenghapus file zip-cache..." -ForegroundColor Yellow
git ls-files | Where-Object { $_ -match "zip-cache" } | ForEach-Object {
    Write-Host "  Removing: $_" -ForegroundColor Red
    git rm --cached "$_" 2>$null
}

Write-Host ""
Write-Host "Selesai! Sekarang commit dan push:" -ForegroundColor Green
Write-Host "  git add .gitignore" -ForegroundColor White
Write-Host "  git commit -m 'fix: remove all build files and large artifacts'" -ForegroundColor White
Write-Host "  git push origin main" -ForegroundColor White
