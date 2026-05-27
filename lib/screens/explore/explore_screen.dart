import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../models/product.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/firestore_service.dart';
import '../../widgets/common/zuha_bottom_nav.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedFilter = 0;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final FirestoreService _firestoreService = FirestoreService();

  static const _filters = ['All', 'Women', 'Men', 'Accessories', 'Eco-Line'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ZProduct> _filteredProducts(List<ZProduct> products) {
    if (_selectedFilter > 0 && _selectedFilter < 4) {
      final cat = _filters[_selectedFilter];
      products = products.where((p) => p.category == cat).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: _SearchBar(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 0),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              itemCount: _filters.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, i) {
                                final isActive = i == _selectedFilter;
                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedFilter = i),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFF705347)
                                          : const Color(0xFFF1EDE9),
                                      borderRadius:
                                          BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      _filters[i],
                                      style: TextStyle(
                                        fontFamily: 'DMSans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
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
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 24, left: 8),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: const Color(0xFFD4C3BD)
                                        .withOpacity(0.3),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 18,
                                    color: const Color(0xFF504440)
                                        .withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'SORT',
                                    style: TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: const Color(0xFF504440)
                                          .withOpacity(0.7),
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
                ),
                StreamBuilder<List<ZProduct>>(
                  stream: _firestoreService.getProducts(),
                  builder: (context, snapshot) {
                    final allProducts = snapshot.data ?? <ZProduct>[];
                    final products = _filteredProducts(allProducts);

                    if (products.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 14,
                                color: const Color(0xFF504440)
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverToBoxAdapter(
                      child: _StaggeredGrid(
                        products: products,
                        onTap: (p) => Navigator.pushNamed(
                            context, '/product',
                            arguments: p),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: _EditorialBanner(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 110)),
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
                          ),
                        ),
                        const Spacer(),
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
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ZuhaBottomNav(
          currentIndex: 1,
          onTap: (i) {
            if (i == 1) return;
            ZuhaBottomNav.navigate(context, i);
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        fontFamily: 'DMSans',
        fontSize: 14,
        color: Color(0xFF1C1C19),
      ),
      decoration: InputDecoration(
        hintText: 'Search Zuha...',
        hintStyle: TextStyle(
          fontFamily: 'DMSans',
          fontSize: 14,
          color: const Color(0xFF82746F).withOpacity(0.6),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 20, right: 12),
          child: Icon(Icons.search, color: Color(0xFF82746F), size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: const Color(0xFFF1EDE9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _StaggeredGrid extends StatelessWidget {
  final List<ZProduct> products;
  final void Function(ZProduct) onTap;

  const _StaggeredGrid({required this.products, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const offsets = [0.0, 32.0, -32.0, 0.0];

    final rows = <List<ZProduct>>[];
    for (var i = 0; i < products.length; i += 2) {
      rows.add([
        products[i],
        if (i + 1 < products.length) products[i + 1],
      ]);
    }

    return Column(
      children: List.generate(rows.length, (ri) {
        final row = rows[ri];
        final leftOffset = offsets[(ri * 2) % offsets.length];
        final rightOffset = offsets[(ri * 2 + 1) % offsets.length];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: leftOffset > 0 ? leftOffset : 0,
                    bottom: leftOffset < 0 ? -leftOffset : 0,
                  ),
                  child: _ExploreProductCard(
                    product: row[0],
                    badge: row[0].isFeatured ? "Editor's Pick" : null,
                    onTap: () => onTap(row[0]),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: row.length > 1
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: rightOffset > 0 ? rightOffset : 0,
                          bottom: rightOffset < 0 ? -rightOffset : 0,
                        ),
                        child: _ExploreProductCard(
                          product: row[1],
                          badge: row[1].isNew ? 'New' : null,
                          onTap: () => onTap(row[1]),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ExploreProductCard extends StatelessWidget {
  final ZProduct product;
  final String? badge;
  final VoidCallback onTap;

  const _ExploreProductCard({
    required this.product,
    this.badge,
    required this.onTap,
  });

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
              borderRadius: BorderRadius.circular(14),
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
                          color: const Color(0xFFF1EDE9).withOpacity(0.5),
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
                  if (badge != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7E8CB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge!.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: Color(0xFF4C6952),
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
            product.category.toUpperCase(),
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: const Color(0xFF82746F).withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C19),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'LKR ${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF705347),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditorialBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFEBE7E4)),
            ),
          ),
        ),
        Positioned(
          bottom: -24,
          right: 16,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.58,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'The Summer Residency',
                  style: TextStyle(
                    fontFamily: 'DMSerifDisplay',
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF705347),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Explore a curated selection designed for the slow, golden hours of coastal living.',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 11,
                    color: const Color(0xFF504440).withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'VIEW STORY',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF705347),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF705347),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
