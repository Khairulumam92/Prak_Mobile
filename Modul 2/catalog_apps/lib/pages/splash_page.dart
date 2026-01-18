import 'package:flutter/material.dart';
import 'dart:async';

// StatefulWidget untuk splash screen dengan animasi
class SplashPage extends StatefulWidget {
  final Widget nextPage;

  const SplashPage({super.key, required this.nextPage});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();

    // Animasi fade in
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
          _scale = 1.0;
        });
      }
    });

    // Navigasi ke halaman berikutnya setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget.nextPage),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade700],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo/icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                transform: Matrix4.diagonal3Values(_scale, _scale, 1.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _isVisible ? 1.0 : 0.0,
                  child: Container(
                    padding: EdgeInsets.all(isLargeScreen ? 40 : 32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      size: isLargeScreen ? 120 : 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isLargeScreen ? 40 : 32),

              // Animated title
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Text(
                  'Katalog Produk',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 36 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Animated subtitle
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Text(
                  'Digital Dinamis',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 20 : 16,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: isLargeScreen ? 60 : 40),

              // Loading indicator
              AnimatedOpacity(
                duration: const Duration(milliseconds: 1400),
                opacity: _isVisible ? 1.0 : 0.0,
                child: SizedBox(
                  width: isLargeScreen ? 60 : 40,
                  height: isLargeScreen ? 60 : 40,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
