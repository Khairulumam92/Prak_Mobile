import 'package:flutter/material.dart';
import 'pages/stateless_page.dart';
import 'pages/stateful_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Widget Comparison Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
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

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade50,
              Colors.blue.shade50,
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade400,
                              Colors.blue.shade400,
                              Colors.indigo.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(-5, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            AnimatedBuilder(
                              animation: _rotationAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.3),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.science,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Eksperimen Widget Flutter',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Perbandingan StatelessWidget vs StatefulWidget dalam Navigasi',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title dengan animasi
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
                              0.3,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: Text(
                      'Pilih Jenis Widget untuk Dieksperimen:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.8),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // StatelessWidget Card dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(-0.3, 0),
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
                    child: _buildAnimatedCard(
                      context: context,
                      title: 'StatelessWidget',
                      description:
                          'Data random dihasilkan sekali dan tidak berubah',
                      icon: Icons.widgets,
                      gradientColors: [
                        Colors.blue.shade400,
                        Colors.blue.shade600,
                        Colors.indigo.shade600,
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    StatelessPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: animation.drive(
                                      Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // StatefulWidget Card dengan animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: const Interval(
                              0.5,
                              1.0,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                    child: _buildAnimatedCard(
                      context: context,
                      title: 'StatefulWidget',
                      description: 'Data random dapat berubah dengan tombol',
                      icon: Icons.widgets,
                      gradientColors: [
                        Colors.green.shade400,
                        Colors.green.shade600,
                        Colors.teal.shade600,
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const StatefulPage(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return SlideTransition(
                                    position: animation.drive(
                                      Tween(
                                        begin: const Offset(1.0, 0.0),
                                        end: Offset.zero,
                                      ).chain(
                                        CurveTween(curve: Curves.easeInOut),
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Footer Info Card dengan animasi
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
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade100,
                            Colors.orange.shade100,
                            Colors.yellow.shade100,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.amber.shade300,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.2),
                            blurRadius: 25,
                            offset: const Offset(-3, -3),
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
                                      Colors.amber.shade200,
                                      Colors.orange.shade200,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.lightbulb,
                                  color: Colors.amber.shade800,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Tujuan Eksperimen',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade800,
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
                            '• Bandingkan perilaku data random antara StatelessWidget dan StatefulWidget\n'
                            '• Amati bagaimana data diteruskan melalui navigasi\n'
                            '• Pahami perbedaan state management dalam kedua widget',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.amber.shade800,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: gradientColors[1].withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _cardAnimationController.forward().then((_) {
              _cardAnimationController.reverse();
            });
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedBuilder(
            animation: _cardAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 - (_cardAnimationController.value * 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
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
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
