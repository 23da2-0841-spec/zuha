import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreeToTerms) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match.'),
          backgroundColor: const Color(0xFF705347),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final error = await context.read<AuthProvider>().register(
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
              const SizedBox(height: 6),
              Text(
                'THE DIGITAL ATELIER',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 11,
                  color: const Color(0xFF504440).withOpacity(0.7),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3EF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF705347).withOpacity(0.04),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFC7E8CB).withOpacity(0.2),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Create account',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 28,
                            color: Color(0xFF1C1C19),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Join our curated community of craftsmen.',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            color: const Color(0xFF504440).withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _FieldLabel(label: 'Full Name'),
                        const SizedBox(height: 6),
                        _InputField(
                          controller: _nameController,
                          hintText: 'Elias Thorne',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        _FieldLabel(label: 'Email'),
                        const SizedBox(height: 6),
                        _InputField(
                          controller: _emailController,
                          hintText: 'elias@atelier.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        _FieldLabel(label: 'Password'),
                        const SizedBox(height: 6),
                        _InputField(
                          controller: _passwordController,
                          hintText: '••••••••',
                          obscureText: _obscurePassword,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFF504440).withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FieldLabel(label: 'Confirm Password'),
                        const SizedBox(height: 6),
                        _InputField(
                          controller: _confirmPasswordController,
                          hintText: '••••••••',
                          obscureText: _obscureConfirm,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                            child: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 18,
                              color: const Color(0xFF504440).withOpacity(0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _agreeToTerms,
                                onChanged: (v) =>
                                    setState(() => _agreeToTerms = v ?? false),
                                activeColor: const Color(0xFF705347),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color: const Color(0xFFD4C3BD).withOpacity(0.8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 12,
                                    color: const Color(0xFF504440)
                                        .withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                  children: const [
                                    TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms of Service',
                                      style: TextStyle(
                                        color: Color(0xFF705347),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: TextStyle(
                                        color: Color(0xFF705347),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF705347),
                                  Color(0xFF8B6B5E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF705347).withOpacity(0.1),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: (_agreeToTerms && !_isLoading)
                                  ? _handleRegister
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor:
                                    Colors.white.withOpacity(0.5),
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
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Register',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward, size: 18),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 14,
                      color: const Color(0xFF504440).withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login',
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
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFD4C3BD).withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.filter_vintage_outlined,
                          size: 16,
                          color: const Color(0xFF705347).withOpacity(0.4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'EST. MMXXIV',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 8,
                            letterSpacing: 3,
                            color: const Color(0xFF504440).withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: const Color(0xFFD4C3BD).withOpacity(0.3),
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
        fontWeight: FontWeight.w700,
        color: Color(0xFF504440),
        letterSpacing: 1.2,
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
          color: const Color(0xFFD4C3BD).withOpacity(0.8),
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            color: const Color(0xFF705347).withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
    );
  }
}
