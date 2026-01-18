import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String randomString;
  final int randomNumber;
  final String pageType;

  const DetailPage({
    super.key,
    required this.randomString,
    required this.randomNumber,
    required this.pageType,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isStateless = widget.pageType == 'StatelessWidget';
    final MaterialColor primaryColor = isStateless ? Colors.blue : Colors.green;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.shade50,
              isStateless ? Colors.indigo.shade50 : Colors.teal.shade50,
              isStateless ? Colors.purple.shade50 : Colors.cyan.shade50,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.shade400,
                              primaryColor.shade600,
                              primaryColor.shade700,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 25,
                              offset: const Offset(-3, -3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _rotationAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      isStateless ? Icons.info : Icons.refresh,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Detail - ${widget.pageType}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              offset: const Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isStateless
                                        ? 'Data dihasilkan sekali dan tidak berubah'
                                        : 'Data dapat berubah dengan tombol',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              offset: const Offset(0, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Data Display Card dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(-0.2, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(
                              0.2,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              primaryColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                            BoxShadow(
                              color: primaryColor.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(-2, -2),
                            ),
                          ],
                          border: Border.all(
                            color: primaryColor.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor.shade100,
                                              primaryColor.shade200,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: primaryColor.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.data_object,
                                          color: primaryColor.shade700,
                                          size: 20,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Data dari ${widget.pageType}',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor.shade700,
                                        shadows: [
                                          Shadow(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            offset: const Offset(0, 1),
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildAnimatedDataField(
                              context,
                              'Random String',
                              widget.randomString,
                              Icons.text_fields,
                              primaryColor,
                            ),
                            const SizedBox(height: 16),
                            _buildAnimatedDataField(
                              context,
                              'Random Number',
                              widget.randomNumber.toString(),
                              Icons.numbers,
                              primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Behavior Info Card dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.2, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(
                              0.4,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.shade100,
                            primaryColor.shade50,
                            Colors.white,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: primaryColor.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(-2, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.shade200,
                                      primaryColor.shade300,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  isStateless ? Icons.info : Icons.refresh,
                                  color: primaryColor.shade800,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Perilaku ${widget.pageType}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor.shade800,
                                      shadows: [
                                        Shadow(
                                          color: Colors.white.withOpacity(0.8),
                                          offset: const Offset(0, 1),
                                          blurRadius: 1,
                                        ),
                                      ],
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isStateless
                                ? 'Data dihasilkan sekali saat halaman pertama kali dibuka dan tidak berubah. Data yang ditampilkan di halaman detail selalu konsisten dengan data yang dihasilkan pertama kali.'
                                : 'Data dapat berubah setiap kali tombol ditekan dan yang ditampilkan adalah data terbaru. Data yang ditampilkan di halaman detail mencerminkan state terakhir sebelum navigasi.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: primaryColor.shade800,
                                  height: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.white.withOpacity(0.6),
                                      offset: const Offset(0, 1),
                                      blurRadius: 1,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // Back Button dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(
                              0.6,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Kembali'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedDataField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.8 + (_pulseAnimation.value - 1.0) * 0.2,
                  child: Icon(icon, color: color, size: 18),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              '$label:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
                shadows: [
                  Shadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: const Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
              color: color,
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.8),
                  offset: const Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
