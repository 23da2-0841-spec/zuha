import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImage = 0;
  String? _selectedSize;
  int _selectedColorIndex = 0;
  int _quantity = 1;
  final PageController _pageController = PageController();

  static const _swatchHexes = [
    Color(0xFF705347),
    Color(0xFF48654E),
    Color(0xFFD4C3BD),
    Color(0xFF1C1C19),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addToCart(ZProduct product) {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a size'),
          backgroundColor: const Color(0xFF705347),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final color = product.colors.isNotEmpty
        ? product.colors[_selectedColorIndex % product.colors.length]
        : 'Default';

    context.read<CartProvider>().addItem(
      product,
      _selectedSize!,
      color,
      quantity: _quantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to bag'),
        backgroundColor: const Color(0xFF705347),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'View Bag',
          textColor: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)?.settings.arguments as ZProduct?;

    if (product == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Product not found',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 14,
              color: const Color(0xFF504440).withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(product.id);
    final images = product.images.isNotEmpty ? product.images : [product.imageUrl];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 520,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          onPageChanged: (i) =>
                              setState(() => _currentImage = i),
                          itemBuilder: (context, i) => Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFFEBE7E4)),
                          ),
                        ),
                        Positioned(
                          top: 84,
                          right: 20,
                          child: Column(
                            children: [
                              _FloatingActionBtn(
                                icon: isWishlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                onTap: () => wishlist.toggle(product.id),
                              ),
                              const SizedBox(height: 12),
                              _FloatingActionBtn(
                                icon: Icons.share_outlined,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (i) {
                                final isActive = i == _currentImage;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  width: isActive ? 28 : 8,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF705347)
                                        : Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -28),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x08705347),
                            blurRadius: 50,
                            offset: Offset(0, -20),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7E8CB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              product.brand.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Color(0xFF4C6952),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontFamily: 'DMSerifDisplay',
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF1C1C19),
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'LKR ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF48654E),
                                ),
                              ),
                              if (product.originalPrice != null) ...[
                                const SizedBox(width: 10),
                                Text(
                                  'LKR ${product.originalPrice!.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 14,
                                    color: const Color(0xFF504440)
                                        .withOpacity(0.4),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                              const Spacer(),
                              Icon(Icons.star_rounded,
                                  size: 16, color: const Color(0xFFF59E0B)),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating} (${product.reviewCount})',
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 12,
                                  color: Color(0xFF504440),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _SectionLabel(label: 'Select Palette'),
                          const SizedBox(height: 12),
                          Row(
                            children: List.generate(
                              product.colors.length.clamp(0, 4),
                              (i) {
                                final isActive = i == _selectedColorIndex;
                                final color = i < _swatchHexes.length
                                    ? _swatchHexes[i]
                                    : const Color(0xFF705347);
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedColorIndex = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 14),
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: isActive
                                          ? Border.all(
                                              color: color,
                                              width: 2,
                                            )
                                          : null,
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: color.withOpacity(0.4),
                                                blurRadius: 0,
                                                spreadRadius: 3,
                                              ),
                                              BoxShadow(
                                                color: Colors.white,
                                                blurRadius: 0,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const _SectionLabel(label: 'Choose Size'),
                              Text(
                                'SIZE GUIDE',
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  color: Color(0xFF705347),
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(0xFF705347),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: product.sizes.map((size) {
                              final isActive = _selectedSize == size;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedSize = size),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 68,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF705347)
                                        : const Color(0xFFF1EDE9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF705347)
                                                  .withOpacity(0.2),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 13,
                                        fontWeight: isActive
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: isActive
                                            ? Colors.white
                                            : const Color(0xFF504440),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 28),
                          const _SectionLabel(label: 'The Narrative'),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: const Color(0xFF504440).withOpacity(0.9),
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Text(
                                'Read full artisan story',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF705347),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.east,
                                  size: 14, color: Color(0xFF705347)),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            children: [
                              Expanded(
                                child: _FeatureTile(
                                  icon: Icons.eco_outlined,
                                  title: 'Sustainable',
                                  subtitle:
                                      '100% biodegradable organic fibers',
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _FeatureTile(
                                  icon: Icons.local_shipping_outlined,
                                  title: 'Couture Shipping',
                                  subtitle:
                                      'Plastic-free premium packaging',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
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
                    color: const Color(0xFFFDF9F5).withOpacity(0.75),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      bottom: 10,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        _NavIconBtn(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                          ),
                        ),
                        const Spacer(),
                        _NavIconBtn(
                          icon: Icons.shopping_bag_outlined,
                          onTap: () =>
                              Navigator.pushNamed(context, '/cart'),
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
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 8,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF9F5).withOpacity(0.88),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: const Color(0xFFD4C3BD).withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF705347).withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, -10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBE7E4),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _StepperBtn(
                                  icon: Icons.remove,
                                  onTap: () {
                                    if (_quantity > 1) {
                                      setState(() => _quantity--);
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '$_quantity',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1C1C19),
                                    ),
                                  ),
                                ),
                                _StepperBtn(
                                  icon: Icons.add,
                                  onTap: () => setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _addToCart(product),
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF705347),
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF705347)
                                          .withOpacity(0.2),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart_outlined,
                                        color: Colors.white, size: 18),
                                    SizedBox(width: 10),
                                    Text(
                                      'ADD TO ATELIER BAG',
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _NavIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F3EF),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Icon(icon, color: const Color(0xFF705347), size: 20),
      ),
    );
  }
}

class _FloatingActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _FloatingActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF705347), size: 20),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
        color: Color(0xFF504440),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3EF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF705347), size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C19),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: const Color(0xFF504440).withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(icon, color: const Color(0xFF705347), size: 18),
      ),
    );
  }
}
