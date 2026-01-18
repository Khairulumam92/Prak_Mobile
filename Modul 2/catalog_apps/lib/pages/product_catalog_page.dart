import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import '../models/product.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  // Daftar produk dummy
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Smartphone Premium',
      price: 8999000,
      category: 'Elektronik',
      color: Colors.blue.shade400,
    ),
    Product(
      id: '2',
      name: 'Laptop Gaming',
      price: 15999000,
      category: 'Komputer',
      color: Colors.red.shade400,
    ),
    Product(
      id: '3',
      name: 'Tablet Pro',
      price: 6999000,
      category: 'Elektronik',
      color: Colors.green.shade400,
    ),
    Product(
      id: '4',
      name: 'Smartwatch',
      price: 2999000,
      category: 'Aksesoris',
      color: Colors.orange.shade400,
    ),
    Product(
      id: '5',
      name: 'Headphone Wireless',
      price: 1999000,
      category: 'Audio',
      color: Colors.purple.shade400,
    ),
    Product(
      id: '6',
      name: 'Kamera Digital',
      price: 12999000,
      category: 'Fotografi',
      color: Colors.teal.shade400,
    ),
    Product(
      id: '7',
      name: 'Speaker Bluetooth',
      price: 899000,
      category: 'Audio',
      color: Colors.indigo.shade400,
    ),
    Product(
      id: '8',
      name: 'Power Bank',
      price: 499000,
      category: 'Aksesoris',
      color: Colors.pink.shade400,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Katalog Produk Digital',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Tentukan jumlah kolom berdasarkan lebar layar
          int crossAxisCount;
          double childAspectRatio;

          if (constraints.maxWidth < 600) {
            // Phone: 2 kolom
            crossAxisCount = 2;
            childAspectRatio = 0.75;
          } else if (constraints.maxWidth < 900) {
            // Tablet: 3 kolom
            crossAxisCount = 3;
            childAspectRatio = 0.8;
          } else {
            // Desktop: 4 kolom
            crossAxisCount = 4;
            childAspectRatio = 0.85;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(product: products[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// StatefulWidget untuk kartu produk dengan animasi
class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
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
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(
          _isPressed ? 0.95 : 1.0,
          _isPressed ? 0.95 : 1.0,
          1.0,
        ),
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.product.color.withValues(alpha: 0.8)
              : widget.product.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.product.color.withValues(
                alpha: _isPressed ? 0.3 : 0.5,
              ),
              blurRadius: _isPressed ? 8 : 12,
              offset: Offset(0, _isPressed ? 2 : 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon produk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForCategory(widget.product.category),
                  size: 32,
                  color: Colors.white,
                ),
              ),
              // Informasi produk
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.category,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${_formatPrice(widget.product.price)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
}
