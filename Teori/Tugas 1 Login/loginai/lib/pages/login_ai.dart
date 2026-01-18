import 'package:flutter/material.dart';
import 'dashboard.dart';

class LoginAI extends StatefulWidget {
  const LoginAI({super.key});

  @override
  State<LoginAI> createState() => _LoginAIState();
}

class _LoginAIState extends State<LoginAI> with SingleTickerProviderStateMixin {
  // Form controllers
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> formStateKey = GlobalKey<FormState>();

  // Animation controller for button scale animation
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with duration of 100 milliseconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    // Create scale animation that goes from 1.0 to 0.95 and back
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose animation controller to prevent memory leaks
    _animationController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  // Function to handle login button press
  void handleLoginButtonPress() {
    if (formStateKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  // Function to handle button tap down (scale down)
  void handleButtonTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  // Function to handle button tap up (scale up)
  void handleButtonTapUp(TapUpDetails details) {
    _animationController.reverse();
    handleLoginButtonPress();
  }

  // Function to handle button tap cancel (scale up)
  void handleButtonTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery for responsive design
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double screenWidth = mediaQueryData.size.width;
    final double screenHeight = mediaQueryData.size.height;

    // Calculate responsive padding values
    final double horizontalPadding = screenWidth * 0.1; // 10% of screen width
    final double verticalPadding = screenHeight * 0.05; // 5% of screen height

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Form(
            key: formStateKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Spacing from top
                SizedBox(height: screenHeight * 0.1),

                // Logo/Icon placeholder
                Icon(
                  Icons.account_circle,
                  size: screenWidth * 0.3,
                  color: Theme.of(context).colorScheme.primary,
                ),

                // Spacing after logo
                SizedBox(height: screenHeight * 0.05),

                // Login title text
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                // Spacing after title
                SizedBox(height: screenHeight * 0.05),

                // Email input field
                TextFormField(
                  controller: emailTextController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),

                // Spacing between input fields
                SizedBox(height: screenHeight * 0.02),

                // Password input field
                TextFormField(
                  controller: passwordTextController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),

                // Spacing before button
                SizedBox(height: screenHeight * 0.05),

                // Login button with scale animation
                GestureDetector(
                  onTapDown: handleButtonTapDown,
                  onTapUp: handleButtonTapUp,
                  onTapCancel: handleButtonTapCancel,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: handleLoginButtonPress,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
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
}
