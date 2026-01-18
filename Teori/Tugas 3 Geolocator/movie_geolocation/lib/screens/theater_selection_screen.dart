import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class TheaterSelectionScreen extends StatefulWidget {
  const TheaterSelectionScreen({super.key});

  @override
  State<TheaterSelectionScreen> createState() => _TheaterSelectionScreenState();
}

class _TheaterSelectionScreenState extends State<TheaterSelectionScreen> {
  final _locationService = LocationService();
  final _authService = AuthService();
  String _currentCity = 'MEDAN';
  bool _isLoadingLocation = false;
  final List<String> _theaters = [
    'XI CINEMA',
    'PONDOK KELAPA 21',
    'CGV',
    'CINEPOLIS',
    'CP MALL',
    'HERMES',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final cityName = await _locationService.getCityName();
      if (mounted) {
        setState(() {
          _currentCity = cityName;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showLocationDialog() {
    final cities = ['MEDAN', 'JAKARTA', 'SURABAYA', 'BANDUNG', 'MAKASSAR'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Select Location',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: cities.map((city) {
            return ListTile(
              title: Text(
                city,
                style: TextStyle(
                  color: city == _currentCity ? Colors.blue : Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  _currentCity = city;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Bar
          Container(
            color: const Color(0xFF1A237E),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'THEATER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the back button
              ],
            ),
          ),
          
          // User Profile Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  label: const Text(
                    'User Profile (Keranjang)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Location Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: _showLocationDialog,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isLoadingLocation
                        ? const Text(
                            'Loading location...',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Text(
                            _currentCity,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Theater List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _theaters.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _theaters[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
