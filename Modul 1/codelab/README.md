# Flutter Widget Comparison Demo

Aplikasi Flutter yang membandingkan perilaku StatelessWidget dan StatefulWidget dalam konteks navigasi.

## Fitur

### 1. StatelessWidget Implementation
- Data random dihasilkan sekali saat halaman pertama kali dibuka
- Data tidak berubah meskipun halaman dibuka ulang
- Navigasi ke halaman detail menampilkan data yang sama

### 2. StatefulWidget Implementation  
- Data random dapat berubah setiap kali tombol ditekan
- Data terbaru diteruskan ke halaman detail melalui navigasi
- Menggunakan setState() untuk update UI

### 3. Navigasi
- Menggunakan Navigator.push() (imperatif)
- Data diteruskan melalui constructor parameter
- Halaman detail menampilkan data yang diterima

## Struktur File

```
lib/
├── main.dart                 # Entry point aplikasi
├── utils/
│   └── random_data.dart     # Utility untuk generate data random
└── pages/
    ├── stateless_page.dart  # Halaman StatelessWidget
    ├── stateful_page.dart   # Halaman StatefulWidget
    └── detail_page.dart     # Halaman detail untuk menampilkan data
```

## Cara Menjalankan

1. Pastikan Flutter sudah terinstall
2. Clone atau download project ini
3. Buka terminal di direktori project
4. Jalankan perintah:
   ```bash
   flutter pub get
   flutter run
   ```

## Cara Menggunakan

1. **Buka aplikasi** - Anda akan melihat halaman utama dengan dua pilihan
2. **Pilih StatelessWidget** - Klik pada card "StatelessWidget" untuk melihat implementasi StatelessWidget
3. **Pilih StatefulWidget** - Klik pada card "StatefulWidget" untuk melihat implementasi StatefulWidget
4. **Eksperimen dengan StatelessWidget**:
   - Lihat data random yang ditampilkan
   - Klik "Lihat Detail" untuk navigasi ke halaman detail
   - Kembali dan buka detail lagi - data akan tetap sama
5. **Eksperimen dengan StatefulWidget**:
   - Lihat data random yang ditampilkan
   - Klik "Generate Data Baru" untuk mengubah data
   - Klik "Lihat Detail" untuk navigasi ke halaman detail dengan data terbaru
   - Kembali, generate data baru lagi, lalu buka detail - data akan berbeda

## Observasi yang Diharapkan

### StatelessWidget
- ✅ Data random dihasilkan sekali dan tidak berubah
- ✅ Data di halaman detail selalu sama meskipun dibuka berulang kali
- ✅ Tidak ada tombol untuk mengubah data

### StatefulWidget  
- ✅ Data random dapat berubah dengan tombol
- ✅ Data di halaman detail sesuai dengan state terakhir sebelum navigasi
- ✅ Ada tombol untuk generate data baru

## Dokumentasi Lengkap

Lihat file `EXPERIMENT_REPORT.md` untuk dokumentasi lengkap tentang perbedaan perilaku, keuntungan, keterbatasan, dan kesimpulan dari eksperimen ini.

## Teknologi yang Digunakan

- **Flutter**: Framework UI
- **Dart**: Bahasa pemrograman
- **Material Design**: Design system
- **Navigator.push()**: Metode navigasi imperatif

## Screenshots

Aplikasi ini memiliki UI yang modern dengan:
- Card-based layout
- Color-coded sections (biru untuk StatelessWidget, hijau untuk StatefulWidget)
- Informative cards yang menjelaskan karakteristik masing-masing widget
- Responsive design yang bekerja di berbagai ukuran layar