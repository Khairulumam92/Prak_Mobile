import 'package:flutter/material.dart';
import '../models/product.dart';

// StatelessWidget untuk halaman detail produk
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Gunakan MediaQuery untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar dengan animasi
          SliverAppBar(
            expandedHeight: isLargeScreen ? 300 : 200,
            pinned: true,
            backgroundColor: product.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      product.color,
                      product.color.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getIconForCategory(product.category),
                    size: isLargeScreen ? 120 : 80,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(isLargeScreen ? 32 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated info cards
                  _AnimatedInfoCard(
                    icon: Icons.category,
                    title: 'Kategori',
                    value: product.category,
                    color: Colors.blue,
                    delay: 100,
                  ),
                  const SizedBox(height: 16),
                  _AnimatedInfoCard(
                    icon: Icons.attach_money,
                    title: 'Harga',
                    value: 'Rp ${_formatPrice(product.price)}',
                    color: Colors.green,
                    delay: 200,
                  ),
                  const SizedBox(height: 16),
                  _AnimatedInfoCard(
                    icon: Icons.qr_code,
                    title: 'ID Produk',
                    value: product.id,
                    color: Colors.orange,
                    delay: 300,
                  ),
                  const SizedBox(height: 32),

                  // Deskripsi produk
                  Text(
                    'Deskripsi Produk',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getProductDescription(product.name),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Fitur produk
                  Text(
                    'Fitur Utama',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeaturesList(),

                  const SizedBox(height: 32),

                  // Tombol aksi
                  SizedBox(
                    width: double.infinity,
                    child: _AnimatedActionButton(product: product),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      'Kualitas premium dengan teknologi terkini',
      'Garansi resmi 1 tahun',
      'Gratis ongkir ke seluruh Indonesia',
      'Cicilan 0% tersedia',
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: product.color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.smartphone;
      case 'Komputer':
        return Icons.laptop_mac;
      case 'Aksesoris':
        return Icons.watch;
      case 'Audio':
        return Icons.headphones;
      case 'Fotografi':
        return Icons.camera_alt;
      default:
        return Icons.shopping_bag;
    }
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _getProductDescription(String name) {
    return 'Produk $name adalah salah satu produk digital terbaik di kelasnya. '
        'Dengan desain yang elegan dan performa yang andal, produk ini cocok '
        'untuk kebutuhan sehari-hari maupun profesional. Dilengkapi dengan '
        'fitur-fitur canggih dan teknologi terkini yang akan meningkatkan '
        'produktivitas dan pengalaman pengguna Anda.';
  }
}

// StatefulWidget untuk kartu info dengan animasi
class _AnimatedInfoCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final int delay;

  const _AnimatedInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.delay,
  });

  @override
  State<_AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<_AnimatedInfoCard> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      transform: Matrix4.translationValues(0.0, _isVisible ? 0.0 : 20.0, 0.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isVisible ? 1.0 : 0.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// StatefulWidget untuk tombol aksi dengan animasi
class _AnimatedActionButton extends StatefulWidget {
  final Product product;

  const _AnimatedActionButton({required this.product});

  @override
  State<_AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<_AnimatedActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _showPurchaseDialog();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isPressed
                ? [
                    widget.product.color.withValues(alpha: 0.7),
                    widget.product.color.withValues(alpha: 0.9),
                  ]
                : [
                    widget.product.color,
                    widget.product.color.withValues(alpha: 0.8),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: widget.product.color.withValues(
                alpha: _isPressed ? 0.3 : 0.5,
              ),
              blurRadius: _isPressed ? 8 : 16,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isPressed ? Icons.shopping_cart : Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              _isPressed ? 'Menambahkan...' : 'Tambah ke Keranjang',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil!'),
        content: Text('${widget.product.name} telah ditambahkan ke keranjang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
