import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/zuha_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNav = 0;
  int _selectedCategory = 0;
  final FirestoreService _firestoreService = FirestoreService();

  static const _categories = ['NEW IN', 'WOMEN', 'MEN', 'ACCESSORIES', 'SHOES'];

  final _navRoutes = [null, '/explore', '/cart', '/orders', '/profile'];

  void _onNavTap(int index) {
    if (index == 0) return;
    Navigator.pushNamed(context, _navRoutes[index]!);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final firstName = user?.name.split(' ').first ?? 'Guest';
    final userId = auth.currentUser?.id;
    if (userId != null) {
      context.read<CartProvider>().ensureInitialized(userId);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF9F5),
        extendBody: true,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 72)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $firstName',
                          style: const TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 38,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF1C1C19),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Discover your seasonal wardrobe.',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            color: const Color(0xFF504440).withOpacity(0.8),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<List<ZProduct>>(
                  stream: _firestoreService.getProducts(),
                  builder: (context, snapshot) {
                    final allProducts = snapshot.data ?? <ZProduct>[];
                    final featured =
                        allProducts.where((p) => p.isFeatured).toList();
                    final newArrivals =
                        allProducts.where((p) => p.isNew).toList();
                    final bannerImg = allProducts.isNotEmpty
                        ? allProducts.first.imageUrl
                        : 'https://images.unsplash.com/photo-1523381294911-8d3cead13475?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80';

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: _PromoBanner(
                            imageUrl: bannerImg,
                            onTap: () =>
                                Navigator.pushNamed(context, '/explore'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28, bottom: 0),
                          child: SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, i) {
                                final isActive = i == _selectedCategory;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedCategory = i),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFF705347)
                                          : const Color(0xFFF1EDE9),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      _categories[i],
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        color: isActive
                                            ? Colors.white
                                            : const Color(0xFF504440),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 32, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Featured',
                                style: TextStyle(
                                  fontFamily: 'DMSerifDisplay',
                                  fontSize: 28,
                                  color: Color(0xFF1C1C19),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/explore'),
                                child: const Text(
                                  'VIEW ALL',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF705347),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: _StaggeredProductGrid(
                            products: featured.take(4).toList(),
                            onProductTap: (product) =>
                                Navigator.pushNamed(context, '/product',
                                    arguments: product),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24, 40, 24, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'New Arrivals',
                                style: TextStyle(
                                  fontFamily: 'DMSerifDisplay',
                                  fontSize: 28,
                                  color: Color(0xFF1C1C19),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/explore'),
                                child: const Text(
                                  'EXPLORE',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF705347),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 460,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24),
                              itemCount: newArrivals.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 20),
                              itemBuilder: (context, i) {
                                return _NewArrivalCard(
                                  product: newArrivals[i],
                                  isEditorsPick: i == 0,
                                  onTap: () => Navigator.pushNamed(
                                      context, '/product',
                                      arguments: newArrivals[i]),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 110),
                      ]),
                    );
                  },
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
                    color: const Color(0xFFFDF9F5).withOpacity(0.82),
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 8,
                      bottom: 12,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                          color: const Color(0xFF705347),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const Spacer(),
                        const Text(
                          'Zuha',
                          style: TextStyle(
                            fontFamily: 'DMSerifDisplay',
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF705347),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/search'),
                              icon: const Icon(Icons.search),
                              color: const Color(0xFF705347),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/cart'),
                              icon: const Icon(Icons.shopping_bag_outlined),
                              color: const Color(0xFF705347),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ZuhaBottomNav(
          currentIndex: _currentNav,
          onTap: (i) {
            setState(() => _currentNav = i);
            _onNavTap(i);
          },
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _PromoBanner({required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 420,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEBE7E4),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.45),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 28,
              right: 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEW SEASON',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The Linen\nEdit',
                    style: TextStyle(
                      fontFamily: 'DMSerifDisplay',
                      fontSize: 44,
                      color: Colors.white,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF705347),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Shop Now',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredProductGrid extends StatelessWidget {
  final List<ZProduct> products;
  final void Function(ZProduct) onProductTap;

  const _StaggeredProductGrid(
      {required this.products, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    final rows = <List<ZProduct>>[];
    for (var i = 0; i < products.length; i += 2) {
      rows.add([
        products[i],
        if (i + 1 < products.length) products[i + 1],
      ]);
    }

    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProductCard(
                  product: row[0],
                  onTap: () => onProductTap(row[0]),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: row.length > 1
                    ? Padding(
                        padding: const EdgeInsets.only(top: 48),
                        child: _ProductCard(
                          product: row[1],
                          onTap: () => onProductTap(row[1]),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ZProduct product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: const Color(0xFFF7F3EF)),
                  Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFFEBE7E4)),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<WishlistProvider>().toggle(product.id),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 16,
                          color: const Color(0xFF705347),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.brand.toUpperCase(),
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: const Color(0xFF504440).withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C19),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'LKR ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF705347),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewArrivalCard extends StatelessWidget {
  final ZProduct product;
  final bool isEditorsPick;
  final VoidCallback onTap;

  const _NewArrivalCard({
    required this.product,
    required this.isEditorsPick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 320,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: const Color(0xFFF7F3EF)),
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFEBE7E4)),
                    ),
                    if (isEditorsPick)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC7E8CB),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            "EDITOR'S PICK",
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: Color(0xFF4C6952),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1C19),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              product.brand,
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 11,
                color: const Color(0xFF504440).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'LKR ${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'DMSans',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF705347),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
