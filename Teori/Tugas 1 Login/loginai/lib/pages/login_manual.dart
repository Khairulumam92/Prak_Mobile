import 'package:flutter/material.dart';
import 'dashboard.dart';

class LoginManual extends StatefulWidget {
  const LoginManual({super.key});

  @override
  State<LoginManual> createState() => _LoginManualState();
}

class _LoginManualState extends State<LoginManual> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double _buttonScale = 1.0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = EdgeInsets.symmetric(
      horizontal: size.width * 0.1,
      vertical: size.height * 0.05,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.1),
                Icon(
                  Icons.account_circle,
                  size: size.width * 0.3,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: size.height * 0.05),
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.05),
                GestureDetector(
                  onTapDown: (_) => setState(() => _buttonScale = 0.95),
                  onTapUp: (_) {
                    setState(() => _buttonScale = 1.0);
                    _handleLogin();
                  },
                  onTapCancel: () => setState(() => _buttonScale = 1.0),
                  child: AnimatedScale(
                    scale: _buttonScale,
                    duration: const Duration(milliseconds: 100),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                        ),
                      ),
                      child: const Text('Login'),
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
