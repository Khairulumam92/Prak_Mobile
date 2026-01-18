# Katalog Produk Digital Dinamis

Aplikasi Flutter sederhana untuk menampilkan katalog produk digital dengan antarmuka responsif dan animasi yang menarik.

## 📱 Fitur Utama

### 1. **Antarmuka Responsif**
- Layout adaptif yang menyesuaikan dengan ukuran layar
- **Ponsel**: Grid 2 kolom
- **Tablet**: Grid 3 kolom  
- **Desktop**: Grid 4 kolom
- Menggunakan `LayoutBuilder` dan `MediaQuery` untuk responsivitas

### 2. **Animasi Interaktif**
- **AnimatedContainer**: Transisi halus pada perubahan ukuran, warna, dan shadow
- **AnimatedOpacity**: Efek fade in/out
- **Transform Animation**: Efek scale saat card ditekan
- **Gesture Detection**: Interaksi tap dengan feedback visual

### 3. **Struktur Aplikasi**

```
lib/
├── main.dart                          # Entry point aplikasi (StatelessWidget)
├── models/
│   └── product.dart                   # Model data produk
└── pages/
    ├── splash_page.dart               # Splash screen (StatefulWidget)
    ├── product_catalog_page.dart      # Halaman katalog utama (StatefulWidget)
    └── product_detail_page.dart       # Halaman detail produk (StatelessWidget)
```

## 🎯 Implementasi Widget

### StatelessWidget
1. **MyApp** (`main.dart`) - Root aplikasi
2. **ProductDetailPage** (`product_detail_page.dart`) - Halaman detail produk

### StatefulWidget
1. **SplashPage** (`splash_page.dart`) - Splash screen dengan animasi
2. **ProductCatalogPage** (`product_catalog_page.dart`) - Halaman katalog utama
3. **ProductCard** (`product_catalog_page.dart`) - Kartu produk dengan animasi tap
4. **_AnimatedInfoCard** (`product_detail_page.dart`) - Kartu informasi dengan animasi slide & fade
5. **_AnimatedActionButton** (`product_detail_page.dart`) - Tombol dengan efek press

## 🎨 Teknik Responsivitas

### 1. LayoutBuilder
Digunakan di `ProductCatalogPage` untuk menentukan jumlah kolom grid berdasarkan lebar layar:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    int crossAxisCount;
    if (constraints.maxWidth < 600) {
      crossAxisCount = 2;  // Ponsel
    } else if (constraints.maxWidth < 900) {
      crossAxisCount = 3;  // Tablet
    } else {
      crossAxisCount = 4;  // Desktop
    }
    // ...
  },
)
```

### 2. MediaQuery
Digunakan di berbagai halaman untuk:
- Menentukan ukuran font responsif
- Menyesuaikan padding/margin
- Mengatur tinggi AppBar
- Menyesuaikan ukuran icon

```dart
final screenWidth = MediaQuery.of(context).size.width;
final isLargeScreen = screenWidth > 600;
```

## ✨ Animasi yang Diimplementasikan

### 1. AnimatedContainer
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
  decoration: BoxDecoration(
    color: _isPressed ? color.withOpacity(0.8) : color,
    boxShadow: [/* animated shadow */],
  ),
  // ...
)
```

**Efek:**
- Scale animation saat card ditekan
- Perubahan warna halus
- Shadow yang bergerak mengikuti state

### 2. Kombinasi AnimatedOpacity & Transform
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 500),
  transform: Matrix4.identity()..translate(0.0, _isVisible ? 0.0 : 20.0),
  child: AnimatedOpacity(
    duration: const Duration(milliseconds: 500),
    opacity: _isVisible ? 1.0 : 0.0,
    child: // ...
  ),
)
```

**Efek:**
- Slide up + fade in untuk info cards
- Stagger animation dengan delay berbeda

### 3. Gradient Animation
```dart
AnimatedContainer(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: _isPressed
        ? [color.withOpacity(0.7), color.withOpacity(0.9)]
        : [color, color.withOpacity(0.8)],
    ),
  ),
)
```

**Efek:**
- Perubahan gradient saat tombol ditekan
- Visual feedback yang smooth

## 🚀 Cara Menjalankan

1. **Pastikan Flutter sudah terinstall**
   ```bash
   flutter --version
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

