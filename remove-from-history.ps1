# Script untuk menghapus file besar dari git history
Write-Host "PERINGATAN: Script ini akan mengubah git history!" -ForegroundColor Red
Write-Host "Pastikan Anda sudah backup repository atau yakin dengan perubahan ini." -ForegroundColor Yellow
Write-Host ""

$confirm = Read-Host "Lanjutkan? (y/N)"
if ($confirm -ne "y" -and $confirm -ne "Y") {
    Write-Host "Dibatalkan." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Menghapus file besar dari git history..." -ForegroundColor Cyan
Write-Host ""

# File-file besar yang perlu dihapus dari history
$largeFiles = @(
    "Modul 3/codelab/build/app/outputs/apk/debug/app-debug.apk",
    "Modul 3/codelab/build/app/intermediates/incremental/debug-mergeJavaRes/zip-cache/3Z+am6rfNUFSNpZ35KD+RLsRuwI=",
    "Modul 3/codelab/build/app/intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib/arm64-v8a/libVkLayer_khronos_validation.so",
    "Modul 3/codelab/build/app/intermediates/merged_native_libs/debug/mergeDebugNativeLibs/out/lib/arm64-v8a/libflutter.so"
)

# Hapus semua file di folder build dari history
Write-Host "Menghapus semua file build dari history..." -ForegroundColor Yellow
Write-Host "Ini mungkin memakan waktu beberapa menit..." -ForegroundColor Yellow
Write-Host ""

# Gunakan git filter-branch untuk menghapus file dari semua commit
$buildPath = "Modul 3/codelab/build"

# Hapus semua file di folder build
git filter-branch --force --index-filter "git rm -rf --cached --ignore-unmatch '$buildPath'" --prune-empty --tag-name-filter cat -- --all

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Berhasil menghapus file dari history!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Sekarang jalankan:" -ForegroundColor Yellow
    Write-Host "  git push origin main --force" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "PERINGATAN: Force push akan menimpa history di remote!" -ForegroundColor Red
    Write-Host "Pastikan tidak ada orang lain yang sedang bekerja di branch ini." -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Error saat menghapus dari history." -ForegroundColor Red
    Write-Host "Coba alternatif: gunakan BFG Repo-Cleaner" -ForegroundColor Yellow
}
