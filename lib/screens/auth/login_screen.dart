import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final error = await context.read<AuthProvider>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: const Color(0xFF705347),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              Text(
                'Zuha',
                style: const TextStyle(
                  fontFamily: 'DMSerifDisplay',
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF705347),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3EF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DMSerifDisplay',
                        fontSize: 28,
                        color: Color(0xFF1C1C19),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your details to access your atelier',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 13,
                        color: const Color(0xFF504440).withOpacity(0.8),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _FieldLabel(label: 'Email Address'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _emailController,
                      hintText: 'atelier@zuha.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _FieldLabel(label: 'Password'),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF705347),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      obscureText: _obscurePassword,
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 18,
                          color: const Color(0xFF504440).withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF705347),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFD4C3BD).withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or continue with',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF504440).withOpacity(0.6),
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFD4C3BD).withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: const Color(0xFFD4C3BD).withOpacity(0.5),
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _GoogleLogo(),
                            const SizedBox(width: 12),
                            const Text(
                              'Google',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF504440),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 14,
                      color: const Color(0xFF504440).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF705347),
                      ),
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
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF504440),
        letterSpacing: 1.0,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        color: Color(0xFF1C1C19),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          color: const Color(0xFF504440).withOpacity(0.4),
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFF1EDE9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: const Color(0xFFD4C3BD).withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.4,
      2.1,
      false,
      paint..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.7,
      1.6,
      false,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.3,
      1.5,
      false,
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.8,
      1.0,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
