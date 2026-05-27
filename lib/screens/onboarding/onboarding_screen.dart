import 'package:flutter/material.dart';

class _OnboardingSlide {
  final String imageUrl;
  final String heading;
  final String subtext;

  const _OnboardingSlide({
    required this.imageUrl,
    required this.heading,
    required this.subtext,
  });
}

const _slides = [
  _OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAx2k7b_DcAbUUYnNZRY7TGwzYoPyyxg1kIlQ-8LqZgUpHF08NvpTOQmu6-pYXsfPl5YXSw44tnk-SuR1pQf35M_--3cCn8CEuI-yxXJIzzFYRrKsSDB2LBqwypa94fJJMveSYPHhYdzO8KIphzoYT4k7hjS5BHfocfxiueH9lpHxNWC6HqbmE5GjXmOjGC4k5j___kRdZGIDCZWMeNgUTahfOIbLpSqpOV2r6uhStUcuXxo6NIk47bpuhGhcE-q2L0EdvJuxQyjj4',
    heading: 'Discover your style',
    subtext:
        'Explore a world of carefully chosen pieces that speak to your sensibility — from everyday elegance to statement dressing.',
  ),
  _OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAlIaLrrjsPQBTPXSmKBDuWbZmmQrKbH4FFlSQuEB9jJX7JJyXXtGkGu_dkU1sv4qNwmdO4rvyIGG9ugkQgPtj_wCjpbPWORoXpnvcV_84TcJfiGBOIYNSwNMjdOdCXEY8L17_WAy2BsU0maijGhcH9koUuO7kimfQEy29-gME8mWrquuBGE19QPgll55eKmZ0PotZTb7Uw4UJ0D4EmPm-tK1VAnCW4FkYUA4KZwvfTFCXNWlkrENcOEhOBU29ovRcvehO6XpcZqvU',
    heading: 'Curated collections',
    subtext:
        'Every season, our editors select pieces that blend heritage craft with a modern sensibility. Fashion that endures.',
  ),
  _OnboardingSlide(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCFES7GkVxPX-O0Suz-852hDinkm9oQ0QOksMyTF8pev3NsADEugbD8emyU-WiNJyOQ3Ab156stI2f6pYjPPgTEMTJx6wAVn56L1s8etwnvLTbW8jNqvFinTXc-KLKhFIpCDhuUKkBbXt-aVJWTMtAAqfBBhVK_XGA7rp4KEC2vsiyXvfMW4d_bz0q0QQkIMagy8Qa6UmtLclKkVZE5PTzNR7oi_iXbX8S8fDId95rKliKmfFjh0Wx_hD9ZMyxJZjO5rimOHWeNWtM',
    heading: 'Delivered to your door',
    subtext:
        'Experience the ease of luxury. Your curated selection arrives in sustainable, atelier-grade packaging.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F5),
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Column(
                children: [
                  // Top 65% — image
                  SizedBox(
                    height: size.height * 0.65,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          slide.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFEBE7E4),
                          ),
                        ),
                        // Gradient overlay
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                const Color(0xFFF7F3EF).withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom 35% — content panel
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFF7F3EF),
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 36),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text content
                          Column(
                            children: [
                              Text(
                                slide.heading,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'DMSerifDisplay',
                                  fontSize: 32,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF705347), // primary
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                slide.subtext,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF504440).withOpacity(0.7),
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),

                          // Footer: dots + button
                          Column(
                            children: [
                              // Dot indicators
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_slides.length, (i) {
                                  final isActive = i == _currentPage;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: isActive ? 28 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(999),
                                      color: isActive
                                          ? const Color(0xFF705347)
                                          : const Color(0xFFD4C3BD).withOpacity(0.5),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 28),

                              // CTA button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _goToNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF705347),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shadowColor: const Color(0xFF705347).withOpacity(0.1),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _currentPage == _slides.length - 1
                                            ? 'Get Started'
                                            : 'Next',
                                        style: const TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip button — top-right
          Positioned(
            top: MediaQuery.of(context).padding.top + 24,
            right: 28,
            child: GestureDetector(
              onTap: _goToLogin,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF504440).withOpacity(0.8),
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