4. **Untuk device tertentu**
   ```bash
   # Chrome
   flutter run -d chrome
   
   # Emulator Android
   flutter run -d emulator-5554
   
   # Semua device
   flutter devices
   ```

## 📊 Testing Responsivitas

### Emulator Android (Ponsel)
1. Buka Android Studio
2. AVD Manager → Pilih device dengan resolusi kecil (contoh: Pixel 5)
3. Jalankan aplikasi
4. **Expected**: Grid 2 kolom

### Emulator Android (Tablet)
1. AVD Manager → Pilih device tablet (contoh: Pixel Tablet)
2. Jalankan aplikasi
3. **Expected**: Grid 3 kolom

### Browser (Desktop)
1. Jalankan: `flutter run -d chrome`
2. Resize browser window
3. **Expected**: 
   - < 600px → 2 kolom
   - 600-900px → 3 kolom
   - > 900px → 4 kolom

## 🎯 Checklist Pembelajaran

- [x] Membangun UI adaptif dengan MediaQuery
- [x] Membangun UI adaptif dengan LayoutBuilder
- [x] Implementasi AnimatedContainer
- [x] Responsive grid layout (2/3/4 kolom)
- [x] Animasi scale & color transition
- [x] Gesture detection dengan visual feedback
- [x] StatefulWidget untuk komponen interaktif
- [x] StatelessWidget untuk komponen statis
- [x] Struktur folder pages yang terorganisir

## 📝 Catatan Implementasi

### Warna Kontras
Setiap produk memiliki warna berbeda untuk memudahkan observasi:
- Smartphone: Biru
- Laptop: Merah
- Tablet: Hijau
- Smartwatch: Orange
- Headphone: Ungu
- Kamera: Teal
- Speaker: Indigo
- Power Bank: Pink

### Animasi Timing
- **Card Press**: 200ms - Cepat untuk feedback responsif
- **Page Transition**: 500ms - Medium untuk smooth transition
- **Splash Animation**: 800-1400ms - Staggered untuk efek dramatis

### Performance
- Menggunakan `const` constructor untuk widget immutable
- Minimal rebuild dengan state management yang tepat
- Efficient rendering dengan LayoutBuilder

## 🛠️ Teknologi

- **Flutter SDK**: 3.x
- **Dart**: 3.x
- **Material Design 3**: Ya
- **Dependencies**: Hanya Flutter SDK (no external packages)

## 📱 Screenshot Konsep

```
┌─────────────────────────────────┐
│     [Splash Screen - 3s]        │
│  Logo + Animasi Fade + Scale    │
└─────────────────────────────────┘
              ↓
┌─────────────────────────────────┐
│   [Product Catalog - Grid]      │
│  ┌──────┐ ┌──────┐ ┌──────┐    │
│  │ Card │ │ Card │ │ Card │    │ ← Animasi saat tap
│  └──────┘ └──────┘ └──────┘    │
│  ┌──────┐ ┌──────┐ ┌──────┐    │
│  │ Card │ │ Card │ │ Card │    │
│  └──────┘ └──────┘ └──────┘    │
└─────────────────────────────────┘
              ↓ (tap)
┌─────────────────────────────────┐
│   [Product Detail - Scroll]     │
│  ┌─────────────────────────┐   │
│  │   Expandable AppBar     │   │
│  └─────────────────────────┘   │
│  Info Cards (Slide + Fade) →   │
│  Description                    │
│  Features List                  │
│  [Add to Cart Button] ← Animasi │
└─────────────────────────────────┘
```

## 🎓 Konsep yang Dipelajari

1. **Responsive Design**
   - Breakpoints
   - Adaptive layouts
   - Cross-platform compatibility

2. **Animation Principles**
   - Implicit animations
   - Timing & Curves
   - Feedback & Affordance

3. **State Management**
   - StatefulWidget lifecycle
   - setState optimization
   - Widget rebuilding

4. **Flutter Best Practices**
   - Code organization
   - Widget composition
   - Performance optimization

---

**Dibuat untuk**: Praktikum Mobile - Modul 2  
**Tema**: Katalog Produk Digital Dinamis  
**Fokus**: UI Responsif & Animasi Sederhana
