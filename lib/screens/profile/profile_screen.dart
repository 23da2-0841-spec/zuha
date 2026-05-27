import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/order.dart';
import '../../widgets/common/zuha_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _newsletterCtrl = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    _newsletterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = context.watch<ThemeProvider>();
    final user = auth.currentUser;
    final userId = auth.currentUser?.id;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1EDE9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF7F3EF),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF705347)
                                        .withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                user?.avatarInitials ?? '?',
                                style: const TextStyle(
                                  fontFamily: 'DMSerifDisplay',
                                  fontSize: 34,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF705347),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF705347),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user?.name ?? 'Guest',
                          style: const TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF1C1C19),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            letterSpacing: 0.3,
                            color: const Color(0xFF504440).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (userId != null)
                  StreamBuilder<List<ZOrder>>(
                    stream: _firestoreService.getUserOrders(userId),
                    builder: (context, snapshot) {
                      final orders = snapshot.data ?? <ZOrder>[];
                      final totalOrders = orders.length;
                      final loyaltyPoints =
                          (orders.fold(0.0, (s, o) => s + o.total) / 10)
                              .round()
                              .clamp(0, 9999);

                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 22,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F3EF),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'TOTAL ORDERS',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5,
                                          color: const Color(0xFF504440)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$totalOrders',
                                        style: const TextStyle(
                                          fontFamily: 'DMSerifDisplay',
                                          fontSize: 26,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF705347),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 22,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(0xFFC7E8CB).withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'LOYALTY POINTS',
                                        style: TextStyle(
                                          fontFamily: 'DMSans',
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.5,
                                          color: const Color(0xFF4C6952)
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$loyaltyPoints',
                                        style: const TextStyle(
                                          fontFamily: 'DMSerifDisplay',
                                          fontSize: 26,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF48654E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                else
                  const SliverToBoxAdapter(child: SizedBox()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACCOUNT SETTINGS',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: const Color(0xFF504440).withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _MenuTile(
                          icon: Icons.person_outline,
                          label: 'Edit Profile',
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.location_on_outlined,
                          label: 'Addresses',
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.favorite_outline,
                          label: 'Wishlist',
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          trailing: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF705347),
                              shape: BoxShape.circle,
                            ),
                          ),
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.dark_mode_outlined,
                          label: 'Dark Mode',
                          trailing: _DarkModeToggle(
                            value: theme.isDarkMode,
                            onChanged: (_) => theme.toggleTheme(),
                          ),
                          onTap: () => theme.toggleTheme(),
                        ),
                        const SizedBox(height: 10),
                        _MenuTile(
                          icon: Icons.help_outline,
                          label: 'Help',
                          onTap: () {},
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            auth.logout();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/login',
                              (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFFFFDAD6).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDAD6)
                                        .withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.logout,
                                    color: Color(0xFFBA1A1A),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFBA1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1EDE9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Atelier Notes',
                            style: TextStyle(
                              fontFamily: 'DMSerifDisplay',
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF705347),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join our private list for seasonal lookbooks and artisan stories.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              height: 1.6,
                              color: const Color(0xFF504440).withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _newsletterCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 13,
                                    color: Color(0xFF1C1C19),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Your email',
                                    hintStyle: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 13,
                                      color: const Color(0xFF504440)
                                          .withOpacity(0.4),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFFDF9F5),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 14,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(999),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  _newsletterCtrl.clear();
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('You\'re on the list!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF705347),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'JOIN',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: const Color(0xFFFDF9F5).withOpacity(0.82),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.menu,
                          color: Color(0xFF705347),
                          size: 22,
                        ),
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, '/cart'),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: Color(0xFF705347),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ZuhaBottomNav(
                currentIndex: 4,
                onTap: (i) {
                  if (i == 4) return;
                  ZuhaBottomNav.navigate(context, i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1EDE9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF504440), size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1C19),
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFD4C3BD),
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DarkModeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 26,
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFF705347)
              : const Color(0xFFD4C3BD).withOpacity(0.4),
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
