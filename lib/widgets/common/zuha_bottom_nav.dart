import 'package:flutter/material.dart';
import 'dart:ui';

class ZuhaBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const ZuhaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'HOME'),
    (icon: Icons.search, activeIcon: Icons.search, label: 'EXPLORE'),
    (
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
      label: 'CART'
    ),
    (
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      label: 'ORDERS'
    ),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'PROFILE'),
  ];

  static const _routes = ['/home', '/explore', '/cart', '/orders', '/profile'];

  static void navigate(BuildContext context, int index) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      _routes[index],
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFDF9F5).withOpacity(0.88),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF705347).withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedScale(
                  scale: isActive ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFF705347)
                            : const Color(0xFF504440).withOpacity(0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 9,
                          letterSpacing: 0.5,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: isActive
                              ? const Color(0xFF705347)
                              : const Color(0xFF504440).withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
