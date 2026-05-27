import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EF),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEBE7E4).withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC7E8CB).withOpacity(0.2),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Zuha',
                  style: TextStyle(
                    fontFamily: 'DMSerifDisplay',
                    fontSize: 36,
                    fontStyle: FontStyle.italic,
                    color: ZColors.primary,
                    height: 1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'wear the earth',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF504440),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 1,
                      color: const Color(0xFFD4C3BD).withOpacity(0.3),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 16,
                      height: 1,
                      color: const Color(0xFFD4C3BD).withOpacity(0.3),
                    ),
                  ],
                ),
                Text(
                  'Est. MMXXIV',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF504440).withOpacity(0.4),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
